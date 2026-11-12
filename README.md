# Event Catalog

Каталог подій: консольний застосунок на Dart (Clean Architecture).

## Політика гілок

- `main` — стабільний код, лише релізи (теги `vX.Y.Z`)
- `develop` — інтеграційна гілка, сюди зливаються всі feature-гілки через pull request
- `feature/*` — гілки під конкретні задачі, створюються від `develop`

## Конвенція комітів

Використовуємо Conventional Commits: `feat`, `fix`, `refactor`, `docs`, `merge`.
Приклад: `feat(domain): додати сутність EventItem`