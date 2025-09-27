import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../utils/validators.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({Key? key, this.product}) : super(key: key);

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _category;
  late String _image;
  late double _price;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _title = p?.title ?? '';
    _description = p?.description ?? '';
    _category = p?.category ?? '';
    _image = p?.image ?? '';
    _price = p?.price ?? 0.0;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _submitting = true);
    final prov = Provider.of<ProductProvider>(context, listen: false);
    final product = Product(
      id: widget.product?.id,
      title: _title,
      price: _price,
      description: _description,
      category: _category,
      image: _image,
    );
    if (widget.product == null) {
      await prov.addProduct(product);
      if (prov.status == Status.success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto creado')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${prov.errorMessage}')));
      }
    } else {
      await prov.updateProduct(product);
      if (prov.status == Status.success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto actualizado')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${prov.errorMessage}')));
      }
    }
    setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar producto' : 'Crear producto')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: Validators.required,
                onSaved: (v) => _title = v!.trim(),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _price == 0.0 ? '' : _price.toString(),
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Precio requerido';
                  final n = double.tryParse(v);
                  if (n == null) return 'Precio inválido';
                  if (n < 0) return 'Precio debe ser >= 0';
                  return null;
                },
                onSaved: (v) => _price = double.parse(v!.trim()),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: Validators.required,
                onSaved: (v) => _category = v!.trim(),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _image,
                decoration: const InputDecoration(labelText: 'URL imagen'),
                validator: Validators.optionalUrl,
                onSaved: (v) => _image = v!.trim(),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 4,
                validator: Validators.required,
                onSaved: (v) => _description = v!.trim(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting ? const CircularProgressIndicator() : Text(isEdit ? 'Guardar' : 'Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
