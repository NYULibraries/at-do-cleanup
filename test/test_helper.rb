require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

DUPE_HASH = {
  'digitalObjectId' => 8343,
  'version' => 1,
  'lastUpdated' => '2013-03-07 11:19:45 -0500',
  'created' => '2012-09-27 13:43:55 -0400',
  'lastUpdatedBy' => 'dlts',
  'createdBy' => 'dlts',
  'title' => 'The baracon: Nela',
  'dateExpression' => '1948',
  'dateBegin' => 1948,
  'dateEnd' => 1948,
  'languageCode' => '',
  'restrictionsApply' => '\x00',
  'eadDaoActuate' => '',
  'eadDaoShow' => '',
  'metsIdentifier' => 'RISM MC 1.ref197.1',
  'objectType' => '',
  'label' => '',
  'objectOrder' => 0,
  'parentDigitalObjectId' => nil,
  'archDescriptionInstancesId' => nil,
  'componentId' => '',
  'repositoryId' => 2
}.freeze

AUTHORITATIVE_HASH = {
  'digitalObjectId' => 8716,
  'version' => 0,
  'lastUpdated' => '2013-03-07 12:01:20 -0500',
  'created' => '2013-03-07 12:01:20 -0500',
  'lastUpdatedBy' => 'dlts',
  'createdBy' => 'dlts',
  'title' => 'The baracon: Nela',
  'dateExpression' => '1948',
  'dateBegin' => 1948,
  'dateEnd' => 1948,
  'languageCode' => '',
  'restrictionsApply' => '\x00',
  'eadDaoActuate' => '',
  'eadDaoShow' => '',
  'metsIdentifier' => 'RISM MC 1.ref197.1',
  'objectType' => '',
  'label' => '',
  'objectOrder' => 0,
  'parentDigitalObjectId' => nil,
  'archDescriptionInstancesId' => 11_516_334,
  'componentId' => '',
  'repositoryId' => 2
}.freeze
