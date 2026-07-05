<div align="center">
  <h1>Discord Handler — Ruby (SQL Edition)</h1>
  <p><strong>A production-ready Discord bot framework built with Discordrb and Sequel — supports SQLite, PostgreSQL, and MySQL with a modular src/ architecture.</strong></p>

  <p>
    <a href="https://github.com/RealMtrx/Discord-Handler-Rb-Sequelize/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
    <a href="https://github.com/RealMtrx/Discord-Handler-Rb-Sequelize/releases"><img src="https://img.shields.io/badge/version-0.9.0--beta-yellow" alt="Version 0.9.0 Beta"></a>
    <a href="https://github.com/RealMtrx/Discord-Handler-Rb-Sequelize/stargazers"><img src="https://img.shields.io/github/stars/RealMtrx/Discord-Handler-Rb-Sequelize" alt="Stars"></a>
    <a href="https://github.com/RealMtrx/Discord-Handler-Rb-Sequelize/issues"><img src="https://img.shields.io/github/issues/RealMtrx/Discord-Handler-Rb-Sequelize" alt="Issues"></a>
    <a href="https://github.com/RealMtrx/Discord-Handler-Rb-Sequelize/network"><img src="https://img.shields.io/github/forks/RealMtrx/Discord-Handler-Rb-Sequelize" alt="Forks"></a>
    <a href="https://github.com/RealMtrx/Discord-Handler/graphs/contributors"><img src="https://img.shields.io/badge/ecosystem-26%20repos-brightgreen" alt="26 Repos"></a>
    <a href="https://discord.gg/0hu2"><img src="https://img.shields.io/badge/discord-0hu2-5865F2" alt="Discord"></a>
  </p>

  <br>

  <p>
    <a href="#-features">Features</a> •
    <a href="#-quick-start">Quick Start</a> •
    <a href="#-project-structure">Structure</a> •
    <a href="#-database-configuration">Database Config</a> •
    <a href="#-api-reference">API</a> •
    <a href="#-mongodb-edition">MongoDB Edition</a> •
    <a href="#-related-repositories">Ecosystem</a>
  </p>
</div>

---

## Overview

An SQL edition of the Discord Handler framework built with **Ruby**, **Discordrb** (Discord library), and **Sequel** (SQLite / PostgreSQL / MySQL ORM). It mirrors the architecture of the MongoDB edition, replacing document storage with relational database support while keeping the same modular structure, anti-crash protection, webhook logging, and dual command system.

## Features

- **Dual Command System** — Slash commands and prefix commands
- **Event-Driven Architecture** — Fully event-driven via Discordrb
- **Sequel ORM** — Multi-dialect SQL with migrations and connection pooling
- **Anti-Crash Handler** — Global error catching that keeps your bot online
- **Webhook Error Logging** — Real-time error and guild event reporting
- **Cooldown System** — Per-command rate limiting
- **Emoji Constants** — Centralized unicode emoji definitions
- **Environment Configuration** — Secure token management via `.env`

## Quick Start

```bash
# Clone
git clone https://github.com/RealMtrx/Discord-Handler-Rb-Sequelize.git
cd Discord-Handler-Rb-Sequelize

# Configure
cp .env.example .env
# Edit .env with your bot token and database settings

# Install dependencies
bundle install

# Run the bot
bundle exec ruby src/main.rb
```

## Project Structure

```
src/
├── main.rb                       # Entry point
├── bot.rb                        # Bot client initialization
├── config.rb                     # .env configuration loader
├── database/
│   └── sequelize_db.rb           # Sequel connection setup
├── models/
│   └── user.rb                   # User model
├── handlers/
│   ├── anticrash.rb              # Global error handler
│   ├── commands.rb               # Slash command loader
│   ├── events.rb                 # Event loader
│   ├── logger.rb                 # Logging utility
│   └── prefix.rb                 # Prefix command handler
├── events/
│   ├── ready.rb                  # Bot ready event
│   ├── message_create.rb         # Message create listener
│   ├── interaction_create.rb     # Interaction create listener
│   ├── guild_create.rb           # Guild create listener
│   └── guild_delete.rb           # Guild delete listener
├── core/
│   ├── webhooks.rb               # Webhook sender
│   ├── emojis.rb                 # Emoji constants
│   ├── command_utils.rb          # Command helpers
│   └── cooldown.rb               # Cooldown manager
└── commands/
    ├── slash/public/ping.rb      # Example slash command
    └── prefix/public/ping.rb     # Example prefix command
```

