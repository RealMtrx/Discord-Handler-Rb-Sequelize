module Cooldown
  @cooldowns = {}

  def self.set(key, seconds)
    @cooldowns[key] = Time.now + seconds
  end

  def self.on_cooldown?(key)
    return false unless @cooldowns[key]

    @cooldowns[key] > Time.now
  end

  def self.remaining(key)
    return 0 unless @cooldowns[key]

    remaining = @cooldowns[key] - Time.now
    remaining.positive? ? remaining : 0
  end

  def self.clear(key)
    @cooldowns.delete(key)
  end

  def self.clear_all
    @cooldowns.clear
  end
end
