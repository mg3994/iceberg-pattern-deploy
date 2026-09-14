// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter_test/flutter_test.dart';

// import 'package:blogstore/app/app.dart';
// import 'package:blogstore/features/catalog/domain/entities/catalog_filter.dart';
// import 'package:blogstore/features/catalog/domain/entities/store_product.dart';
// import 'package:blogstore/features/catalog/domain/repositories/catalog_repository.dart';
// import 'package:blogstore/features/catalog/domain/usecases/get_catalog_products.dart';

// final class _FakeCatalogRepository implements CatalogRepository {
//   @override
//   Future<List<StoreProduct>> getProducts({
//     CatalogFilter filter = const CatalogFilter(),
//     bool forceRefresh = false,
//   }) async => const [];
// }

// void main() {
//   testWidgets('renders the ecommerce catalog', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       BlogStoreApp(getProducts: GetCatalogProducts(_FakeCatalogRepository())),
//     );
//     await tester.pumpAndSettle();

//     expect(find.text('Store catalog'), findsOneWidget);
//   });
// }
