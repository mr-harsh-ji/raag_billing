import 'package:raag_billing/core/database/app_database.dart';

class CartItem {
  final Product product;
  final double quantity;
  
  // Jewellery Specific Fields
  final double? grossWeight;
  final double? stoneWeight;
  final double? makingCharges;
  final double? rate;
  final String? purity;
  final String? hsnCode;

  // Pharmacy Specific Fields
  final String? batchNumber;
  final DateTime? expiryDate;
  final DateTime? manufacturingDate;

  CartItem({
    required this.product, 
    required this.quantity,
    this.grossWeight,
    this.stoneWeight,
    this.makingCharges,
    this.rate,
    this.purity,
    this.hsnCode,
    this.batchNumber,
    this.expiryDate,
    this.manufacturingDate,
  });

  CartItem copyWith({
    Product? product, 
    double? quantity,
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
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      grossWeight: grossWeight ?? this.grossWeight,
      stoneWeight: stoneWeight ?? this.stoneWeight,
      makingCharges: makingCharges ?? this.makingCharges,
      rate: rate ?? this.rate,
      purity: purity ?? this.purity,
      hsnCode: hsnCode ?? this.hsnCode,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      manufacturingDate: manufacturingDate ?? this.manufacturingDate,
    );
  }

  double get netWeight => (grossWeight ?? 0.0) - (stoneWeight ?? 0.0);

  double get taxableValue {
    // If it's a jewellery item (has weight and rate)
    if (grossWeight != null && rate != null) {
      return (netWeight * rate!) + (makingCharges ?? 0.0);
    }
    // Default calculation
    return product.sellingPrice * quantity;
  }

  double get total => taxableValue; // subtotal only, tax added at cart level or here?
  
  // Actually, total in the image usually includes GST at row level
  double get totalWithTax => taxableValue + (taxableValue * (product.taxPercentage / 100));
}
