require 'ostruct'

module ATDOCleanup
  # class stores attributes of DigitalObject records
  class DigitalObject
    TABLE = 'DigitalObjects'.freeze
    ATTRS = %w(digitalObjectId
               metsIdentifier
               title
               dateExpression
               dateBegin
               dateEnd
               createdBy
               lastUpdatedBy
               created
               lastUpdated
               archDescriptionInstancesId
    ).freeze
    URI_REGEXP = %r(http://webarchives\.cdlib\.org)
    
    def self.new(args)
      OpenStruct.new(args)
    end

    def self.dupe?(args)
      a = args[:auth]
      d = args[:dupe]
      c = args[:client]

      result = true
      result &&= (a.send(METS_ID_ATTR) == d.send(METS_ID_ATTR))
      result &&= (a.send(TITLE_ATTR) == d.send(TITLE_ATTR))
      result &&= (a.send(DATE_EXPRESSION_ATTR) == d.send(DATE_EXPRESSION_ATTR))
      result &&= (a.send(DATE_BEGIN_ATTR) == d.send(DATE_BEGIN_ATTR))
      result &&= (a.send(DATE_END_ATTR) == d.send(DATE_END_ATTR))

      result &&= (a.send(CREATED_BY_ATTR) == d.send(CREATED_BY_ATTR))
      result &&= (a.send(LAST_UPDATED_BY_ATTR) == d.send(LAST_UPDATED_BY_ATTR))
      result &&= (a.send(CREATED_BY_ATTR) == CREATED_BY_VALUE)
      result &&= (a.send(LAST_UPDATED_BY_ATTR) == LAST_UPDATED_BY_VALUE)

      result &&= (a.send(CREATED_ATTR) > d.send(CREATED_ATTR))
      result &&= (a.send(LAST_UPDATED_ATTR) > d.send(LAST_UPDATED_ATTR))
      result &&= d.send(ARCH_INST_ID_ATTR).nil?

      # if REGEXP matches, then keep record (it is NOT considered a dupe)
      fv = get_file_version(dupe: d, client: c)
      result && URI_REGEXP.match(fv[URI_ATTR]).nil?
    end

    def self.find_duplicate_records(args)
      client = args[:client]
      query = "SELECT * \
FROM #{DO_TABLE} \
WHERE #{ARCH_INST_ID_ATTR} IS NULL \
AND #{METS_ID_ATTR} <> ''"

      client.query(query)
    end

    # find the record linked to a resource for the specified mets id
    def self.find_authoritative_record(args)
      client  = args[:client]
      mets_id = args[:mets_id]
      raise ArgumentError, 'missing parameter mets_id:' unless mets_id

      query = "SELECT * \
FROM #{DO_TABLE} \
WHERE #{ARCH_INST_ID_ATTR} IS NOT NULL \
AND #{METS_ID_ATTR} = '#{mets_id}'"
      results = client.query(query)
      if results.count > 1
        raise AuthRecordError, "ERROR: too many records matching authoritative record criteria found for metsIdentifier #{mets_id}"
      end
      results.count == 0 ? nil : results.first
    end

    # .delete
    # purpose:
    #   delete a record from DO_TABLE using primary key DO_ID_ATTR
    #
    # arguments:
    #   args[:client] = database client object to which queries are passed
    #   args[:file_version] = an object that responds to .send(FILE_VERSION_ID_ATTR)
    def self.delete(args)
      client = args[:client]
      digital_object = args[:digital_object]
      raise ArgumentError, 'missing parameter digital_object:' unless digital_object

      query = "DELETE \
FROM #{DO_TABLE} \
WHERE #{DO_ID_ATTR} = #{digital_object.send(DO_ID_ATTR)}"

      puts query
      client.query(query)
    end

    def self.get_file_version(args)
      client = args[:client]
      dupe   = args[:dupe]
      query = "SELECT * FROM #{FV_TABLE} WHERE #{DO_ID_ATTR} = #{dupe.send(DO_ID_ATTR)}"
      results = client.query(query)
      raise "ERROR: too many file versions!}" if results.count > 1
      results.first
    end
  end
end
