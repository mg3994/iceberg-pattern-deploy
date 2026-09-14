import 'package:flutter_test/flutter_test.dart';

import 'package:blogstore/features/catalog/domain/entities/catalog_filter.dart';
import 'package:blogstore/features/catalog/domain/entities/service_area.dart';
import 'package:blogstore/features/catalog/domain/entities/user_location.dart';
import 'package:blogstore/features/catalog/domain/services/catalog_serviceability.dart';
import 'package:blogstore/infrastructure/blogger/json_ld_product_parser.dart';
import 'package:blogstore/infrastructure/blogger/schema_reference_resolver.dart';
import 'package:blogstore/features/catalog/domain/services/schema_reference.dart';

void main() {
  group('PowerSearchParser', () {
    test('extracts labels separated by spaces and pipes', () {
      final result = const PowerSearchParser().parse(
        'shoes label:summer | label:"New Delhi"',
      );

      expect(result.text, 'shoes');
      expect(result.labels, ['summer', 'New Delhi']);
    });
  });

  group('JsonLdProductParser', () {
    test('parses localized values and script-free JSON-LD', () {
      final products = const JsonLdProductParser().parse(
        '{"@type":"Product","@id":"1774904866501098696/1",'
        '"name":[{"@value":"English name","@language":"en"},'
        '{"@value":"Nom francais","@language":"fr"}],'
        '"description":"A product","datePublished":"2026-08-27T10:00:00+00:00",'
        '"areaServed":[{"@type":"Country","name":"India"}],'
        '"offers":{"price":12.5,"priceCurrency":"INR"}}',
        languageCode: 'fr',
      );

      expect(products, hasLength(1));
      expect(products.single.name, 'Nom francais');
      expect(products.single.price, 12.5);
      expect(products.single.serviceAreas.single.type, 'Country');
      expect(products.single.serviceAreas.single.name, 'India');
      expect(products.single.publishedAt?.isUtc, isFalse);
    });

    test('parses JSON-LD script tags', () {
      final products = const JsonLdProductParser().parse(
        '<script type="application/ld+json">'
        '{"@type":"Product","name":"Bag"}</script>',
      );
      expect(products.single.name, 'Bag');
    });
  });

  test('country service area applies to a matching user location', () {
    final serviceability = const CatalogServiceability();
    expect(
      serviceability.isServiceable(
        areas: const [ServiceArea(type: 'Country', name: 'India')],
        location: const UserLocation(country: 'India', city: 'Gurugram'),
      ),
      isTrue,
    );
  });

  test(
    'schema reference resolves relative blogger IDs and merges overrides',
    () async {
      final resolver = const SchemaReferenceResolver();
      final reference = resolver.resolveId('1774904866501098696/10', '20');
      expect(reference.blogId, '1774904866501098696');
      expect(reference.postId, '20');

      final resolved = await resolver.resolve(
        const {'@id': '20', 'name': 'Override'},
        base: '1774904866501098696/10',
        fetcher: _FakeSchemaFetcher(),
      );
      expect(resolved['description'], 'Fetched');
      expect(resolved['name'], 'Override');
    },
  );
}

final class _FakeSchemaFetcher implements SchemaDocumentFetcher {
  @override
  Future<Map<String, dynamic>?> fetch(SchemaReference reference) async {
    return const {
      '@type': 'Product',
      'name': 'Fetched',
      'description': 'Fetched',
    };
  }
}
