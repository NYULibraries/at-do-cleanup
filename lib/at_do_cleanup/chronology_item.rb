module ATDOCleanup
  class ChronologyItem
    TABLE_NAME = 'ChronologyItems'.freeze
    FK_ID_ATTR = 'parentId'.freeze
    DEPENDENT_FK_ATTR = 'archDescStructDataItemId'.freeze

    DEPENDENT_CLASS = 'Event'.freeze
    DEPENDENT_TABLE_NAME = 'Events'.freeze

    def self.delete(args)
      client = args[:client]
      fk_id  = args[:fk_id]

      raise ArgumentError, 'missing client' unless client
      raise ArgumentError, 'missing fk_id'  unless fk_id

      query = "SELECT #{DEPENDENT_FK_ATTR} 


      
      query = "DELETE FROM #{TABLE_NAME} WHERE #{FK_ID_ATTR} = #{fk_id}"

      puts query
      client.query(query)
    end
  end
end

