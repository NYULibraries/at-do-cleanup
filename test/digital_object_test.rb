require 'test_helper'
require_relative '../lib/at_do_cleanup'

class TestDigitalObject < Minitest::Test
  include ATDOCleanup
  def test_new_digital_object
    d = DigitalObject.new(a: 'this is a', b: 'this is b')
    assert(d.a == 'this is a', "expected '#{d.a}' to be 'this is a'")
  end

  def test_dupe
    d = DigitalObject.new(DUPE_HASH)
    a = DigitalObject.new(AUTHORITATIVE_HASH)

    assert(DigitalObject.dupe?(auth: a, dupe: d))
    refute(DigitalObject.dupe?(auth: a, dupe: a))
  end

  def test_attr_equal?
    d = DigitalObject.new(DUPE_HASH)
    a = DigitalObject.new(AUTHORITATIVE_HASH)

    assert(DigitalObject.attr_equal?('title', a, d), 'attr_equal? true failed')
    refute(DigitalObject.attr_equal?('digitalObjectId', a, d), 'attr_equal? false failed')
  end
end
