import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get sku => text().nullable()();
  TextColumn get barcode => text().nullable()();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  RealColumn get purchasePrice => real().withDefault(const Constant(0.0))();
  RealColumn get sellingPrice => real().withDefault(const Constant(0.0))();
  RealColumn get taxPercentage => real().withDefault(const Constant(0.0))();
  RealColumn get currentStock => real().withDefault(const Constant(0.0))();
  RealColumn get minimumStock => real().withDefault(const Constant(0.0))();
  TextColumn get unit => text().withDefault(const Constant('pcs'))(); 
  TextColumn get description => text().nullable()();
  TextColumn get rackNumber => text().nullable()();
  TextColumn get batchNumber => text().nullable()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  DateTimeColumn get manufacturingDate => dateTime().nullable()();
  
  // Jewellery Specific Fields
  TextColumn get hsnCode => text().nullable()();
  TextColumn get purity => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  RealColumn get openingBalance => real().withDefault(const Constant(0.0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceNumber => text().unique()();
  IntColumn get customerId => integer().references(Customers, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  RealColumn get subtotal => real().withDefault(const Constant(0.0))();
  RealColumn get taxAmount => real().withDefault(const Constant(0.0))();
  RealColumn get discountAmount => real().withDefault(const Constant(0.0))();
  RealColumn get discountPercentage => real().nullable().withDefault(const Constant(0.0))();
  RealColumn get grandTotal => real().withDefault(const Constant(0.0))();
  RealColumn get paidAmount => real().withDefault(const Constant(0.0))();
  RealColumn get dueAmount => real().withDefault(const Constant(0.0))();
  TextColumn get paymentMethod => text().withDefault(const Constant('Cash'))();
  TextColumn get notes => text().nullable()();
  
  // New Tax Fields
  RealColumn get cgst => real().nullable().withDefault(const Constant(0.0))();
  RealColumn get sgst => real().nullable().withDefault(const Constant(0.0))();
  RealColumn get roundOff => real().nullable().withDefault(const Constant(0.0))();
}

class InvoiceItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer().references(Invoices, #id, onDelete: KeyAction.cascade)();
  IntColumn get productId => integer().references(Products, #id, onDelete: KeyAction.cascade)();
  TextColumn get productName => text()();
  RealColumn get quantity => real()();
  RealColumn get unitPrice => real()();
  RealColumn get taxPercentage => real()();
  RealColumn get discountAmount => real().withDefault(const Constant(0.0))();
  RealColumn get total => real()();

  // Jewellery Specific Fields
  TextColumn get hsnCode => text().nullable()();
  TextColumn get purity => text().nullable()();
  RealColumn get grossWeight => real().nullable()();
  RealColumn get stoneWeight => real().nullable()();
  RealColumn get makingCharges => real().nullable()();
  RealColumn get netWeight => real().nullable()();
  RealColumn get rate => real().nullable()();
  RealColumn get taxableValue => real().nullable()();

  // Pharmacy Specific Fields
  TextColumn get batchNumber => text().nullable()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  DateTimeColumn get manufacturingDate => dateTime().nullable()();
}

class Purchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get purchaseNumber => text().unique()();
  TextColumn get supplierName => text().nullable()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  RealColumn get totalAmount => real()();
  TextColumn get notes => text().nullable()();
}

class PurchaseItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseId => integer().references(Purchases, #id, onDelete: KeyAction.cascade)();
  IntColumn get productId => integer().references(Products, #id, onDelete: KeyAction.cascade)();
  TextColumn get productName => text()();
  RealColumn get quantity => real()();
  RealColumn get purchasePrice => real()();
  RealColumn get total => real()();
}

class StockMovements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id, onDelete: KeyAction.cascade)();
  RealColumn get quantity => real()(); 
  TextColumn get type => text()(); 
  TextColumn get reason => text().nullable()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  IntColumn get referenceId => integer().nullable()(); 
}

class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer().nullable().references(Invoices, #id, onDelete: KeyAction.cascade)();
  IntColumn get customerId => integer().references(Customers, #id, onDelete: KeyAction.cascade)();
  RealColumn get amount => real()();
  TextColumn get method => text()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get notes => text().nullable()();
}

@DataClassName('AppSettingsData')
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get language => text().withDefault(const Constant('en'))();
  BoolColumn get remindersEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get barcodeBeepEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get hideGstin => boolean().withDefault(const Constant(false))();
  BoolColumn get barcodeScanEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get dateFormat => text().withDefault(const Constant('dd/MM/yyyy'))();
  TextColumn get timeFormat => text().withDefault(const Constant('hh:mm a'))();
  TextColumn get themeMode => text().withDefault(const Constant('light'))(); // light, dark, system
  TextColumn get thankYouNote => text().withDefault(const Constant('Thank you for shopping with us!'))();
}

@DataClassName('BusinessProfileData')
class BusinessProfile extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withDefault(const Constant('My Business'))();
  TextColumn get ownerName => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get gstin => text().nullable()();
  TextColumn get upiId => text().nullable()();
  TextColumn get logoPath => text().nullable()();
  TextColumn get invoicePrefix => text().withDefault(const Constant('RB'))();
  TextColumn get currencySymbol => text().withDefault(const Constant('Rs'))();
  RealColumn get defaultTaxPercentage => real().withDefault(const Constant(0.0))();
  TextColumn get shopCategory => text().withDefault(const Constant('General'))();
  TextColumn get bankName => text().nullable()();
  TextColumn get accountNumber => text().nullable()();
  TextColumn get ifscCode => text().nullable()();
  TextColumn get termsAndConditions => text().nullable()();
}

