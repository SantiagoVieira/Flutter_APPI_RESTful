import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'product_form_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductProvider prov;
  Product? product;

  @override
  void initState() {
    super.initState();
    prov = Provider.of<ProductProvider>(context, listen: false);
    product = prov.getById(widget.productId);
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: const Text('¿Confirma que desea eliminar este producto?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(_, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(_, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok == true) {
      await prov.deleteProduct(widget.productId);
      if (prov.status == Status.success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto eliminado')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${prov.errorMessage}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = prov.getById(widget.productId);
    if (p == null) {
      return Scaffold(appBar: AppBar(title: const Text('Detalle')), body: const Center(child: Text('No encontrado')));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(p.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => ProductFormScreen(product: p)));
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            if (p.image.isNotEmpty)
              Image.network(p.image, height: 220, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 120)),
            const SizedBox(height: 12),
            Text(p.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text('\$${p.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text('Categoría: ${p.category}'),
            const SizedBox(height: 12),
            Text(p.description),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 6),
                Text('${p.rating} (${p.ratingCount})'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
