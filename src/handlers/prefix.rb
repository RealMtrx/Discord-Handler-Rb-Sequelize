module PrefixHandler
  def self.load(bot)
    bot.prefix do |event|
      next unless event.content

      parts = event.content.split
      cmd_name = parts[0]&.sub(/^#{Regexp.escape(Config.prefix)}/, '')&.downcase
      args = parts[1..] || []

      command_file = File.join(__dir__, '..', 'commands', 'prefix', '**', "#{cmd_name}.rb")
      Dir[command_file].each do |file|
        require file
        class_name = File.basename(file, '.rb').split('_').map(&:capitalize).join
        command_class = Object.const_get(class_name) rescue nil
        next unless command_class

        if command_class.respond_to?(:cooldown) && command_class.cooldown
          cooldown_key = "#{event.user.id}:#{cmd_name}"
          if Cooldown.on_cooldown?(cooldown_key)
            remaining = Cooldown.remaining(cooldown_key)
            event.respond("Please wait #{remaining.round(1)}s before using this command again.")
            return
          end
          Cooldown.set(cooldown_key, command_class.cooldown)
        end

        command_class.call(event, *args)
      end
    end
  end
end
