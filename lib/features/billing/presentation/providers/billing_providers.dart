import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raag_billing/core/database/app_database.dart';
import 'package:raag_billing/core/database/database_provider.dart';
import '../models/cart_item.dart';
import '../../data/repositories/billing_repository.dart';

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return BillingRepository(db);
});

class CartState {
  final List<CartItem> items;
  final Customer? customer;
  final double discountPercentage;

  CartState({
    this.items = const [],
    this.customer,
    this.discountPercentage = 0.0,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.taxableValue);
  
  double get totalTax => items.fold(0, (sum, item) {
    return sum + (item.taxableValue * (item.product.taxPercentage / 100));
  });

  double get discountAmount => (subtotal + totalTax) * (discountPercentage / 100);

  double get grandTotalBeforeRound => subtotal + totalTax - discountAmount;
  
  double get grandTotal => grandTotalBeforeRound.roundToDouble();
  
  double get roundOff => grandTotal - grandTotalBeforeRound;

  CartState copyWith({
    List<CartItem>? items,
    Customer? customer,
    double? discountPercentage,
  }) {
    return CartState(
      items: items ?? this.items,
      customer: customer ?? this.customer,
      discountPercentage: discountPercentage ?? this.discountPercentage,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  void setCustomer(Customer customer) {
    state = state.copyWith(customer: customer);
  }

  void addItem(Product product, {
    double quantity = 1,
    double? grossWeight,
    double? stoneWeight,
    double? makingCharges,
    double? rate,
    String? purity,
    String? hsnCode,
    String? batchNumber,
    DateTime? expiryDate,
    DateTime? manufacturingDate,
  }) {
    final existingIndex = state.items.indexWhere((item) => item.product.id == product.id);
    
    // For Jewellery or Pharmacy with specific batch info, we might want to add separate entries 
    // even for same product if weights or batches differ.
    
    bool shouldMerge = existingIndex >= 0 && 
                      grossWeight == null && 
                      batchNumber == null;

    if (shouldMerge) {
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      state = state.copyWith(items: [
        ...state.items, 
        CartItem(
          product: product, 
          quantity: quantity,
          grossWeight: grossWeight,
          stoneWeight: stoneWeight,
          makingCharges: makingCharges,
          rate: rate,
          purity: purity ?? product.purity,
          hsnCode: hsnCode ?? product.hsnCode,
          batchNumber: batchNumber ?? product.batchNumber,
          expiryDate: expiryDate ?? product.expiryDate,
          manufacturingDate: manufacturingDate ?? product.manufacturingDate,
        )
      ]);
    }
  }

  void updateQuantity(int productId, double quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    state = state.copyWith(
      items: state.items.map((item) => item.product.id == productId ? item.copyWith(quantity: quantity) : item).toList(),
    );
  }

  void removeItem(int productId) {
    state = state.copyWith(items: state.items.where((item) => item.product.id != productId).toList());
  }

  void setDiscountPercentage(double percentage) {
    state = state.copyWith(discountPercentage: percentage);
  }

  void clear() {
    state = CartState();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) => CartNotifier());

final invoicesStreamProvider = StreamProvider<List<Invoice>>((ref) {
  return ref.watch(billingRepositoryProvider).watchAllInvoices();
});

final invoiceItemsProvider = FutureProvider.family<List<InvoiceItem>, int>((ref, invoiceId) {
  return ref.watch(billingRepositoryProvider).getInvoiceItems(invoiceId);
});

