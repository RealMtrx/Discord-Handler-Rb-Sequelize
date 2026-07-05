require 'sequel'

module Database
  def self.connect
    case Config.db_dialect
    when 'sqlite'
      Sequel.sqlite(Config.db_storage)
    when 'postgres'
      Sequel.postgres(
        host:     Config.db_host,
        port:     Config.db_port,
        database: Config.db_name,
        user:     Config.db_user,
        password: Config.db_password
      )
    else
      raise "Unknown DB_DIALECT: #{Config.db_dialect}"
    end
  end
end