## Database Configuration

Configure your database in `.env`:

```env
DISCORD_TOKEN=your_bot_token_here
DISCORD_CLIENT_ID=your_client_id_here
DISCORD_PREFIX=!

DB_DIALECT=sqlite        # sqlite | postgres | mysql
DB_STORAGE=database.sqlite  # SQLite file path (sqlite only)
DB_HOST=localhost
DB_PORT=5432
DB_NAME=discord_bot
DB_USER=postgres
DB_PASSWORD=password

WEBHOOK_URL=
```

### Dialect examples

**SQLite (default)** — zero configuration, file-based:
```env
DB_DIALECT=sqlite
DB_STORAGE=database.sqlite
```

**PostgreSQL**:
```env
DB_DIALECT=postgres
DB_HOST=localhost
DB_PORT=5432
DB_NAME=discord_bot
DB_USER=postgres
DB_PASSWORD=your_password
```

**MySQL**:
```env
DB_DIALECT=mysql
DB_HOST=localhost
DB_PORT=3306
DB_NAME=discord_bot
DB_USER=root
DB_PASSWORD=your_password
```

## API Reference

### Sequel Database Setup (`src/database/sequelize_db.rb`)

```ruby
require 'sequel'
require 'yaml'

module Database
  def self.connect
    dialect = ENV['DB_DIALECT'] || 'sqlite'
    
    db = case dialect
    when 'sqlite'
      Sequel.sqlite(ENV['DB_STORAGE'] || 'database.sqlite')
    when 'postgres'
      Sequel.postgres(
        host: ENV['DB_HOST'],
        port: ENV['DB_PORT'].to_i,
        database: ENV['DB_NAME'],
        user: ENV['DB_USER'],
        password: ENV['DB_PASSWORD']
      )
    when 'mysql'
      Sequel.mysql2(
        host: ENV['DB_HOST'],
        port: ENV['DB_PORT'].to_i,
        database: ENV['DB_NAME'],
        user: ENV['DB_USER'],
        password: ENV['DB_PASSWORD']
      )
    end

    db.create_table?(:users) do
      String :id, primary_key: true
      String :username
      String :discriminator
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
    end

    db
  end
end
```

### Slash Command Example (`src/commands/slash/public/ping.rb`)

```ruby
module SlashCommands
  module Ping
    NAME = 'ping'
    DESCRIPTION = 'Replies with Pong!'

    def self.call(event)
      event.respond(content: 'Pong!')
    end
  end
end
```

### Prefix Command Example (`src/commands/prefix/public/ping.rb`)

```ruby
module PrefixCommands
  module Ping
    NAME = 'ping'

    def self.call(event)
      event.respond('Pong!')
    end
  end
end
```

## Adding Commands

1. Create a file in `src/commands/slash/public/<name>.rb` or `src/commands/prefix/public/<name>.rb`
2. Define a module with `NAME`, `DESCRIPTION` (slash only), and a `call` method
3. The command loader automatically picks up new files

## MongoDB Edition

Prefer a document database? Use the **MongoDB edition** of this handler:

<div align="center">
  <a href="https://github.com/RealMtrx/Discord-Handler-Rb"><img src="https://img.shields.io/badge/Discord--Handler--Rb-MongoDB%20Edition-blue?style=for-the-badge" alt="MongoDB Edition"></a>
</div>

The MongoDB edition uses the `mongo` gem instead of Sequel, but shares the same command, event, and handler structure. You can switch between editions without relearning the architecture.

## Related Repositories

The Discord Handler ecosystem includes **26 repositories** — 13 Core Framework (MongoDB) editions and 13 Database (SQL) editions, covering 13 programming languages.

### Core Framework (MongoDB) Editions

