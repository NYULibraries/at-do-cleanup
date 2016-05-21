require 'ostruct'

module ATDOCleanup
  # class stores attributes of DigitalObject records
  class GenericItem
    def self.delete(args)
      client = args[:client]
      fk_id  = args[:fk_id]

      raise ArgumentError, 'missing client' unless client
      raise ArgumentError, 'missing fk_id'  unless fk_id

      query = "DELETE FROM #{TABLE_NAME} WHERE #{FK_ID_ATTR} = #{fk_id}"

      puts query
      client.query(query)
    end
  end
end
