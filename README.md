# Discord-Handler-Rb-Sequelize

A Discord bot in Ruby using **discordrb** + **Sequel ORM** (SQLite/PostgreSQL).

## Features

- Slash commands and prefix commands
- Event-driven architecture
- Sequel ORM for database management
- Cooldown system
- Logger and webhook integration
- Anti-crash handler

## Setup

1. Copy `.env.example` to `.env` and fill in your credentials:

```bash
cp .env.example .env
```

2. Install dependencies:

```bash
bundle install
```

3. Run the bot:

```bash
bundle exec ruby src/main.rb
```

## Configuration

Edit `.env` to configure:

- `DISCORD_TOKEN` – Your bot token
- `DISCORD_CLIENT_ID` – Application client ID
- `DISCORD_PREFIX` – Command prefix (default: `!`)
- `DB_DIALECT` – Database adapter (`sqlite` or `postgres`)
- `DB_STORAGE` – SQLite file path (if using sqlite)
- `DB_HOST/DB_PORT/DB_NAME/DB_USER/DB_PASSWORD` – PostgreSQL connection (if using postgres)

## Project Structure

```
src/
├── main.rb              # Entry point
├── config.rb            # ENV configuration loader
├── bot.rb               # Bot initialization
├── database/
│   └── sequelize_db.rb  # Sequel connection setup
├── models/
│   └── user.rb          # User model
├── handlers/
│   ├── anticrash.rb     # Global error handler
│   ├── commands.rb      # Command loader
│   ├── events.rb        # Event loader
│   ├── prefix.rb        # Prefix command handler
│   └── logger.rb        # Logging utility
├── events/
│   ├── ready.rb         # On bot ready
│   ├── message_create.rb
│   ├── interaction_create.rb
│   ├── guild_create.rb
│   └── guild_delete.rb
├── core/
│   ├── webhooks.rb      # Webhook sender
│   ├── emojis.rb        # Emoji constants
│   ├── command_utils.rb # Command helpers
│   └── cooldown.rb      # Cooldown system
└── commands/
    ├── slash/public/ping.rb
    └── prefix/public/ping.rb
```
