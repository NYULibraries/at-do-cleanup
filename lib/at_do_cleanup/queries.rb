module ATDOCleanup
  # class encapsulates database queries
  class Queries
    # select statement to detect duplicates
    def self.dup_query
      "SELECT * \
FROM #{DO_TABLE} \
WHERE #{ARCH_INST_ID_ATTR} IS NULL \
AND #{CREATED_BY_ATTR} = '#{CREATED_BY_VALUE}' \
AND #{LAST_UPDATED_BY_ATTR} = '#{LAST_UPDATED_BY_VALUE}' \
AND #{METS_ID_ATTR} <> ''"
    end

    # find the record linked to a resource for the specified mets id
    def self.authoritative_record_query(params)
      raise 'missing parameter mets_id:' unless params[:mets_id]

      "SELECT * \
FROM #{DO_TABLE} \
WHERE #{ARCH_INST_ID_ATTR} IS NOT NULL \
AND #{CREATED_BY_ATTR} = '#{CREATED_BY_VALUE}' \
AND #{LAST_UPDATED_BY_ATTR} = '#{LAST_UPDATED_BY_VALUE}' \
AND #{METS_ID_ATTR} = '#{params[:mets_id]}'"
    end
  end
end
