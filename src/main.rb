require 'dotenv'
Dotenv.load

require_relative 'handlers/logger'
require_relative 'config'
require_relative 'database/sequelize_db'
require_relative 'bot'

LoggerSetup.info('Starting Discord bot...')

DB = Database.connect

begin
  DB.test_connection
  LoggerSetup.info('Database connection established.')
rescue => e
  LoggerSetup.error("Database connection failed: #{e.message}")
  exit(1)
end

require_relative 'models/user'
User.create_table_if_not_exists

bot = Bot.create
bot.ready do
  LoggerSetup.info('Bot is ready!')
end

LoggerSetup.info('Loading events...')
require_relative 'handlers/events'
EventLoader.load(bot)

LoggerSetup.info('Loading commands...')
require_relative 'handlers/commands'
CommandLoader.load(bot)

LoggerSetup.info('Loading anti-crash...')
require_relative 'handlers/anticrash'

LoggerSetup.info('Bot is running.')
bot.run
