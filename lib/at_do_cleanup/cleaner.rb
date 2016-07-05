module ATDOCleanup
  class Cleaner
    attr_reader :client, :commit
    def initialize(args)
      @client  = args[:client]
      options  = args[:options]    || {}
      @commit  = options[:commit]  || false
    end

    def clean!
      status = 0
      begin
        duplicate_records = find_duplicate_records
        verbose_print "duplicate-record candidate pool size: #{duplicate_records.count}"

        begin_transaction
        process_duplicate_records(duplicate_records)
        commit ? commit_transaction : rollback_transaction

      rescue StandardError, Mysql2::Error => error
        rollback_transaction
        $stderr.puts error.message
        status = 1
      end
      status
    end

    private
    def verbose_print(str)
      puts str
    end

    # get duplicate digital object records
    def find_duplicate_records
      DigitalObject.find_duplicate_records(client: client)
    end

    def begin_transaction
      verbose_print 'BEGIN TRANSACTION...'
      client.query('START TRANSACTION')
    end

    def rollback_transaction
      verbose_print 'ROLLBACK'
      client.query('ROLLBACK')
    end

    def commit_transaction
      verbose_print 'COMMIT'
      client.query('COMMIT')
    end

    def get_authoritative_do(dupe)
      mets_id = dupe.send(METS_ID_ATTR)
      result = DigitalObject.find_authoritative_record(client: client, mets_id: mets_id)
      result.nil? ? nil : DigitalObject.new(result)
    end

    def assert_dupe(auth, dupe)
      msg="auth: #{auth} \n dupe: #{dupe}"
      unless DigitalObject.dupe?(auth: auth, dupe: dupe, client: client)
        raise "failed dupe? test\n #{msg}"
      end
    end

    def get_results(args)
      query = "SELECT * FROM #{args[:table]} WHERE #{args[:fk_attr]} = #{args[:fk_value]}"
      client.query(query)
    end

    def delete_record(args)
      query = "DELETE FROM #{args[:table]} WHERE #{args[:fk_attr]} = #{args[:fk_value]}"
      verbose_print query
      client.query(query)
    end

    def get_file_version_records(do_id)
      get_results(table:   'FileVersions',
                  fk_attr: 'digitalObjectId',
                  fk_value: do_id)
    end

    def delete_file_versions(do_id)
      delete_record(table: 'FileVersions',
                    fk_attr: 'digitalObjectId',
                    fk_value: do_id)
    end

    def delete_arch_description_dates(do_id)
      delete_record(table: 'ArchDescriptionDates',
                    fk_attr: 'digitalObjectId',
                    fk_value: do_id)
    end

    def delete_assessments_digital_objects(do_id)
      delete_record(table: 'AssessmentsDigitalObjects',
                    fk_attr: 'digitalObjectId',
                    fk_value: do_id)
    end

    def delete_arch_description_names(do_id)
      delete_record(table: 'ArchDescriptionNames',
                    fk_attr: 'digitalObjectId',
                    fk_value: do_id)
    end

    def delete_arch_description_subjects(do_id)
      delete_record(table: 'ArchDescriptionSubjects',
                    fk_attr: 'digitalObjectId',
                    fk_value: do_id)
    end

    def delete_chronology_item(parent_id)
      results = get_results(table: 'ChronologyItems',
                            fk_attr: 'parentId',
                            fk_value: parent_id)

      results.each { |r| delete_event(r['archDescStructDataItemId']) }

      delete_record(table: 'ChronologyItems',
                    fk_attr: 'parentId',
                    fk_value: parent_id)
    end

    def delete_index_item(parent_id)
      delete_record(table: 'IndexItems',
                    fk_attr: 'parentId',
                    fk_value: parent_id)
    end

    def delete_bib_item(parent_id)
      delete_record(table: 'BibItems',
                    fk_attr: 'parentId',
                    fk_value: parent_id)
    end

    def delete_list_ordered_item(parent_id)
      delete_record(table: 'ListOrderedItems',
                    fk_attr: 'parentId',
                    fk_value: parent_id)
    end

    def delete_list_definition__item(parent_id)
      delete_record(table: 'ListDefinitionItems',
                    fk_attr: 'parentId',
                    fk_value: parent_id)
    end

    def delete_event(arch_desc_struct_data_item_id)
      delete_record(table: 'Events',
                    fk_attr: 'archDescStructDataItemId',
                    fk_value: arch_desc_struct_data_item_id)
    end

    def delete_arch_description_repeating_data(do_id)
      #ArchDescriptionRepeatingData(digitalObjectId)   FK DigitalObjects(digitalObjectId)
      #<--- ChronologyItems(parentId)     FK ArchDescriptionRepeatingData(archDescriptionRepeatingDataId) <--- Events(archDescStructDataItemId) FK ChronologyItems(archDescStructDataItemId)
      #<--- IndexItems(parentId)          FK ArchDescriptionRepeatingData(archDescriptionRepeatingDataId)
      #<--- BibItems(parentId)            FK ArchDescriptionRepeatingData(archDescriptionRepeatingDataId)
      #<--- ListOrderedItems(parentId)    FK ArchDescriptionRepeatingData(archDescriptionRepeatingDataId)
      #<--- ListDefinitionItems(parentId) FK ArchDescriptionRepeatingData(archDescriptionRepeatingDataId)

      results = get_results(table:   'ArchDescriptionRepeatingData',
                            fk_attr: 'digitalObjectId',
                            fk_value: do_id)
      results.each do |r|
        id = r['archDescriptionRepeatingDataId']
        delete_chronology_item(id)
        delete_index_item(id)
        delete_bib_item(id)
        delete_list_ordered_item(id)
      end

      delete_record(table: 'ArchDescriptionRepeatingData',
                    fk_attr: 'digitalObjectId',
                    fk_value: do_id)
    end

    def delete_dupe(dupe)
      DigitalObject.delete(client: client, digital_object: dupe)
    end

    def process_dupe(dupe)
      auth = get_authoritative_do(dupe)

      if auth.nil?
        puts "WARNING: no authoritative record found for #{dupe.send(METS_ID_ATTR)} digitalObjectId = #{dupe.send(DO_ID_ATTR)}"
      else
        assert_dupe(auth, dupe)
        do_id = dupe.send(DO_ID_ATTR)
        delete_file_versions(do_id)
        delete_assessments_digital_objects(do_id)
        delete_arch_description_dates(do_id)
        delete_arch_description_names(do_id)
        delete_arch_description_subjects(do_id)
        delete_arch_description_repeating_data(do_id)
        delete_dupe(dupe)
      end
    end

    def process_duplicate_records(duplicate_records)
      duplicate_records.each do |d|
        fv = get_file_version(d)
        if fv
          # puts "#{d} FileVersion: #{fv}"
          d[FILE_VERSION_URI_ATTR] = fv[FILE_VERSION_URI_ATTR]
        else
          puts "WARNING: no file version for #{d[METS_ID_ATTR]} digitalObjectId = #{d[DO_ID_ATTR]}"
        end
        dupe = DigitalObject.new(d)
        process_dupe(dupe)
      end
    end

    def get_file_version(duplicate_record)
      query = "SELECT * FROM #{FV_TABLE} WHERE #{DO_ID_ATTR} = #{duplicate_record[DO_ID_ATTR]}"
      # puts query
      results = client.query(query)
      raise "ERROR: too many file versions! \n #{results}" if results.count > 1
      results.first
    end
  end
end
