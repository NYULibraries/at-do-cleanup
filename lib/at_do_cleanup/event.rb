require 'ostruct'

module ATDOCleanup
  class Event < GenericItem
    TABLE_NAME = 'Events'.freeze
    FK_ID_ATTR = 'archDescStructDataItemId'.freeze
  end
end
