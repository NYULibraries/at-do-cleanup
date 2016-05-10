require_relative './test_helper'
require_relative '../lib/at_do_cleanup'

class TestDigitalObject < Minitest::Test
  def test_new_digital_object
    d = ATDOCleanup::DigitalObject.new(a: 'this is a', b: 'this is b')
    assert(d.a == 'this is a', "expected '#{d.a}' to be 'this is a'")
  end
end
