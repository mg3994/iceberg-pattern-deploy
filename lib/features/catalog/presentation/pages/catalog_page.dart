import 'package:flutter/material.dart';

import '../../domain/entities/store_product.dart';
import '../../domain/usecases/get_catalog_products.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({required this.getProducts, super.key});

  final GetCatalogProducts getProducts;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late Future<List<StoreProduct>> _products;

  @override
  void initState() {
    super.initState();
    _products = widget.getProducts();
  }

  Future<void> _refresh() async {
    setState(() {
      _products = widget.getProducts(forceRefresh: true);
    });
    await _products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store catalog'),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh catalog',
          ),
        ],
      ),
      body: FutureBuilder<List<StoreProduct>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Could not load catalog: ${snapshot.error}'),
            );
          }
          final products = snapshot.data ?? const <StoreProduct>[];
          if (products.isEmpty) {
            return const Center(child: Text('No products available.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) =>
                _ProductTile(product: products[index]),
          );
        },
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final StoreProduct product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: product.imageUrl == null
            ? const Icon(Icons.shopping_bag_outlined)
            : Image.network(product.imageUrl!, width: 56, fit: BoxFit.cover),
        title: Text(product.name),
        subtitle: Text(product.description),
        trailing: product.price == null
            ? null
            : Text('${product.currency ?? ''} ${product.price}'),
      ),
    );
  }
}
