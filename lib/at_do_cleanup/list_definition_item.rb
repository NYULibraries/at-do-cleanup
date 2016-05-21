require 'ostruct'

module ATDOCleanup
  class ListDefinitionItem < GenericItem
    TABLE_NAME = 'ListDefinitionItems'.freeze
    FK_ID_ATTR = 'parentId'.freeze
  end
end
