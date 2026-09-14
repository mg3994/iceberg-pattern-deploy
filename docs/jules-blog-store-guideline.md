# Blog Store: Jules Implementation Guideline

## Product

Build **Blog Store**, a Flutter ecommerce application whose catalog content is authored as Blogger posts. Each Blogger post contains Schema.org JSON-LD, optionally wrapped in an `application/ld+json` script tag. The app extracts that schema and presents supported product data as a store experience.

The default Blogger Blog ID is `1774904866501098696`.

The backend order and payment API will be a separate Hono service deployed to Cloudflare Workers at `https://api.antinna.in`.

## Non-negotiable architecture

Use Clean Architecture with this dependency direction:

```text
presentation -> application/domain <- data
                         ^
                 core contracts

infrastructure implements data/core contracts
injection assembles concrete implementations
```

Rules:

1. Domain code must not import Flutter, Dio, Firebase, Drift, Google Sign-In, Kaisel, or platform APIs.
2. Presentation receives use cases/controllers through constructors.
3. Repositories are domain interfaces. Implementations belong to data.
4. Data models are DTOs and must map to domain entities at the repository boundary.
5. SDK types must not cross domain contracts.
6. All concrete dependency creation belongs in `injection/`.
7. Keep feature code inside `features/<feature>/`.
8. Shared cross-feature contracts belong in `core/`; shared localization belongs in `shared/i18n/`.
9. Use small interfaces with one responsibility. Do not create a universal service or god repository.
10. Prefer immutable entities, unmodifiable collections, constructor injection, and typed request objects.

## Source layout

```text
lib/
  app/
    app.dart
    router/
  config/
    app_config.dart
  core/
    auth/
    analytics/
    error/
    monitoring/
    network/
    notifications/
    result/
    storage/
  features/
    catalog/
      domain/
        entities/
        repositories/
        services/
        usecases/
      data/
        datasources/
        models/
        repositories/
      presentation/
        pages/
        widgets/
        signals/
    auth/
      domain/
      data/
      presentation/
    cart/
    wishlist/
    checkout/
    orders/
  infrastructure/
    auth/
    blogger/
    database/drift/
    firebase/
    network/
  shared/
    i18n/
  injection/

test/
  catalog_domain_test.dart
  features/
  infrastructure/
```

## API source selection

There are three transport concerns and they must remain separate:

### 1. Unauthenticated Blogger Feed API

Use when there is no signed-in Firebase Google user:

```text
GET https://www.blogger.com/feeds/{blogId}/posts/default?alt=json
GET https://www.blogger.com/feeds/{blogId}/posts/default/{postId}?alt=json
```

For label filtering, use Blogger feed label paths where supported:

```text
GET /feeds/{blogId}/posts/default/-/{label1}/{label2}?alt=json
```

Use `q`, `start-index`, and `max-results` for text search and pagination.

### 2. Authenticated Blogger v3 API

Use when Firebase Google authentication is active and the user has the required Blogger scopes:

```text
GET https://www.googleapis.com/blogger/v3/blogs/{blogId}/posts
GET https://www.googleapis.com/blogger/v3/blogs/{blogId}/posts/{postId}
```

Send the configured access token in the `Authorization` header. The token provider must be an abstraction. Firebase token retrieval must not be performed from widgets or domain code.

Use `q`, `labels`, `pageToken`, `maxResults`, and `fetchBodies=true` where required by the API contract.

### 3. Shared application backend

Keep a separate client for:

```text
https://api.antinna.in
```

This client will later handle serviceability enrichment, cart/order synchronization if needed, order creation, payment recording, and webhook-facing application operations. Do not use it as a disguised Blogger client.

Endpoint paths must be centralized in configuration. Never scatter URL strings through repositories or widgets.

## Blogger post model

Represent a post separately from a product. A post contains:

- `blogId`
- `postId`
- title
- raw HTML/content
- Blogger labels
- source URL
- published and updated timestamps
- extracted JSON-LD document(s)

A product is a projection of a supported Product schema from a post. Keep the raw schema available for future Schema.org UI support.

## JSON-LD extraction

The extractor must accept:

1. A decoded JSON object.
2. A decoded JSON array.
3. Raw JSON text.
4. HTML containing one or more `script[type="application/ld+json"]` elements.
5. `@graph` documents.
6. HTML-entity encoded JSON where practical.

Do not assume the first object is always a Product. Inspect `@type` as either a string or array. Preserve unsupported schema types for future UI expansion.

### Localized values

JSON-LD values may be:

```json
{
  "name": [
    { "@value": "The Count of Monte Cristo", "@language": "en" },
    { "@value": "Le Comte de Monte-Cristo", "@language": "fr" }
  ]
}
```

The shared `i18n` layer must resolve values in this order:

1. Exact app language, for example `fr`.
2. Configured fallback language, normally `en`.
3. An undetermined-language value.
4. The first available value.
5. Empty string only when no value exists.

The resolver must support scalar strings, scalar numbers, `{"@value": ...}`, and arrays of localized objects.

### Schema references and overrides

Every post schema may have an `@context.@base` such as:

```text
1774904866501098696/5522904867501094455
```

For an `@id`:

- Absolute Blogger feed/v3 URLs should resolve to a Blogger post reference.
- Other absolute URLs are external schema response URLs.
- `blogId/postId` resolves directly.
- A relative ID resolves against the current base blog ID.
- Fetched referenced documents are recursively resolved with a depth limit and cycle protection.
- Fetched properties form the base; local properties override them.
- Nested maps are deep-merged; scalar and list overrides replace the base value.

