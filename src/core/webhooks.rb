require 'net/http'
require 'json'
require 'uri'

module Webhooks
  def self.send(title, description, color = 0x5865F2)
    url = Config.webhook_url
    return unless url

    payload = {
      embeds: [
        {
          title: title,
          description: description,
          color: color,
          timestamp: Time.now.utc.iso8601,
          footer: { text: 'Discord Bot' }
        }
      ]
    }

    Thread.new do
      begin
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'

        request = Net::HTTP::Post.new(uri.path)
        request['Content-Type'] = 'application/json'
        request.body = payload.to_json

        response = http.request(request)
        LoggerSetup.debug("Webhook sent: #{response.code}")
      rescue => e
        LoggerSetup.error("Webhook error: #{e.message}")
      end
    end
  end
end
