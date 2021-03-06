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

    def self.attr_equal?(attr, a, d)
      result = (a.send(attr) == d.send(attr))
      unless result
        $stderr.puts "WARNING: attr_equal failed: #{attr} : '#{a.send(attr)}' != '#{d.send(attr)}'"
      end
      result
    end

    def self.attr_greater_than?(attr, a, d)
      result = (a.send(attr) > d.send(attr))
      unless result
        $stderr.puts "WARNING: attr_greater_than? failed: #{attr} : '#{a.send(attr)}' !> '#{d.send(attr)}'"
      end
      result
    end

    def self.pretty_format(arg)
      str = ''
      arg.each_pair {|k, v| str << sprintf("%27s --> %s\n", k, v) }
      str
    end

    def self.check_file_version_match(d)
      result = false
      a = d.send(FILE_VERSION_URI_ATTR) || []
      a.each do |fv|
        result ||= !(URI_REGEXP.match(fv).nil?)
      end
      result
    end

    def self.dupe?(args)
      a = args[:auth]
      d = args[:dupe]

      result = true
      [METS_ID_ATTR].each do |attr|
        result &&= attr_equal?(attr, a, d)
      end

      [CREATED_ATTR].each do |attr|
        result &&= attr_greater_than?(attr, a, d)
      end

      result &&= d.send(ARCH_INST_ID_ATTR).nil?

      # if REGEXP matches, then keep record (it is NOT considered a dupe)
      result && !check_file_version_match(d)
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
  end
end
