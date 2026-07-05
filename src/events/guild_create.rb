module GuildCreate
  def self.register(bot)
    bot.guild_create do |event|
      LoggerSetup.info("Joined guild: #{event.guild.name} (#{event.guild.id})")
      LoggerSetup.info("Members: #{event.guild.members.count}")

      Webhooks.send(
        "**Joined Guild**",
        "**Name:** #{event.guild.name}\n**ID:** #{event.guild.id}\n**Members:** #{event.guild.members.count}\n**Owner:** #{event.guild.owner&.username}",
        0x00FF00
      )
    end
  end
end
