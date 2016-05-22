require 'ostruct'

module ATDOCleanup
  # class stores attributes of DigitalObject records
  class ArchDescriptionRepeatingData
    # .find_records_for_digital_object
    # purpose:
    #   returns all records in AD_REPEATING_DATA_TABLE with DO_ID_ATTR = args[:do_id]
    #
    # arguments:
    #   args[:client] = database client object to which queries are passed
    #   args[:do_id]  = an integer used as a foreign key into FV_TABLE
    def self.find_records_for_digital_object(args)
      client = args[:client]
      digital_object_id = args[:do_id]
      raise ArgumentError, 'missing parameter digital_object_id:' unless digital_object_id

      query = "SELECT * \
FROM #{AD_REPEATING_DATA_TABLE} \
WHERE #{DO_ID_ATTR} = #{digital_object_id}"

      client.query(query)
    end

    # .delete
    # purpose:
    #   delete a record from FV_TABLE using the primary key FILE_VERSION_ID_ATTR
    #
    # arguments:
    #   args[:client] = database client object to which queries are passed
    #   args[:file_version] = an object that responds to .send(FILE_VERSION_ID_ATTR)
    def self.delete(args)
      client = args[:client]
      ard = args[:archive_repeating_data_object]
      raise ArgumentError, 'missing parameter file_version:' unless file_version

      query = "DELETE \
FROM #{AD_REPEATING_DATA_TABLE} \
WHERE #{AD_REPEATING_DATA_ID_ATTR} = #{ard.send(AD_REPEATING_DATA_ID_ATTR)}"

      puts query
      client.query(query)
    end
  end
end
