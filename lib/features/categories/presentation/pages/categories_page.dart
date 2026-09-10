import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:raag_billing/core/database/app_database.dart';
import '../../../products/presentation/providers/product_providers.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: categoriesAsync.when(
        data: (categories) => ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              title: Text(category.name),
              subtitle: Text(category.description ?? 'No description'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _deleteCategory(context, ref, category),
              ),
              onTap: () => _showCategoryDialog(context, ref, category: category),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $stack')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, WidgetRef ref, {Category? category}) {
    final nameController = TextEditingController(text: category?.name);
    final descController = TextEditingController(text: category?.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'Add Category' : 'Edit Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final repository = ref.read(productRepositoryProvider);
              if (category == null) {
                await repository.addCategory(CategoriesCompanion.insert(
                  name: nameController.text,
                  description: drift.Value(descController.text.isEmpty ? null : descController.text),
                ));
              } else {
                await repository.updateCategory(category.copyWith(
                  name: nameController.text,
                  description: drift.Value(descController.text.isEmpty ? null : descController.text),
                ));
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(BuildContext context, WidgetRef ref, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete ${category.name}? Products in this category will be uncategorized.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(productRepositoryProvider).deleteCategory(category.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

