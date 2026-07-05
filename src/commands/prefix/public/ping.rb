module Ping
  def self.name
    'ping'
  end

  def self.description
    'Check the bot\'s latency'
  end

  def self.cooldown
    5
  end

  def self.call(event, *args)
    start_time = Time.now
    msg = event.respond("#{Emojis::LOADING} Pong!")

    elapsed = ((Time.now - start_time) * 1000).round
    msg.edit("#{Emojis::PING} Pong! **#{elapsed}ms**")
  end
end
