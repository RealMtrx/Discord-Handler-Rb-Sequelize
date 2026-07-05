module AntiCrash
  def self.load(bot)
    bot.bot_exception do |event, exception|
      LoggerSetup.error("Bot exception: #{exception.message}")
      LoggerSetup.error(exception.backtrace&.first(5)&.join("\n"))
    end

    Thread.new do
      loop do
        begin
          Thread.list.each do |thread|
            next if thread == Thread.current
            next if thread.status == 'run' || thread.status == 'sleep'
            next unless thread.status.nil?

            LoggerSetup.warn("Dead thread detected: #{thread}")
          end
        rescue => e
          LoggerSetup.error("Thread monitor error: #{e.message}")
        end
        sleep 60
      end
    end
  end
end

AntiCrash.load(Bot.create) rescue nil
