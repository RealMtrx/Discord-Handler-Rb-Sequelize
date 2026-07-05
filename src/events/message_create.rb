module MessageCreate
  def self.register(bot)
    bot.message do |event|
      next if event.author.bot?

      user = User.find_or_create_by_discord_id(event.author.id.to_s)
      user.update(
        username: event.author.username,
        discriminator: event.author.discriminator
      )

      user.messages_count += 1
      user.xp += rand(1..5)

      if user.xp >= user.level * 100
        user.level += 1
        user.xp = 0
        event.respond("🎉 #{event.author.mention}, you leveled up to level #{user.level}!")
      end

      user.save
    end
  end
end
