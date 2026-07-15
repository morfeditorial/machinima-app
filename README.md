<div align="center">

<img src="assets/images/morf-logo.svg" alt="Morf Editorial" width="320" />

# machinima-app

*Host application for the Machinima platform.*

[![Latest Stable Version](https://img.shields.io/packagist/v/morfeditorial/machinima-app.svg?label=Packagist&logo=packagist)](https://packagist.org/packages/morfeditorial/machinima-app)
[![Total Downloads](https://img.shields.io/packagist/dt/morfeditorial/machinima-app.svg?label=Downloads&logo=packagist)](https://packagist.org/packages/morfeditorial/machinima-app)
[![License](https://img.shields.io/packagist/l/morfeditorial/machinima-app.svg?label=Licence&logo=open-source-initiative)](https://packagist.org/packages/morfeditorial/machinima-app)

[Architecture](#architecture) · [Run profiles](#run-profiles) · [Tech stack](#tech-stack) · [Installation](#installation) · [Contributing](#contributing)

---

</div>

This is the host skeleton application for the Machinima platform. It functions seamlessly as both a regular website and an interactive Telegram Mini App. Its unique architecture ensures that the core system remains completely independent and modular.

## Architecture

This repository (`machinima-app`) acts merely as a thin skeleton and configuration host. It contains almost no PHP code of its own. Its primary responsibility is to wire together external, modular components using Symfony configuration and environment profiles:

- **[`morfeditorial/machinima-core`](https://github.com/ChernegaSergiy/machinima-core)** — the foundational bundle that provides the domain models, business logic, controllers, and base UI templates. The core itself is completely platform-agnostic.
- **Platform Adapters** — separate composer packages that provide integration with external platforms (like Telegram). They implement the contracts exposed by the core bundle to register identity providers and zero-click login capabilities.

Currently, the primary adapter wired into this host is [`machinima-telegram-adapter`](https://github.com/ChernegaSergiy/machinima-telegram-adapter).

## Run profiles

The application supports several profiles (`config/profiles/`) that enable a different set of bundles and configuration via `APP_PROFILE`:

- **`core-only`** — core only, no platform adapter.
- **`telegram-webapp`** — core + Telegram Mini App adapter (zero-click login, UI hints).
- **`telegram-bot`** — core + Telegram bot (notifications, commands).

## Tech stack

As a host application, this repository defines the infrastructure and runtime environment:

- **Runtime**: PHP 8.4+, Symfony 8.1
- **Database**: PostgreSQL (via Doctrine)
- **Real-time**: Mercure Hub
- **Asynchronous Processing**: Symfony Messenger

## Installation

```bash
composer install
```

Copy `.env.example` to `.env.local` and fill in the values:

```bash
cp .env.example .env.local
```

Main environment variables:

| Variable | Purpose |
|---|---|
| `APP_PROFILE` | `core-only` / `telegram-webapp` / `telegram-bot` |
| `DATABASE_URL` | PostgreSQL connection string |
| `TELEGRAM_BOT_TOKEN` | bot token (needed by the Telegram adapter and for verifying Mini App `initData`) |
| `TELEGRAM_DSN` | DSN for Symfony Notifier (Telegram notifications) |
| `MERCURE_URL` / `MERCURE_PUBLIC_URL` / `MERCURE_JWT_SECRET` | Mercure hub for real-time updates |
| `MESSENGER_TRANSPORT_DSN` | transport for asynchronous messages |

Bring up infrastructure (PostgreSQL, Mercure) via Docker Compose:

```bash
docker compose up -d
```

Database migrations:

```bash
php bin/console doctrine:migrations:migrate
```

Local run via Symfony CLI:

```bash
symfony server:start -d
```

## Project structure

```text
machinima-app/
+-- config/
|   \-- profiles/   # configuration per run profile
+-- migrations/     # Doctrine migrations
+-- src/
|   \-- Kernel.php  # Symfony Kernel
\-- public/         # Entry point
```

## Contributing

Contributions are welcome and appreciated! Here's how you can contribute:

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please make sure to update tests as appropriate and adhere to the existing coding style.

## License

This project is licensed under the CSSM Unlimited License v2.0 (CSSM-ULv2). See the [LICENSE](LICENSE) file for details.
