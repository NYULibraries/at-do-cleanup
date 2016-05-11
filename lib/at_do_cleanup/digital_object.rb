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
      result &&= (a.send(METS_ID_ATTR) == d.send(METS_ID_ATTR))
      result &&= (a.send(TITLE_ATTR) == d.send(TITLE_ATTR))
      result &&= (a.send(DATE_EXPRESSION_ATTR) == d.send(DATE_EXPRESSION_ATTR))
      result &&= (a.send(DATE_BEGIN_ATTR) == d.send(DATE_BEGIN_ATTR))
      result &&= (a.send(DATE_END_ATTR) == d.send(DATE_END_ATTR))

      result &&= (a.send(CREATED_BY_ATTR) == d.send(CREATED_BY_ATTR))
      result &&= (a.send(LAST_UPDATED_BY_ATTR) == d.send(LAST_UPDATED_BY_ATTR))
      result &&= (a.send(CREATED_BY_ATTR) == CREATED_BY_VALUE)
      result &&= (a.send(LAST_UPDATED_BY_ATTR) == LAST_UPDATED_BY_VALUE)

      result &&= (a.send(CREATED_ATTR) > d.send(CREATED_ATTR))
      result &&= (a.send(LAST_UPDATED_ATTR) > d.send(LAST_UPDATED_ATTR))
      result && d.send(ARCH_INST_ID_ATTR).nil?
      # missing URI check
    end
  end
end
