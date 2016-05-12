require 'ostruct'

module ATDOCleanup
  # class stores attributes of DigitalObject records
  class DigitalObject
    def self.new(args)
      OpenStruct.new(args)
    end

    def self.dupe?(args)
      a = args[:auth]
      d = args[:dupe]
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
      result && d.send(ARCH_INST_ID_ATTR).nil?
      # missing URI check
    end

    def self.find_duplicate_records(args)
      client = args[:client]
      query = "SELECT * \
FROM #{DO_TABLE} \
WHERE #{ARCH_INST_ID_ATTR} IS NULL \
AND #{CREATED_BY_ATTR} = '#{CREATED_BY_VALUE}' \
AND #{LAST_UPDATED_BY_ATTR} = '#{LAST_UPDATED_BY_VALUE}' \
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
AND #{CREATED_BY_ATTR} = '#{CREATED_BY_VALUE}' \
AND #{LAST_UPDATED_BY_ATTR} = '#{LAST_UPDATED_BY_VALUE}' \
AND #{METS_ID_ATTR} = '#{mets_id}'"
      client.query(query)
    end
  end
end
