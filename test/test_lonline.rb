require 'logger'
require 'test/unit'
require_relative '../lib/lonline'
require_relative '../lib/lonline_report'

class TestLonline < Test::Unit::TestCase
  # Setup the suite
  def setup
    Lonline::SETUP.load('test/lonline.yml', 'test')

    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG

    Lonline::SETUP.logger = logger
  end

  # Tests the four available methods for logging
  def test_lonline_levels
    Lonline.log.trace('Calling method Y')
    Lonline.log.debug('Creating new object')
    Lonline.log.info('Process has finished')
    Lonline.log.warn("It could'n create this object, the process will try later.")
    Lonline.log.error('Unable to load setting file')
    Lonline.log.fatal('The app has crashed and its state is unavailable')
  end

  # Tests lonline reports
  def test_lonline_report
    from = Time.now
    from = Time.new(from.year, from.month, from.day, 0, 0, 0)

    index = 0
    Lonline::Report.fetch(:fatal, from, Time.now.utc) do |log|
      index = index + 1

      puts log[:text] # Log you have sent
      puts log[:when] # When this log was created
      puts log[:trace] # Trace you have sent
    end

    count = Lonline::Report.count(:fatal, from, Time.now.utc)
    assert_equal count, index
  end
end