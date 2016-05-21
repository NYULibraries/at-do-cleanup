require 'ostruct'

module ATDOCleanup
  class ListOrderedItem < GenericItem
    TABLE_NAME = 'ListOrderedItems'.freeze
    FK_ID_ATTR = 'parentId'.freeze
  end
end
