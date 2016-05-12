require 'ostruct'

module ATDOCleanup
  # class stores attributes of DigitalObject records
  class FileVersion
    def self.new(params)
      OpenStruct.new(params)
    end

    def self.find_records_for_digital_object(args)
      client = args[:client]
      digital_object_id = args[:do_id]
      raise ArgumentError, 'missing parameter digital_object_id:' unless digital_object_id

      query = "SELECT * \
FROM #{FV_TABLE} \
WHERE #{DO_ID_ATTR} = #{digital_object_id}"

      client.query(query)
    end

    def self.delete(args)
      client = args[:client]
      file_version = args[:file_version]
      raise ArgumentError, 'missing parameter file_version:' unless file_version

      query = "DELETE \
FROM #{FV_TABLE} \
WHERE #{FILE_VERSION_ID_ATTR} = #{file_version.send(FILE_VERSION_ID_ATTR)}"

      puts query
      client.query(query)
    end
end
end
