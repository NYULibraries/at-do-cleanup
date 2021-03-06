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
    u = DigitalObject.new(DUPE_HASH_WITH_PROTECTED_URI)
    v = DigitalObject.new(DUPE_HASH_WITH_MULTIPLE_NON_PROTECTED_URIS)
    x = DigitalObject.new(DUPE_HASH_WITH_MULTIPLE_URIS_ONE_PROTECTED)
    
    assert(DigitalObject.dupe?(auth: a, dupe: d), 'dupe? assertion failed')
    refute(DigitalObject.dupe?(auth: a, dupe: a), 'dupe? refutation failed')
    refute(DigitalObject.dupe?(auth: a, dupe: u), 'dupe? URI refutation failed')
    assert(DigitalObject.dupe?(auth: a, dupe: v), 'dupe? assertion failed for multiple non-protected URIs')
    refute(DigitalObject.dupe?(auth: a, dupe: x), 'dupe? assertion failed for multiple URIs, one protected')
  end

  def test_attr_equal?
    d = DigitalObject.new(DUPE_HASH)
    a = DigitalObject.new(AUTHORITATIVE_HASH)

    assert(DigitalObject.attr_equal?('title', a, d), 'attr_equal? true failed')
    refute(DigitalObject.attr_equal?('digitalObjectId', a, d), 'attr_equal? false failed')
  end
end