| # | Language | Repository |
|---|----------|------------|
| 1 | JavaScript | [Discord-Handler-Js](https://github.com/RealMtrx/Discord-Handler-Js) |
| 2 | TypeScript | [Discord-Handler-Ts](https://github.com/RealMtrx/Discord-Handler-Ts) |
| 3 | Go | [Discord-Handler-Go](https://github.com/RealMtrx/Discord-Handler-Go) |
| 4 | Rust | [Discord-Handler-Rs](https://github.com/RealMtrx/Discord-Handler-Rs) |
| 5 | Python | [Discord-Handler-Py](https://github.com/RealMtrx/Discord-Handler-Py) |
| 6 | C# | [Discord-Handler-Cs](https://github.com/RealMtrx/Discord-Handler-Cs) |
| 7 | Java | [Discord-Handler-Java](https://github.com/RealMtrx/Discord-Handler-Java) |
| 8 | Kotlin | [Discord-Handler-Kt](https://github.com/RealMtrx/Discord-Handler-Kt) |
| 9 | C++ | [Discord-Handler-Cpp](https://github.com/RealMtrx/Discord-Handler-Cpp) |
| 10 | Dart | [Discord-Handler-Dart](https://github.com/RealMtrx/Discord-Handler-Dart) |
| 11 | **Ruby** | [Discord-Handler-Rb](https://github.com/RealMtrx/Discord-Handler-Rb) |
| 12 | Lua | [Discord-Handler-Lua](https://github.com/RealMtrx/Discord-Handler-Lua) |
| 13 | PHP | [Discord-Handler-Php](https://github.com/RealMtrx/Discord-Handler-Php) |

### Database (SQL) Editions

| # | Language | Repository | ORM |
|---|----------|------------|-----|
| 1 | JavaScript | [Discord-Handler-Js-Sequelize](https://github.com/RealMtrx/Discord-Handler-Js-Sequelize) | Sequelize |
| 2 | TypeScript | [Discord-Handler-Ts-Sequelize](https://github.com/RealMtrx/Discord-Handler-Ts-Sequelize) | Sequelize |
| 3 | Go | [Discord-Handler-Go-Sequelize](https://github.com/RealMtrx/Discord-Handler-Go-Sequelize) | GORM |
| 4 | Rust | [Discord-Handler-Rs-Sequelize](https://github.com/RealMtrx/Discord-Handler-Rs-Sequelize) | Diesel |
| 5 | Python | [Discord-Handler-Py-Sequelize](https://github.com/RealMtrx/Discord-Handler-Py-Sequelize) | SQLAlchemy |
| 6 | C# | [Discord-Handler-Cs-Sequelize](https://github.com/RealMtrx/Discord-Handler-Cs-Sequelize) | EF Core |
| 7 | Java | [Discord-Handler-Java-Sequelize](https://github.com/RealMtrx/Discord-Handler-Java-Sequelize) | Hibernate |
| 8 | Kotlin | [Discord-Handler-Kt-Sequelize](https://github.com/RealMtrx/Discord-Handler-Kt-Sequelize) | Exposed |
| 9 | C++ | [Discord-Handler-Cpp-Sequelize](https://github.com/RealMtrx/Discord-Handler-Cpp-Sequelize) | sqlpp11 |
| 10 | Dart | [Discord-Handler-Dart-Sequelize](https://github.com/RealMtrx/Discord-Handler-Dart-Sequelize) | drift |
| 11 | **Ruby** | **Discord-Handler-Rb-Sequelize** | **Sequel** |
| 12 | Lua | [Discord-Handler-Lua-Sequelize](https://github.com/RealMtrx/Discord-Handler-Lua-Sequelize) | LuaSQL |
| 13 | PHP | [Discord-Handler-Php-Sequelize](https://github.com/RealMtrx/Discord-Handler-Php-Sequelize) | Eloquent |

### Hub Repository

<div align="center">
  <a href="https://github.com/RealMtrx/Discord-Handler"><img src="https://img.shields.io/badge/Hub-Discord--Handler-181717?style=for-the-badge&logo=github" alt="Hub Repository"></a>
</div>

The hub repo contains documentation, examples in every language, changelog, roadmap, and contribution guidelines.

## License

Distributed under the MIT License. See `LICENSE` for more information.

---

Built by **Mtrx** — Discord: **0hu2**
