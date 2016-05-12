require_relative './test_helper'
require_relative '../lib/at_do_cleanup'

class TestUtils < Minitest::Test
  include ATDOCleanup
  def test_underscore
    assert('digital_object_id' == Utils.underscore('digitalObjectId'))
    assert('arch_description_instances_id' == Utils.underscore('archDescriptionInstancesId'))
  end
end
