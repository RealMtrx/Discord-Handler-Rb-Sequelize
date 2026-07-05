require 'logger'

module LoggerSetup
  @logger = Logger.new($stdout)
  @logger.formatter = proc do |severity, datetime, _progname, msg|
    "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] [#{severity}] #{msg}\n"
  end

  def self.info(msg)
    @logger.info(msg)
  end

  def self.warn(msg)
    @logger.warn(msg)
  end

  def self.error(msg)
    @logger.error(msg)
  end

  def self.debug(msg)
    @logger.debug(msg)
  end
end
