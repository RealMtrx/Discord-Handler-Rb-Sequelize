class User < Sequel::Model(:users)
  def self.create_table_if_not_exists
    DB.create_table?(:users) do
      primary_key :id
      String :discord_id, unique: true, null: false
      String :username
      String :discriminator
      Integer :xp, default: 0
      Integer :level, default: 1
      Integer :messages_count, default: 0
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  def before_create
    self.created_at ||= Time.now
    self.updated_at ||= Time.now
  end

  def before_update
    self.updated_at = Time.now
  end

  def self.find_or_create_by_discord_id(discord_id)
    user = where(discord_id: discord_id).first
    return user if user

    create(discord_id: discord_id)
  end
end
