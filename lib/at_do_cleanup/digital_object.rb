require 'ostruct'

module ATDOCleanup
  # class stores attributes of DigitalObject records
  class DigitalObject
    def self.new(params)
      OpenStruct.new(params)
    end

    def self.dupe?(params)
      a = params[:auth]
      d = params[:dupe]
      result = true
      result &&= (a.metsIdentifier == d.metsIdentifier)
      result &&= (a.title == d.title)
      result &&= (a.dateExpression == d.dateExpression)
      result &&= (a.dateBegin == d.dateBegin)
      result &&= (a.dateEnd == d.dateEnd)

      result &&= (a.createdBy == d.createdBy)
      result &&= (a.lastUpdatedBy == d.lastUpdatedBy)
      result &&= (a.createdBy == 'dlts')
      result &&= (a.lastUpdatedBy == 'dlts')

      result &&= (a.created > d.created)
      result &&= (a.lastUpdated > d.lastUpdated)
      result && d.archDescriptionInstancesId.nil?
      # missing URI check
    end
  end
end
