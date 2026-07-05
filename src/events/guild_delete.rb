module GuildDelete
  def self.register(bot)
    bot.guild_delete do |event|
      LoggerSetup.info("Left guild: #{event.id}")

      Webhooks.send(
        "**Left Guild**",
        "**ID:** #{event.id}",
        0xFF0000
      )
    end
  end
end
