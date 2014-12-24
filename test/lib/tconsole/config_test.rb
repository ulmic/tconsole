require 'test_helper'

include TConsole

class ConfigTest < TestCase
  def setup
    @config = TConsole::Config.new(:minitest, [])
    @config.test_dir = "./spec/fixtures/minitest"
  end

  def test_when_configured_test_directory_does_not_exist
    @config.test_dir = "./monkey_business"
    assert_equal @config.validates_errors[0], 'Couldn\'t find test directory `./monkey_business`. Exiting.'
  end
end
