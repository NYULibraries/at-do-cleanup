module ATDOCleanup
  # database table names, attribute names, and expected values
  DO_TABLE              = 'DigitalObjects'.freeze
  DO_ID_ATTR            = 'digitalObjectId'.freeze
  METS_ID_ATTR          = 'metsIdentifier'.freeze
  TITLE_ATTR            = 'title'.freeze
  DATE_EXPRESSION_ATTR  = 'dateExpression'.freeze
  DATE_BEGIN_ATTR       = 'dateBegin'.freeze
  DATE_END_ATTR         = 'dateEnd'.freeze
  CREATED_BY_ATTR       = 'createdBy'.freeze
  LAST_UPDATED_BY_ATTR  = 'lastUpdatedBy'.freeze
  CREATED_BY_VALUE      = 'dlts'.freeze
  LAST_UPDATED_BY_VALUE = 'dlts'.freeze
  CREATED_ATTR          = 'created'.freeze
  LAST_UPDATED_ATTR     = 'lastUpdated'.freeze
  ARCH_INST_ID_ATTR     = 'archDescriptionInstancesId'.freeze

  FV_TABLE              = 'FileVersions'.freeze
  URI_ATTR              = 'uri'.freeze
end
