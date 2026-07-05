module InteractionCreate
  def self.register(bot)
    bot.interaction_create do |event|
      LoggerSetup.debug("Interaction received: #{event.interaction.type} (#{event.interaction.data&.name})")
    end
  end
end
