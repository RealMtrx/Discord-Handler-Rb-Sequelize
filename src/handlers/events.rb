module EventLoader
  def self.load(bot)
    Dir[File.join(__dir__, '..', 'events', '*.rb')].each do |file|
      require file
      filename = File.basename(file, '.rb')
      class_name = filename.split('_').map(&:capitalize).join
      event_class = Object.const_get(class_name) rescue nil

      next unless event_class

      event_class.register(bot) if event_class.respond_to?(:register)
      LoggerSetup.info("Loaded event: #{filename}")
    end
  end
end
