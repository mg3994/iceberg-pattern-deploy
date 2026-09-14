# Ecommerce Store Architecture

## Dependency direction

`presentation -> domain <- data`

- `app/`: application shell and navigation composition.
- `core/`: framework-independent contracts shared by features.
- `features/<feature>/domain/`: entities, repository contracts, and use cases.
- `features/<feature>/data/`: DTOs, remote/local data sources, and repository implementations.
- `features/<feature>/presentation/`: pages and feature state/controllers.
- `infrastructure/`: adapters for Firebase, Dio, Drift, and other external SDKs.
- `injection/`: the only place where interfaces are paired with implementations.

## Rules

1. Domain imports only Dart libraries and `core` contracts.
2. Presentation receives use cases/controllers through constructors.
3. Data models map to domain entities at the repository boundary.
4. External SDK types do not cross into domain contracts.
5. Drift implements feature cache contracts; generated database code stays in `infrastructure/database`.
6. Firebase services implement core gateways; features do not import Firebase SDKs.
7. Use `Result<T>` and `Failure` for expected application errors.
