require 'ostruct'

module ATDOCleanup
  # class stores attributes of DigitalObject records
  class DigitalObject
    def self.new(params)
      OpenStruct.new(params)
    end
  end
end
