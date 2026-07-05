module CommandUtils
  def self.respond(event, content, ephemeral: false)
    if event.respond_to?(:respond)
      event.respond(content: content, ephemeral: ephemeral)
    elsif event.respond_to?(:send_message)
      event.send_message(content)
    end
  end

  def self.embed(event, title:, description:, color: 0x5865F2, fields: [], footer: nil, ephemeral: false)
    embed = Discordrb::Webhooks::Embed.new(
      title: title,
      description: description,
      color: color,
      timestamp: Time.now.utc
    )

    fields.each { |f| embed.add_field(name: f[:name], value: f[:value], inline: f.fetch(:inline, false)) }
    embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: footer) if footer

    if event.respond_to?(:respond)
      event.respond(embeds: [embed], ephemeral: ephemeral)
    elsif event.respond_to?(:send_embed)
      event.send_embed { |e| e = embed }
    end
  end

  def self.error(event, message)
    respond(event, "#{Emojis::ERROR} #{message}")
  end

  def self.success(event, message)
    respond(event, "#{Emojis::SUCCESS} #{message}")
  end

  def self.defer(event)
    event.defer if event.respond_to?(:defer)
  end
end
