module Ready
  def self.register(bot)
    bot.ready do |event|
      LoggerSetup.info("Logged in as #{bot.profile.username}##{bot.profile.discriminator}")
      LoggerSetup.info("Servers: #{bot.servers.count}")
      LoggerSetup.info("Users: #{bot.users.count}")

      bot.update_presence(
        status: :online,
        activity: Discordrb::Activity.new(
          name: "#{Config.prefix}help | #{bot.servers.count} servers",
          type: :playing
        )
      )
    end
  end
end
