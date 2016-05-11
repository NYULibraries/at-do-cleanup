require_relative './test_helper'
require_relative '../lib/at_do_cleanup'

class TestDigitalObject < Minitest::Test
  include ATDOCleanup
  def test_new_digital_object
    d = DigitalObject.new(a: 'this is a', b: 'this is b')
    assert(d.a == 'this is a', "expected '#{d.a}' to be 'this is a'")
  end

  def test_dupe
    dupe_hash = {
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
    }

    authoritative_hash = {
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
      'archDescriptionInstancesId' => 11516334,
      'componentId' => '',
      'repositoryId' => 2
    }

    d = DigitalObject.new(dupe_hash)
    a = DigitalObject.new(authoritative_hash)

    assert(DigitalObject.dupe?(auth: a, dupe: d))
    refute(DigitalObject.dupe?(auth: a, dupe: a))
  end
end
