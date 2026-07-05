module Ping
  def self.name
    'ping'
  end

  def self.description
    'Check the bot\'s latency'
  end

  def self.options
    {}
  end

  def self.call(event)
    start_time = Time.now
    event.respond(content: "#{Emojis::LOADING} Pong!")

    elapsed = ((Time.now - start_time) * 1000).round
    event.edit(content: "#{Emojis::PING} Pong! **#{elapsed}ms**")
  end
end