Never fetch arbitrary references without URL policy, depth limits, and error handling.

## Dates and time zones

Parse ISO-8601 schema timestamps with `DateTime.tryParse`. Preserve the instant and expose the user-local representation with `toLocal()` at the presentation boundary. Do not manually add offsets. Never format a server timestamp as if it were already local.

Locale-aware display formatting belongs in presentation/shared localization, not repositories.

## Power Search

The search bar supports ordinary text plus label expressions:

```text
shoes label:summer label:"New Delhi"
shoes label:summer | label:winter
```

The parser must return a typed request:

- normalized free-text query
- ordered, deduplicated labels
- original query when UI needs to preserve it

Labels may be separated by spaces or `|`. Quoted labels may contain spaces. The parser must not silently discard ordinary text. Feed and v3 request builders translate this typed request into their API-specific query parameters.

## Location and serviceability

The first home experience may request the user's location or allow manual selection. Location acquisition must be behind a contract because the current dependency list does not include a location package yet.

Use a domain `UserLocation` containing country and optional state, city, postal code, latitude, and longitude.

`areaServed` may contain:

- Country
- State or AdministrativeArea
- City or Locality
- PostalCode
- GeoShape or GeoCoordinates in later iterations
- scalar or localized names
- one object or an array

Matching policy:

1. No `areaServed` means serviceable unless business policy says otherwise.
2. Country matches when the user is in that country, regardless of city/state.
3. City/state/postal matches use normalized case and whitespace.
4. Geo matching must be added as a separate strategy, not mixed into string matching.
5. Unknown area types must not crash catalog loading.

Filtering belongs in a domain service or repository policy, never in a widget.

## State management

Use `bloc_signals_flutter` for presentation/application state. A catalog signal/controller should own:

- loading state
- current filter
- selected location
- products
- refresh state
- failure state
- pagination state

The controller depends on use cases, not Dio or Firebase. Widgets observe signals and render states. Avoid mutable global signals and avoid putting network calls in `build`.

## Routing

Use Kaisel in `app/router/`. Routes should be feature-level and typed:

- home/catalog
- product detail
- search
- sign in/account
- cart
- wishlist
- checkout
- orders

Route definitions must not construct repositories. Pass dependencies through page scope or the application composition root.

## Persistence

Use Drift only through local data-source interfaces.

Initial local candidates:

- catalog cache
- cart lines
- wishlist entries
- selected location
- cache metadata and schema version

Cart and wishlist are local-first. Opening the cart must revalidate that cached items are still available and purchasable before checkout. Drift tables should store normalized fields needed for rendering plus stable Blogger post/product IDs; do not store only opaque JSON.

## Payments and orders

Future payment methods:

- Apple Pay
- Google Pay
- Google Pay UPI
- Cash on Delivery

The Flutter app selects a payment method and sends an order request to `https://api.antinna.in`. The Hono backend is authoritative for pricing, inventory, serviceability, order creation, and payment recording. Never trust client-side prices or payment success alone.

Payment providers belong behind payment gateway interfaces. Checkout domain code must not import provider SDKs.

## Firebase

Firebase responsibilities are isolated in infrastructure:

- Firebase Auth and Google Sign-In: identity/session and Blogger scope flow.
- Firebase Messaging: notification permission and token stream.
- Firebase Analytics: screen and business events.
- Firebase Crashlytics: error reporting.
- Firebase Core: initialization only in app startup/composition.

Authentication state must be observable through a core contract. API source selection should use that contract/token provider, not read Firebase directly from a repository.

## Testing rules

Every new domain rule gets a focused unit test. Minimum coverage should include:

- feed and v3 response mapping
- JSON-LD script and script-free extraction
- arrays and `@graph`
- localized values and fallback
- date conversion to local time
- `@base` and `@id` resolution
- deep merge override precedence
- label parsing with spaces, pipes, and quoted labels
- country/state/city/postal serviceability
- cache-first and forced refresh behavior
- authenticated versus unauthenticated source selection

Widget tests inject fake use cases or repositories. They must never depend on network, Firebase, or a real database.

## Jules workflow

For every task:

1. Read the relevant feature and its tests before editing.
2. State the affected architecture boundary.
3. Make the smallest cohesive change.
4. Add or update focused tests.
5. Run `dart format` on touched Dart files.
6. Run `dart run build_runner build` when Drift code changes.
7. Run `flutter analyze lib test`.
8. Run focused tests, then the full test suite when behavior crosses features.
9. Do not modify endpoint behavior without an explicit API contract.
10. Do not add a dependency when an existing abstraction or standard library solves the problem.

## Open decisions to answer before checkout implementation

1. What are the exact public, authenticated, and shared endpoint paths?
2. Is the Firebase ID token truly accepted by Blogger v3, or will Google Sign-In provide a separate Blogger OAuth access token?
3. Which schema types beyond Product must be rendered first?
4. Which location provider and permission policy should be used?
5. What is the canonical product identity when `sku`, `gtin`, `@id`, and Blogger post ID disagree?
6. Which fields are mandatory for a product to be purchasable?
7. Does `api.antinna.in` return serviceability data, or must the client evaluate `areaServed` locally?
8. What are the order and payment request/response contracts?
