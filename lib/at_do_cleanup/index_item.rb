require 'ostruct'

module ATDOCleanup
  class IndexItem < GenericItem
    TABLE_NAME = 'IndexItems'.freeze
    FK_ID_ATTR = 'parentId'.freeze
  end
end
