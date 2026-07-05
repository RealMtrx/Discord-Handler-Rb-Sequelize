module Config
  def self.token
    ENV.fetch('DISCORD_TOKEN') { raise 'DISCORD_TOKEN not set' }
  end

  def self.client_id
    ENV.fetch('DISCORD_CLIENT_ID') { raise 'DISCORD_CLIENT_ID not set' }
  end

  def self.prefix
    ENV.fetch('DISCORD_PREFIX', '!')
  end

  def self.db_dialect
    ENV.fetch('DB_DIALECT', 'sqlite')
  end

  def self.db_storage
    ENV.fetch('DB_STORAGE', 'database.sqlite')
  end

  def self.db_host
    ENV.fetch('DB_HOST', 'localhost')
  end

  def self.db_port
    ENV.fetch('DB_PORT', '5432').to_i
  end

  def self.db_name
    ENV.fetch('DB_NAME', 'discord_bot')
  end

  def self.db_user
    ENV.fetch('DB_USER', 'postgres')
  end

  def self.db_password
    ENV.fetch('DB_PASSWORD', 'password')
  end

  def self.webhook_url
    ENV.fetch('WEBHOOK_URL', nil)
  end
end