@DriftDatabase(tables: [Categories, Products, Customers, Invoices, InvoiceItems, Purchases, PurchaseItems, StockMovements, Payments, BusinessProfile, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.addColumn(invoices, invoices.discountPercentage);
          await m.addColumn(products, products.rackNumber);
          await m.addColumn(products, products.expiryDate);
          await m.addColumn(products, products.manufacturingDate);
          await m.addColumn(businessProfile, businessProfile.upiId);
        }
        if (from < 3) {
          // Version 3 Migration: Jewellery & Bank Fields
          await m.addColumn(businessProfile, businessProfile.shopCategory);
          await m.addColumn(businessProfile, businessProfile.bankName);
          await m.addColumn(businessProfile, businessProfile.accountNumber);
          await m.addColumn(businessProfile, businessProfile.ifscCode);
          await m.addColumn(businessProfile, businessProfile.termsAndConditions);

          await m.addColumn(products, products.hsnCode);
          await m.addColumn(products, products.purity);

          await m.addColumn(invoices, invoices.cgst);
          await m.addColumn(invoices, invoices.sgst);
          await m.addColumn(invoices, invoices.roundOff);

          await m.addColumn(invoiceItems, invoiceItems.hsnCode);
          await m.addColumn(invoiceItems, invoiceItems.purity);
          await m.addColumn(invoiceItems, invoiceItems.grossWeight);
          await m.addColumn(invoiceItems, invoiceItems.stoneWeight);
          await m.addColumn(invoiceItems, invoiceItems.makingCharges);
          await m.addColumn(invoiceItems, invoiceItems.netWeight);
          await m.addColumn(invoiceItems, invoiceItems.rate);
          await m.addColumn(invoiceItems, invoiceItems.taxableValue);
          
          await customStatement('UPDATE invoices SET discount_percentage = 0 WHERE discount_percentage IS NULL');
        }
        if (from < 4) {
          await m.createTable(appSettings);
        }
        if (from < 5) {
          await m.addColumn(products, products.batchNumber);
          await m.addColumn(invoiceItems, invoiceItems.batchNumber);
          await m.addColumn(invoiceItems, invoiceItems.expiryDate);
          await m.addColumn(invoiceItems, invoiceItems.manufacturingDate);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'raag_billing.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
