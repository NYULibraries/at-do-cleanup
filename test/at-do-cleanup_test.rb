require 'test_helper'
require 'open3'

class TestAtDoCleanup < MiniTest::Test

  COMMAND = 'bin/at-do-cleanup'.freeze
  EXPECTED_OUTPUT = `cat test/fixtures/output.txt`.freeze

  def test_exit_status_with_valid_text
    o, e, s = Open3.capture3(COMMAND)
    assert(s.exitstatus == 0, 'incorrect exit status')
    assert_equal(EXPECTED_OUTPUT, o, 'output mismatch')
    assert_equal('', e, "error text: #{e}")
  end
end
