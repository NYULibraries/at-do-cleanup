module ATDOCleanup
  class Cleaner
    attr_reader :client
    def initialize(args)
      @client = args[:client]
    end

    def clean!
      status = 0
      begin
        duplicate_records = get_duplicate_records(client: client)
        puts duplicate_records.count

        begin_transaction(client: client)
        process_duplicate_records(client: client, duplicate_records: duplicate_records)
      rescue StandardError, Mysql2::Error => error
        rollback_transaction(client: client)
        $stderr.puts error.message
        status = 1
      end
      rollback_transaction(client: client)
      status
    end

    private

    # get duplicate digital object records
    def get_duplicate_records(args)
      DigitalObject.find_duplicate_records(client: client)
    end

    def begin_transaction(args)
      puts 'BEGIN TRANSACTION...'
      args[:client].query('START TRANSACTION')
    end

    def rollback_transaction(args)
      puts 'ROLLBACK'
      args[:client].query('ROLLBACK')
    end

    def commit_transaction(args)
      puts 'COMMIT'
      args[:client].query('COMMIT')
    end

    def get_authoritative_do(args)
      mets_id = args[:dupe].send(METS_ID_ATTR)
      results = DigitalObject.find_authoritative_record(client: args[:client], mets_id: mets_id)
      unless results.count == 1
        raise "ERROR: incorrect number of authoritative records (#{results.count}) for metsIdentifier #{mets_id}"
      end
      DigitalObject.new(results.first)
    end

    def assert_dupe(auth, dupe)
      raise 'dupe failed dupe? test' unless DigitalObject.dupe?(auth: auth, dupe: dupe)
    end

    def get_results(args)
      query = "SELECT * FROM #{args[:table]} WHERE #{args[:fk_attr]} = #{args[:fk_value]}"
      client.query(query)
    end

    def delete_record(args)
      query = "DELETE FROM #{args[:table]} WHERE #{args[:fk_attr]} = #{args[:fk_value]}"
      puts query
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

    def delete_dupe(args)
      DigitalObject.delete(client: args[:client], digital_object: args[:dupe])
    end

    def process_dupe(args)
      auth = get_authoritative_do(args)
      assert_dupe(auth, args[:dupe])
      do_id = args[:dupe].send(DO_ID_ATTR)
      delete_file_versions(do_id)
      delete_assessments_digital_objects(do_id)
      delete_arch_description_dates(do_id)
      delete_arch_description_names(do_id)
      delete_arch_description_subjects(do_id)
      delete_arch_description_repeating_data(do_id)
      delete_dupe(args)
    end

    def process_duplicate_records(args)
      args[:duplicate_records].each do |d|
        dupe = DigitalObject.new(d)
        process_dupe(client: args[:client], dupe: dupe)
      end
    end
  end
end
