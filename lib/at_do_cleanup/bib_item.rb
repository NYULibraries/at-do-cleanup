require 'ostruct'

module ATDOCleanup
  class BibItem < GenericItem
    TABLE_NAME = 'BibItems'.freeze
    FK_ID_ATTR = 'parentId'.freeze
  end
end
