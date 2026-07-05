require 'discordrb'

module Bot
  def self.create
    Discordrb::Bot.new(
      token: Config.token,
      client_id: Config.client_id,
      prefix: Config.prefix
    )
  end
end
