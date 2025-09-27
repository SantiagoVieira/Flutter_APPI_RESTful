import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = Provider.of<ProductProvider>(context, listen: false);
      prov.loadInitial();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        Provider.of<ProductProvider>(context, listen: false).fetchMore();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos (Fake Store)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => const ProductFormScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, prov, _) {
          if (prov.status == Status.loading && prov.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (prov.status == Status.error && prov.products.isEmpty) {
            return Center(child: Text('Error: ${prov.errorMessage}'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: prov.search,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Buscar por título, descripción o categoría',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              prov.search('');
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => prov.loadInitial(force: true),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        prov.products.length + (prov.isFetchingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= prov.products.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final p = prov.products[index];
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailScreen(productId: p.id!),
                          ),
                        ),
                        child: ProductCard(product: p),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
