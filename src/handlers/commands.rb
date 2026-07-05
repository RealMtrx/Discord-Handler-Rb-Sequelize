module CommandLoader
  def self.load(bot)
    Dir[File.join(__dir__, '..', 'commands', '**', '*.rb')].each do |file|
      require file
      filename = File.basename(file, '.rb')
      class_name = filename.split('_').map(&:capitalize).join
      command_class = Object.const_get(class_name) rescue nil

      next unless command_class

      if file.include?('/slash/')
        load_slash_command(bot, command_class)
      elsif file.include?('/prefix/')
        load_prefix_command(bot, command_class)
      end
    end

    LoggerSetup.info("Loaded #{bot.registry.commands.count} slash commands.") rescue nil
    LoggerSetup.info("Loaded prefix commands.") rescue nil
  end

  def self.load_slash_command(bot, command_class)
    bot.register_application_command(
      command_class.name.downcase.to_sym,
      command_class.description,
      **command_class.options rescue {}
    ) do |cmd|
      command_class.configure(cmd) if command_class.respond_to?(:configure)
    end

    bot.application_command(command_class.name.downcase.to_sym) do |event|
      command_class.call(event)
    end
  end

  def self.load_prefix_command(bot, command_class)
    bot.prefix_command(command_class.name.downcase.to_sym) do |event, *args|
      command_class.call(event, *args)
    end
  end
end
