// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, description, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final String? description;
  final DateTime createdAt;
  const Category(
      {required this.id,
      required this.name,
      this.description,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Category copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          DateTime? createdAt}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<DateTime>? createdAt}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
      'sku', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES categories (id) ON DELETE SET NULL'));
  static const VerificationMeta _purchasePriceMeta =
      const VerificationMeta('purchasePrice');
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
      'purchase_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _sellingPriceMeta =
      const VerificationMeta('sellingPrice');
  @override
  late final GeneratedColumn<double> sellingPrice = GeneratedColumn<double>(
      'selling_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _taxPercentageMeta =
      const VerificationMeta('taxPercentage');
  @override
  late final GeneratedColumn<double> taxPercentage = GeneratedColumn<double>(
      'tax_percentage', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _currentStockMeta =
      const VerificationMeta('currentStock');
  @override
  late final GeneratedColumn<double> currentStock = GeneratedColumn<double>(
      'current_stock', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _minimumStockMeta =
      const VerificationMeta('minimumStock');
  @override
  late final GeneratedColumn<double> minimumStock = GeneratedColumn<double>(
      'minimum_stock', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pcs'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rackNumberMeta =
      const VerificationMeta('rackNumber');
  @override
  late final GeneratedColumn<String> rackNumber = GeneratedColumn<String>(
      'rack_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _batchNumberMeta =
      const VerificationMeta('batchNumber');
  @override
  late final GeneratedColumn<String> batchNumber = GeneratedColumn<String>(
      'batch_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
      'expiry_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _manufacturingDateMeta =
      const VerificationMeta('manufacturingDate');
  @override
  late final GeneratedColumn<DateTime> manufacturingDate =
      GeneratedColumn<DateTime>('manufacturing_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _hsnCodeMeta =
      const VerificationMeta('hsnCode');
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
      'hsn_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purityMeta = const VerificationMeta('purity');
  @override
  late final GeneratedColumn<String> purity = GeneratedColumn<String>(
      'purity', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        sku,
        barcode,
        categoryId,
        purchasePrice,
        sellingPrice,
        taxPercentage,
        currentStock,
        minimumStock,
        unit,
        description,
        rackNumber,
        batchNumber,
        expiryDate,
        manufacturingDate,
        hsnCode,
        purity,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
          _skuMeta, sku.isAcceptableOrUnknown(data['sku']!, _skuMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
          _purchasePriceMeta,
          purchasePrice.isAcceptableOrUnknown(
              data['purchase_price']!, _purchasePriceMeta));
    }
    if (data.containsKey('selling_price')) {
      context.handle(
          _sellingPriceMeta,
          sellingPrice.isAcceptableOrUnknown(
              data['selling_price']!, _sellingPriceMeta));
    }
    if (data.containsKey('tax_percentage')) {
      context.handle(
          _taxPercentageMeta,
          taxPercentage.isAcceptableOrUnknown(
              data['tax_percentage']!, _taxPercentageMeta));
    }
    if (data.containsKey('current_stock')) {
      context.handle(
          _currentStockMeta,
          currentStock.isAcceptableOrUnknown(
              data['current_stock']!, _currentStockMeta));
    }
    if (data.containsKey('minimum_stock')) {
      context.handle(
          _minimumStockMeta,
          minimumStock.isAcceptableOrUnknown(
              data['minimum_stock']!, _minimumStockMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('rack_number')) {
      context.handle(
          _rackNumberMeta,
          rackNumber.isAcceptableOrUnknown(
              data['rack_number']!, _rackNumberMeta));
    }
    if (data.containsKey('batch_number')) {
      context.handle(
          _batchNumberMeta,
          batchNumber.isAcceptableOrUnknown(
              data['batch_number']!, _batchNumberMeta));
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    }
    if (data.containsKey('manufacturing_date')) {
      context.handle(
          _manufacturingDateMeta,
          manufacturingDate.isAcceptableOrUnknown(
              data['manufacturing_date']!, _manufacturingDateMeta));
    }
    if (data.containsKey('hsn_code')) {
      context.handle(_hsnCodeMeta,
          hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta));
    }
    if (data.containsKey('purity')) {
      context.handle(_purityMeta,
          purity.isAcceptableOrUnknown(data['purity']!, _purityMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sku: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sku']),
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      purchasePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}purchase_price'])!,
      sellingPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}selling_price'])!,
      taxPercentage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_percentage'])!,
      currentStock: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_stock'])!,
      minimumStock: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}minimum_stock'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      rackNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rack_number']),
      batchNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_number']),
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiry_date']),
      manufacturingDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}manufacturing_date']),
      hsnCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hsn_code']),
      purity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purity']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final String? sku;
  final String? barcode;
  final int? categoryId;
  final double purchasePrice;
  final double sellingPrice;
  final double taxPercentage;
  final double currentStock;
  final double minimumStock;
  final String unit;
  final String? description;
  final String? rackNumber;
  final String? batchNumber;
  final DateTime? expiryDate;
  final DateTime? manufacturingDate;
  final String? hsnCode;
  final String? purity;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Product(
      {required this.id,
      required this.name,
      this.sku,
      this.barcode,
      this.categoryId,
      required this.purchasePrice,
      required this.sellingPrice,
      required this.taxPercentage,
      required this.currentStock,
      required this.minimumStock,
      required this.unit,
      this.description,
      this.rackNumber,
      this.batchNumber,
      this.expiryDate,
      this.manufacturingDate,
      this.hsnCode,
      this.purity,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sku != null) {
      map['sku'] = Variable<String>(sku);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['purchase_price'] = Variable<double>(purchasePrice);
    map['selling_price'] = Variable<double>(sellingPrice);
    map['tax_percentage'] = Variable<double>(taxPercentage);
    map['current_stock'] = Variable<double>(currentStock);
    map['minimum_stock'] = Variable<double>(minimumStock);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || rackNumber != null) {
      map['rack_number'] = Variable<String>(rackNumber);
    }
    if (!nullToAbsent || batchNumber != null) {
      map['batch_number'] = Variable<String>(batchNumber);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    if (!nullToAbsent || manufacturingDate != null) {
      map['manufacturing_date'] = Variable<DateTime>(manufacturingDate);
    }
    if (!nullToAbsent || hsnCode != null) {
      map['hsn_code'] = Variable<String>(hsnCode);
    }
    if (!nullToAbsent || purity != null) {
      map['purity'] = Variable<String>(purity);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      sku: sku == null && nullToAbsent ? const Value.absent() : Value(sku),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      purchasePrice: Value(purchasePrice),
      sellingPrice: Value(sellingPrice),
      taxPercentage: Value(taxPercentage),
      currentStock: Value(currentStock),
      minimumStock: Value(minimumStock),
      unit: Value(unit),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      rackNumber: rackNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(rackNumber),
      batchNumber: batchNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(batchNumber),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      manufacturingDate: manufacturingDate == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturingDate),
      hsnCode: hsnCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnCode),
      purity:
          purity == null && nullToAbsent ? const Value.absent() : Value(purity),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sku: serializer.fromJson<String?>(json['sku']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      purchasePrice: serializer.fromJson<double>(json['purchasePrice']),
      sellingPrice: serializer.fromJson<double>(json['sellingPrice']),
      taxPercentage: serializer.fromJson<double>(json['taxPercentage']),
      currentStock: serializer.fromJson<double>(json['currentStock']),
      minimumStock: serializer.fromJson<double>(json['minimumStock']),
      unit: serializer.fromJson<String>(json['unit']),
      description: serializer.fromJson<String?>(json['description']),
      rackNumber: serializer.fromJson<String?>(json['rackNumber']),
      batchNumber: serializer.fromJson<String?>(json['batchNumber']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      manufacturingDate:
          serializer.fromJson<DateTime?>(json['manufacturingDate']),
      hsnCode: serializer.fromJson<String?>(json['hsnCode']),
      purity: serializer.fromJson<String?>(json['purity']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sku': serializer.toJson<String?>(sku),
      'barcode': serializer.toJson<String?>(barcode),
      'categoryId': serializer.toJson<int?>(categoryId),
      'purchasePrice': serializer.toJson<double>(purchasePrice),
      'sellingPrice': serializer.toJson<double>(sellingPrice),
      'taxPercentage': serializer.toJson<double>(taxPercentage),
      'currentStock': serializer.toJson<double>(currentStock),
      'minimumStock': serializer.toJson<double>(minimumStock),
      'unit': serializer.toJson<String>(unit),
      'description': serializer.toJson<String?>(description),
      'rackNumber': serializer.toJson<String?>(rackNumber),
      'batchNumber': serializer.toJson<String?>(batchNumber),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'manufacturingDate': serializer.toJson<DateTime?>(manufacturingDate),
      'hsnCode': serializer.toJson<String?>(hsnCode),
      'purity': serializer.toJson<String?>(purity),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Product copyWith(
          {int? id,
          String? name,
          Value<String?> sku = const Value.absent(),
          Value<String?> barcode = const Value.absent(),
          Value<int?> categoryId = const Value.absent(),
          double? purchasePrice,
          double? sellingPrice,
          double? taxPercentage,
          double? currentStock,
          double? minimumStock,
          String? unit,
          Value<String?> description = const Value.absent(),
          Value<String?> rackNumber = const Value.absent(),
          Value<String?> batchNumber = const Value.absent(),
          Value<DateTime?> expiryDate = const Value.absent(),
          Value<DateTime?> manufacturingDate = const Value.absent(),
          Value<String?> hsnCode = const Value.absent(),
          Value<String?> purity = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        sku: sku.present ? sku.value : this.sku,
        barcode: barcode.present ? barcode.value : this.barcode,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        sellingPrice: sellingPrice ?? this.sellingPrice,
        taxPercentage: taxPercentage ?? this.taxPercentage,
        currentStock: currentStock ?? this.currentStock,
        minimumStock: minimumStock ?? this.minimumStock,
        unit: unit ?? this.unit,
        description: description.present ? description.value : this.description,
        rackNumber: rackNumber.present ? rackNumber.value : this.rackNumber,
        batchNumber: batchNumber.present ? batchNumber.value : this.batchNumber,
        expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
        manufacturingDate: manufacturingDate.present
            ? manufacturingDate.value
            : this.manufacturingDate,
        hsnCode: hsnCode.present ? hsnCode.value : this.hsnCode,
        purity: purity.present ? purity.value : this.purity,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sku: data.sku.present ? data.sku.value : this.sku,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
      taxPercentage: data.taxPercentage.present
          ? data.taxPercentage.value
          : this.taxPercentage,
      currentStock: data.currentStock.present
          ? data.currentStock.value
          : this.currentStock,
      minimumStock: data.minimumStock.present
          ? data.minimumStock.value
          : this.minimumStock,
      unit: data.unit.present ? data.unit.value : this.unit,
      description:
          data.description.present ? data.description.value : this.description,
      rackNumber:
          data.rackNumber.present ? data.rackNumber.value : this.rackNumber,
      batchNumber:
          data.batchNumber.present ? data.batchNumber.value : this.batchNumber,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      manufacturingDate: data.manufacturingDate.present
          ? data.manufacturingDate.value
          : this.manufacturingDate,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      purity: data.purity.present ? data.purity.value : this.purity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('categoryId: $categoryId, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('taxPercentage: $taxPercentage, ')
          ..write('currentStock: $currentStock, ')
          ..write('minimumStock: $minimumStock, ')
          ..write('unit: $unit, ')
          ..write('description: $description, ')
          ..write('rackNumber: $rackNumber, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('manufacturingDate: $manufacturingDate, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('purity: $purity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      sku,
      barcode,
      categoryId,
      purchasePrice,
      sellingPrice,
      taxPercentage,
      currentStock,
      minimumStock,
      unit,
      description,
      rackNumber,
      batchNumber,
      expiryDate,
      manufacturingDate,
      hsnCode,
      purity,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.sku == this.sku &&
          other.barcode == this.barcode &&
          other.categoryId == this.categoryId &&
          other.purchasePrice == this.purchasePrice &&
          other.sellingPrice == this.sellingPrice &&
          other.taxPercentage == this.taxPercentage &&
          other.currentStock == this.currentStock &&
          other.minimumStock == this.minimumStock &&
          other.unit == this.unit &&
          other.description == this.description &&
          other.rackNumber == this.rackNumber &&
          other.batchNumber == this.batchNumber &&
          other.expiryDate == this.expiryDate &&
          other.manufacturingDate == this.manufacturingDate &&
          other.hsnCode == this.hsnCode &&
          other.purity == this.purity &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> sku;
  final Value<String?> barcode;
  final Value<int?> categoryId;
  final Value<double> purchasePrice;
  final Value<double> sellingPrice;
  final Value<double> taxPercentage;
  final Value<double> currentStock;
  final Value<double> minimumStock;
  final Value<String> unit;
  final Value<String?> description;
  final Value<String?> rackNumber;
  final Value<String?> batchNumber;
  final Value<DateTime?> expiryDate;
  final Value<DateTime?> manufacturingDate;
  final Value<String?> hsnCode;
  final Value<String?> purity;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.taxPercentage = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.minimumStock = const Value.absent(),
    this.unit = const Value.absent(),
    this.description = const Value.absent(),
    this.rackNumber = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.manufacturingDate = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.purity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.taxPercentage = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.minimumStock = const Value.absent(),
    this.unit = const Value.absent(),
    this.description = const Value.absent(),
    this.rackNumber = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.manufacturingDate = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.purity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? sku,
    Expression<String>? barcode,
    Expression<int>? categoryId,
    Expression<double>? purchasePrice,
    Expression<double>? sellingPrice,
    Expression<double>? taxPercentage,
    Expression<double>? currentStock,
    Expression<double>? minimumStock,
    Expression<String>? unit,
    Expression<String>? description,
    Expression<String>? rackNumber,
    Expression<String>? batchNumber,
    Expression<DateTime>? expiryDate,
    Expression<DateTime>? manufacturingDate,
    Expression<String>? hsnCode,
    Expression<String>? purity,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sku != null) 'sku': sku,
      if (barcode != null) 'barcode': barcode,
      if (categoryId != null) 'category_id': categoryId,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (sellingPrice != null) 'selling_price': sellingPrice,
      if (taxPercentage != null) 'tax_percentage': taxPercentage,
      if (currentStock != null) 'current_stock': currentStock,
      if (minimumStock != null) 'minimum_stock': minimumStock,
      if (unit != null) 'unit': unit,
      if (description != null) 'description': description,
      if (rackNumber != null) 'rack_number': rackNumber,
      if (batchNumber != null) 'batch_number': batchNumber,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (manufacturingDate != null) 'manufacturing_date': manufacturingDate,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (purity != null) 'purity': purity,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? sku,
      Value<String?>? barcode,
      Value<int?>? categoryId,
      Value<double>? purchasePrice,
      Value<double>? sellingPrice,
      Value<double>? taxPercentage,
      Value<double>? currentStock,
      Value<double>? minimumStock,
      Value<String>? unit,
      Value<String?>? description,
      Value<String?>? rackNumber,
      Value<String?>? batchNumber,
      Value<DateTime?>? expiryDate,
      Value<DateTime?>? manufacturingDate,
      Value<String?>? hsnCode,
      Value<String?>? purity,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      categoryId: categoryId ?? this.categoryId,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      currentStock: currentStock ?? this.currentStock,
      minimumStock: minimumStock ?? this.minimumStock,
      unit: unit ?? this.unit,
      description: description ?? this.description,
      rackNumber: rackNumber ?? this.rackNumber,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      manufacturingDate: manufacturingDate ?? this.manufacturingDate,
      hsnCode: hsnCode ?? this.hsnCode,
      purity: purity ?? this.purity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<double>(sellingPrice.value);
    }
    if (taxPercentage.present) {
      map['tax_percentage'] = Variable<double>(taxPercentage.value);
    }
    if (currentStock.present) {
      map['current_stock'] = Variable<double>(currentStock.value);
    }
    if (minimumStock.present) {
      map['minimum_stock'] = Variable<double>(minimumStock.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rackNumber.present) {
      map['rack_number'] = Variable<String>(rackNumber.value);
    }
    if (batchNumber.present) {
      map['batch_number'] = Variable<String>(batchNumber.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (manufacturingDate.present) {
      map['manufacturing_date'] = Variable<DateTime>(manufacturingDate.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (purity.present) {
      map['purity'] = Variable<String>(purity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('categoryId: $categoryId, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('taxPercentage: $taxPercentage, ')
          ..write('currentStock: $currentStock, ')
          ..write('minimumStock: $minimumStock, ')
          ..write('unit: $unit, ')
          ..write('description: $description, ')
          ..write('rackNumber: $rackNumber, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('manufacturingDate: $manufacturingDate, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('purity: $purity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _openingBalanceMeta =
      const VerificationMeta('openingBalance');
  @override
  late final GeneratedColumn<double> openingBalance = GeneratedColumn<double>(
      'opening_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        phone,
        email,
        address,
        openingBalance,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
          _openingBalanceMeta,
          openingBalance.isAcceptableOrUnknown(
              data['opening_balance']!, _openingBalanceMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      openingBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}opening_balance'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final double openingBalance;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Customer(
      {required this.id,
      required this.name,
      this.phone,
      this.email,
      this.address,
      required this.openingBalance,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['opening_balance'] = Variable<double>(openingBalance);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      openingBalance: Value(openingBalance),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      openingBalance: serializer.fromJson<double>(json['openingBalance']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'openingBalance': serializer.toJson<double>(openingBalance),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Customer copyWith(
          {int? id,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          double? openingBalance,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Customer(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        openingBalance: openingBalance ?? this.openingBalance,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, email, address,
      openingBalance, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.openingBalance == this.openingBalance &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<double> openingBalance;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<double>? openingBalance,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CustomersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<double>? openingBalance,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      openingBalance: openingBalance ?? this.openingBalance,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<double>(openingBalance.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _invoiceNumberMeta =
      const VerificationMeta('invoiceNumber');
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
      'invoice_number', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _taxAmountMeta =
      const VerificationMeta('taxAmount');
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
      'tax_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _discountAmountMeta =
      const VerificationMeta('discountAmount');
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
      'discount_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _discountPercentageMeta =
      const VerificationMeta('discountPercentage');
  @override
  late final GeneratedColumn<double> discountPercentage =
      GeneratedColumn<double>('discount_percentage', aliasedName, true,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _grandTotalMeta =
      const VerificationMeta('grandTotal');
  @override
  late final GeneratedColumn<double> grandTotal = GeneratedColumn<double>(
      'grand_total', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _paidAmountMeta =
      const VerificationMeta('paidAmount');
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
      'paid_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _dueAmountMeta =
      const VerificationMeta('dueAmount');
  @override
  late final GeneratedColumn<double> dueAmount = GeneratedColumn<double>(
      'due_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Cash'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cgstMeta = const VerificationMeta('cgst');
  @override
  late final GeneratedColumn<double> cgst = GeneratedColumn<double>(
      'cgst', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _sgstMeta = const VerificationMeta('sgst');
  @override
  late final GeneratedColumn<double> sgst = GeneratedColumn<double>(
      'sgst', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _roundOffMeta =
      const VerificationMeta('roundOff');
  @override
  late final GeneratedColumn<double> roundOff = GeneratedColumn<double>(
      'round_off', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        invoiceNumber,
        customerId,
        date,
        subtotal,
        taxAmount,
        discountAmount,
        discountPercentage,
        grandTotal,
        paidAmount,
        dueAmount,
        paymentMethod,
        notes,
        cgst,
        sgst,
        roundOff
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(Insertable<Invoice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
          _invoiceNumberMeta,
          invoiceNumber.isAcceptableOrUnknown(
              data['invoice_number']!, _invoiceNumberMeta));
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    }
    if (data.containsKey('tax_amount')) {
      context.handle(_taxAmountMeta,
          taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta));
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
          _discountAmountMeta,
          discountAmount.isAcceptableOrUnknown(
              data['discount_amount']!, _discountAmountMeta));
    }
    if (data.containsKey('discount_percentage')) {
      context.handle(
          _discountPercentageMeta,
          discountPercentage.isAcceptableOrUnknown(
              data['discount_percentage']!, _discountPercentageMeta));
    }
    if (data.containsKey('grand_total')) {
      context.handle(
          _grandTotalMeta,
          grandTotal.isAcceptableOrUnknown(
              data['grand_total']!, _grandTotalMeta));
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
          _paidAmountMeta,
          paidAmount.isAcceptableOrUnknown(
              data['paid_amount']!, _paidAmountMeta));
    }
    if (data.containsKey('due_amount')) {
      context.handle(_dueAmountMeta,
          dueAmount.isAcceptableOrUnknown(data['due_amount']!, _dueAmountMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('cgst')) {
      context.handle(
          _cgstMeta, cgst.isAcceptableOrUnknown(data['cgst']!, _cgstMeta));
    }
    if (data.containsKey('sgst')) {
      context.handle(
          _sgstMeta, sgst.isAcceptableOrUnknown(data['sgst']!, _sgstMeta));
    }
    if (data.containsKey('round_off')) {
      context.handle(_roundOffMeta,
          roundOff.isAcceptableOrUnknown(data['round_off']!, _roundOffMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      invoiceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_number'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      taxAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_amount'])!,
      discountAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_amount'])!,
      discountPercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_percentage']),
      grandTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}grand_total'])!,
      paidAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}paid_amount'])!,
      dueAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}due_amount'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      cgst: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cgst']),
      sgst: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sgst']),
      roundOff: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}round_off']),
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class Invoice extends DataClass implements Insertable<Invoice> {
  final int id;
  final String invoiceNumber;
  final int customerId;
  final DateTime date;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double? discountPercentage;
  final double grandTotal;
  final double paidAmount;
  final double dueAmount;
  final String paymentMethod;
  final String? notes;
  final double? cgst;
  final double? sgst;
  final double? roundOff;
  const Invoice(
      {required this.id,
      required this.invoiceNumber,
      required this.customerId,
      required this.date,
      required this.subtotal,
      required this.taxAmount,
      required this.discountAmount,
      this.discountPercentage,
      required this.grandTotal,
      required this.paidAmount,
      required this.dueAmount,
      required this.paymentMethod,
      this.notes,
      this.cgst,
      this.sgst,
      this.roundOff});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['customer_id'] = Variable<int>(customerId);
    map['date'] = Variable<DateTime>(date);
    map['subtotal'] = Variable<double>(subtotal);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['discount_amount'] = Variable<double>(discountAmount);
    if (!nullToAbsent || discountPercentage != null) {
      map['discount_percentage'] = Variable<double>(discountPercentage);
    }
    map['grand_total'] = Variable<double>(grandTotal);
    map['paid_amount'] = Variable<double>(paidAmount);
    map['due_amount'] = Variable<double>(dueAmount);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || cgst != null) {
      map['cgst'] = Variable<double>(cgst);
    }
    if (!nullToAbsent || sgst != null) {
      map['sgst'] = Variable<double>(sgst);
    }
    if (!nullToAbsent || roundOff != null) {
      map['round_off'] = Variable<double>(roundOff);
    }
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      invoiceNumber: Value(invoiceNumber),
      customerId: Value(customerId),
      date: Value(date),
      subtotal: Value(subtotal),
      taxAmount: Value(taxAmount),
      discountAmount: Value(discountAmount),
      discountPercentage: discountPercentage == null && nullToAbsent
          ? const Value.absent()
          : Value(discountPercentage),
      grandTotal: Value(grandTotal),
      paidAmount: Value(paidAmount),
      dueAmount: Value(dueAmount),
      paymentMethod: Value(paymentMethod),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      cgst: cgst == null && nullToAbsent ? const Value.absent() : Value(cgst),
      sgst: sgst == null && nullToAbsent ? const Value.absent() : Value(sgst),
      roundOff: roundOff == null && nullToAbsent
          ? const Value.absent()
          : Value(roundOff),
    );
  }

  factory Invoice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      id: serializer.fromJson<int>(json['id']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      customerId: serializer.fromJson<int>(json['customerId']),
      date: serializer.fromJson<DateTime>(json['date']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      discountPercentage:
          serializer.fromJson<double?>(json['discountPercentage']),
      grandTotal: serializer.fromJson<double>(json['grandTotal']),
      paidAmount: serializer.fromJson<double>(json['paidAmount']),
      dueAmount: serializer.fromJson<double>(json['dueAmount']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      notes: serializer.fromJson<String?>(json['notes']),
      cgst: serializer.fromJson<double?>(json['cgst']),
      sgst: serializer.fromJson<double?>(json['sgst']),
      roundOff: serializer.fromJson<double?>(json['roundOff']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'customerId': serializer.toJson<int>(customerId),
      'date': serializer.toJson<DateTime>(date),
      'subtotal': serializer.toJson<double>(subtotal),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'discountPercentage': serializer.toJson<double?>(discountPercentage),
      'grandTotal': serializer.toJson<double>(grandTotal),
      'paidAmount': serializer.toJson<double>(paidAmount),
      'dueAmount': serializer.toJson<double>(dueAmount),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'notes': serializer.toJson<String?>(notes),
      'cgst': serializer.toJson<double?>(cgst),
      'sgst': serializer.toJson<double?>(sgst),
      'roundOff': serializer.toJson<double?>(roundOff),
    };
  }

  Invoice copyWith(
          {int? id,
          String? invoiceNumber,
          int? customerId,
          DateTime? date,
          double? subtotal,
          double? taxAmount,
          double? discountAmount,
          Value<double?> discountPercentage = const Value.absent(),
          double? grandTotal,
          double? paidAmount,
          double? dueAmount,
          String? paymentMethod,
          Value<String?> notes = const Value.absent(),
          Value<double?> cgst = const Value.absent(),
          Value<double?> sgst = const Value.absent(),
          Value<double?> roundOff = const Value.absent()}) =>
      Invoice(
        id: id ?? this.id,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        customerId: customerId ?? this.customerId,
        date: date ?? this.date,
        subtotal: subtotal ?? this.subtotal,
        taxAmount: taxAmount ?? this.taxAmount,
        discountAmount: discountAmount ?? this.discountAmount,
        discountPercentage: discountPercentage.present
            ? discountPercentage.value
            : this.discountPercentage,
        grandTotal: grandTotal ?? this.grandTotal,
        paidAmount: paidAmount ?? this.paidAmount,
        dueAmount: dueAmount ?? this.dueAmount,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        notes: notes.present ? notes.value : this.notes,
        cgst: cgst.present ? cgst.value : this.cgst,
        sgst: sgst.present ? sgst.value : this.sgst,
        roundOff: roundOff.present ? roundOff.value : this.roundOff,
      );
  Invoice copyWithCompanion(InvoicesCompanion data) {
    return Invoice(
      id: data.id.present ? data.id.value : this.id,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      date: data.date.present ? data.date.value : this.date,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      discountPercentage: data.discountPercentage.present
          ? data.discountPercentage.value
          : this.discountPercentage,
      grandTotal:
          data.grandTotal.present ? data.grandTotal.value : this.grandTotal,
      paidAmount:
          data.paidAmount.present ? data.paidAmount.value : this.paidAmount,
      dueAmount: data.dueAmount.present ? data.dueAmount.value : this.dueAmount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      notes: data.notes.present ? data.notes.value : this.notes,
      cgst: data.cgst.present ? data.cgst.value : this.cgst,
      sgst: data.sgst.present ? data.sgst.value : this.sgst,
      roundOff: data.roundOff.present ? data.roundOff.value : this.roundOff,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('customerId: $customerId, ')
          ..write('date: $date, ')
          ..write('subtotal: $subtotal, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('dueAmount: $dueAmount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes, ')
          ..write('cgst: $cgst, ')
          ..write('sgst: $sgst, ')
          ..write('roundOff: $roundOff')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      invoiceNumber,
      customerId,
      date,
      subtotal,
      taxAmount,
      discountAmount,
      discountPercentage,
      grandTotal,
      paidAmount,
      dueAmount,
      paymentMethod,
      notes,
      cgst,
      sgst,
      roundOff);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.id == this.id &&
          other.invoiceNumber == this.invoiceNumber &&
          other.customerId == this.customerId &&
          other.date == this.date &&
          other.subtotal == this.subtotal &&
          other.taxAmount == this.taxAmount &&
          other.discountAmount == this.discountAmount &&
          other.discountPercentage == this.discountPercentage &&
          other.grandTotal == this.grandTotal &&
          other.paidAmount == this.paidAmount &&
          other.dueAmount == this.dueAmount &&
          other.paymentMethod == this.paymentMethod &&
          other.notes == this.notes &&
          other.cgst == this.cgst &&
          other.sgst == this.sgst &&
          other.roundOff == this.roundOff);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<int> id;
  final Value<String> invoiceNumber;
  final Value<int> customerId;
  final Value<DateTime> date;
  final Value<double> subtotal;
  final Value<double> taxAmount;
  final Value<double> discountAmount;
  final Value<double?> discountPercentage;
  final Value<double> grandTotal;
  final Value<double> paidAmount;
  final Value<double> dueAmount;
  final Value<String> paymentMethod;
  final Value<String?> notes;
  final Value<double?> cgst;
  final Value<double?> sgst;
  final Value<double?> roundOff;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.customerId = const Value.absent(),
    this.date = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.dueAmount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.cgst = const Value.absent(),
    this.sgst = const Value.absent(),
    this.roundOff = const Value.absent(),
  });
  InvoicesCompanion.insert({
    this.id = const Value.absent(),
    required String invoiceNumber,
    required int customerId,
    this.date = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.dueAmount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.cgst = const Value.absent(),
    this.sgst = const Value.absent(),
    this.roundOff = const Value.absent(),
  })  : invoiceNumber = Value(invoiceNumber),
        customerId = Value(customerId);
  static Insertable<Invoice> custom({
    Expression<int>? id,
    Expression<String>? invoiceNumber,
    Expression<int>? customerId,
    Expression<DateTime>? date,
    Expression<double>? subtotal,
    Expression<double>? taxAmount,
    Expression<double>? discountAmount,
    Expression<double>? discountPercentage,
    Expression<double>? grandTotal,
    Expression<double>? paidAmount,
    Expression<double>? dueAmount,
    Expression<String>? paymentMethod,
    Expression<String>? notes,
    Expression<double>? cgst,
    Expression<double>? sgst,
    Expression<double>? roundOff,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (customerId != null) 'customer_id': customerId,
      if (date != null) 'date': date,
      if (subtotal != null) 'subtotal': subtotal,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (discountPercentage != null) 'discount_percentage': discountPercentage,
      if (grandTotal != null) 'grand_total': grandTotal,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (dueAmount != null) 'due_amount': dueAmount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (notes != null) 'notes': notes,
      if (cgst != null) 'cgst': cgst,
      if (sgst != null) 'sgst': sgst,
      if (roundOff != null) 'round_off': roundOff,
    });
  }

  InvoicesCompanion copyWith(
      {Value<int>? id,
      Value<String>? invoiceNumber,
      Value<int>? customerId,
      Value<DateTime>? date,
      Value<double>? subtotal,
      Value<double>? taxAmount,
      Value<double>? discountAmount,
      Value<double?>? discountPercentage,
      Value<double>? grandTotal,
      Value<double>? paidAmount,
      Value<double>? dueAmount,
      Value<String>? paymentMethod,
      Value<String?>? notes,
      Value<double?>? cgst,
      Value<double?>? sgst,
      Value<double?>? roundOff}) {
    return InvoicesCompanion(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerId: customerId ?? this.customerId,
      date: date ?? this.date,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      grandTotal: grandTotal ?? this.grandTotal,
      paidAmount: paidAmount ?? this.paidAmount,
      dueAmount: dueAmount ?? this.dueAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      cgst: cgst ?? this.cgst,
      sgst: sgst ?? this.sgst,
      roundOff: roundOff ?? this.roundOff,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (discountPercentage.present) {
      map['discount_percentage'] = Variable<double>(discountPercentage.value);
    }
    if (grandTotal.present) {
      map['grand_total'] = Variable<double>(grandTotal.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (dueAmount.present) {
      map['due_amount'] = Variable<double>(dueAmount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (cgst.present) {
      map['cgst'] = Variable<double>(cgst.value);
    }
    if (sgst.present) {
      map['sgst'] = Variable<double>(sgst.value);
    }
    if (roundOff.present) {
      map['round_off'] = Variable<double>(roundOff.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('customerId: $customerId, ')
          ..write('date: $date, ')
          ..write('subtotal: $subtotal, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('dueAmount: $dueAmount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes, ')
          ..write('cgst: $cgst, ')
          ..write('sgst: $sgst, ')
          ..write('roundOff: $roundOff')
          ..write(')'))
        .toString();
  }
}

class $InvoiceItemsTable extends InvoiceItems
    with TableInfo<$InvoiceItemsTable, InvoiceItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
      'invoice_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES invoices (id) ON DELETE CASCADE'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _taxPercentageMeta =
      const VerificationMeta('taxPercentage');
  @override
  late final GeneratedColumn<double> taxPercentage = GeneratedColumn<double>(
      'tax_percentage', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _discountAmountMeta =
      const VerificationMeta('discountAmount');
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
      'discount_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _hsnCodeMeta =
      const VerificationMeta('hsnCode');
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
      'hsn_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purityMeta = const VerificationMeta('purity');
  @override
  late final GeneratedColumn<String> purity = GeneratedColumn<String>(
      'purity', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _grossWeightMeta =
      const VerificationMeta('grossWeight');
  @override
  late final GeneratedColumn<double> grossWeight = GeneratedColumn<double>(
      'gross_weight', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _stoneWeightMeta =
      const VerificationMeta('stoneWeight');
  @override
  late final GeneratedColumn<double> stoneWeight = GeneratedColumn<double>(
      'stone_weight', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _makingChargesMeta =
      const VerificationMeta('makingCharges');
  @override
  late final GeneratedColumn<double> makingCharges = GeneratedColumn<double>(
      'making_charges', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _netWeightMeta =
      const VerificationMeta('netWeight');
  @override
  late final GeneratedColumn<double> netWeight = GeneratedColumn<double>(
      'net_weight', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
      'rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _taxableValueMeta =
      const VerificationMeta('taxableValue');
  @override
  late final GeneratedColumn<double> taxableValue = GeneratedColumn<double>(
      'taxable_value', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _batchNumberMeta =
      const VerificationMeta('batchNumber');
  @override
  late final GeneratedColumn<String> batchNumber = GeneratedColumn<String>(
      'batch_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
      'expiry_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _manufacturingDateMeta =
      const VerificationMeta('manufacturingDate');
  @override
  late final GeneratedColumn<DateTime> manufacturingDate =
      GeneratedColumn<DateTime>('manufacturing_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        invoiceId,
        productId,
        productName,
        quantity,
        unitPrice,
        taxPercentage,
        discountAmount,
        total,
        hsnCode,
        purity,
        grossWeight,
        stoneWeight,
        makingCharges,
        netWeight,
        rate,
        taxableValue,
        batchNumber,
        expiryDate,
        manufacturingDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_items';
  @override
  VerificationContext validateIntegrity(Insertable<InvoiceItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('tax_percentage')) {
      context.handle(
          _taxPercentageMeta,
          taxPercentage.isAcceptableOrUnknown(
              data['tax_percentage']!, _taxPercentageMeta));
    } else if (isInserting) {
      context.missing(_taxPercentageMeta);
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
          _discountAmountMeta,
          discountAmount.isAcceptableOrUnknown(
              data['discount_amount']!, _discountAmountMeta));
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('hsn_code')) {
      context.handle(_hsnCodeMeta,
          hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta));
    }
    if (data.containsKey('purity')) {
      context.handle(_purityMeta,
          purity.isAcceptableOrUnknown(data['purity']!, _purityMeta));
    }
    if (data.containsKey('gross_weight')) {
      context.handle(
          _grossWeightMeta,
          grossWeight.isAcceptableOrUnknown(
              data['gross_weight']!, _grossWeightMeta));
    }
    if (data.containsKey('stone_weight')) {
      context.handle(
          _stoneWeightMeta,
          stoneWeight.isAcceptableOrUnknown(
              data['stone_weight']!, _stoneWeightMeta));
    }
    if (data.containsKey('making_charges')) {
      context.handle(
          _makingChargesMeta,
          makingCharges.isAcceptableOrUnknown(
              data['making_charges']!, _makingChargesMeta));
    }
    if (data.containsKey('net_weight')) {
      context.handle(_netWeightMeta,
          netWeight.isAcceptableOrUnknown(data['net_weight']!, _netWeightMeta));
    }
    if (data.containsKey('rate')) {
      context.handle(
          _rateMeta, rate.isAcceptableOrUnknown(data['rate']!, _rateMeta));
    }
    if (data.containsKey('taxable_value')) {
      context.handle(
          _taxableValueMeta,
          taxableValue.isAcceptableOrUnknown(
              data['taxable_value']!, _taxableValueMeta));
    }
    if (data.containsKey('batch_number')) {
      context.handle(
          _batchNumberMeta,
          batchNumber.isAcceptableOrUnknown(
              data['batch_number']!, _batchNumberMeta));
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    }
    if (data.containsKey('manufacturing_date')) {
      context.handle(
          _manufacturingDateMeta,
          manufacturingDate.isAcceptableOrUnknown(
              data['manufacturing_date']!, _manufacturingDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}invoice_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      taxPercentage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_percentage'])!,
      discountAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_amount'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      hsnCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hsn_code']),
      purity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purity']),
      grossWeight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gross_weight']),
      stoneWeight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stone_weight']),
      makingCharges: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}making_charges']),
      netWeight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}net_weight']),
      rate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rate']),
      taxableValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}taxable_value']),
      batchNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_number']),
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiry_date']),
      manufacturingDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}manufacturing_date']),
    );
  }

  @override
  $InvoiceItemsTable createAlias(String alias) {
    return $InvoiceItemsTable(attachedDatabase, alias);
  }
}

class InvoiceItem extends DataClass implements Insertable<InvoiceItem> {
  final int id;
  final int invoiceId;
  final int productId;
  final String productName;
  final double quantity;
  final double unitPrice;
  final double taxPercentage;
  final double discountAmount;
  final double total;
  final String? hsnCode;
  final String? purity;
  final double? grossWeight;
  final double? stoneWeight;
  final double? makingCharges;
  final double? netWeight;
  final double? rate;
  final double? taxableValue;
  final String? batchNumber;
  final DateTime? expiryDate;
  final DateTime? manufacturingDate;
  const InvoiceItem(
      {required this.id,
      required this.invoiceId,
      required this.productId,
      required this.productName,
      required this.quantity,
      required this.unitPrice,
      required this.taxPercentage,
      required this.discountAmount,
      required this.total,
      this.hsnCode,
      this.purity,
      this.grossWeight,
      this.stoneWeight,
      this.makingCharges,
      this.netWeight,
      this.rate,
      this.taxableValue,
      this.batchNumber,
      this.expiryDate,
      this.manufacturingDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<int>(invoiceId);
    map['product_id'] = Variable<int>(productId);
    map['product_name'] = Variable<String>(productName);
    map['quantity'] = Variable<double>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    map['tax_percentage'] = Variable<double>(taxPercentage);
    map['discount_amount'] = Variable<double>(discountAmount);
    map['total'] = Variable<double>(total);
    if (!nullToAbsent || hsnCode != null) {
      map['hsn_code'] = Variable<String>(hsnCode);
    }
    if (!nullToAbsent || purity != null) {
      map['purity'] = Variable<String>(purity);
    }
    if (!nullToAbsent || grossWeight != null) {
      map['gross_weight'] = Variable<double>(grossWeight);
    }
    if (!nullToAbsent || stoneWeight != null) {
      map['stone_weight'] = Variable<double>(stoneWeight);
    }
    if (!nullToAbsent || makingCharges != null) {
      map['making_charges'] = Variable<double>(makingCharges);
    }
    if (!nullToAbsent || netWeight != null) {
      map['net_weight'] = Variable<double>(netWeight);
    }
    if (!nullToAbsent || rate != null) {
      map['rate'] = Variable<double>(rate);
    }
    if (!nullToAbsent || taxableValue != null) {
      map['taxable_value'] = Variable<double>(taxableValue);
    }
    if (!nullToAbsent || batchNumber != null) {
      map['batch_number'] = Variable<String>(batchNumber);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    if (!nullToAbsent || manufacturingDate != null) {
      map['manufacturing_date'] = Variable<DateTime>(manufacturingDate);
    }
    return map;
  }

  InvoiceItemsCompanion toCompanion(bool nullToAbsent) {
    return InvoiceItemsCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      productId: Value(productId),
      productName: Value(productName),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      taxPercentage: Value(taxPercentage),
      discountAmount: Value(discountAmount),
      total: Value(total),
      hsnCode: hsnCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnCode),
      purity:
          purity == null && nullToAbsent ? const Value.absent() : Value(purity),
      grossWeight: grossWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(grossWeight),
      stoneWeight: stoneWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(stoneWeight),
      makingCharges: makingCharges == null && nullToAbsent
          ? const Value.absent()
          : Value(makingCharges),
      netWeight: netWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(netWeight),
      rate: rate == null && nullToAbsent ? const Value.absent() : Value(rate),
      taxableValue: taxableValue == null && nullToAbsent
          ? const Value.absent()
          : Value(taxableValue),
      batchNumber: batchNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(batchNumber),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      manufacturingDate: manufacturingDate == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturingDate),
    );
  }

  factory InvoiceItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceItem(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      productId: serializer.fromJson<int>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      taxPercentage: serializer.fromJson<double>(json['taxPercentage']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      total: serializer.fromJson<double>(json['total']),
      hsnCode: serializer.fromJson<String?>(json['hsnCode']),
      purity: serializer.fromJson<String?>(json['purity']),
      grossWeight: serializer.fromJson<double?>(json['grossWeight']),
      stoneWeight: serializer.fromJson<double?>(json['stoneWeight']),
      makingCharges: serializer.fromJson<double?>(json['makingCharges']),
      netWeight: serializer.fromJson<double?>(json['netWeight']),
      rate: serializer.fromJson<double?>(json['rate']),
      taxableValue: serializer.fromJson<double?>(json['taxableValue']),
      batchNumber: serializer.fromJson<String?>(json['batchNumber']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      manufacturingDate:
          serializer.fromJson<DateTime?>(json['manufacturingDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'productId': serializer.toJson<int>(productId),
      'productName': serializer.toJson<String>(productName),
      'quantity': serializer.toJson<double>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'taxPercentage': serializer.toJson<double>(taxPercentage),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'total': serializer.toJson<double>(total),
      'hsnCode': serializer.toJson<String?>(hsnCode),
      'purity': serializer.toJson<String?>(purity),
      'grossWeight': serializer.toJson<double?>(grossWeight),
      'stoneWeight': serializer.toJson<double?>(stoneWeight),
      'makingCharges': serializer.toJson<double?>(makingCharges),
      'netWeight': serializer.toJson<double?>(netWeight),
      'rate': serializer.toJson<double?>(rate),
      'taxableValue': serializer.toJson<double?>(taxableValue),
      'batchNumber': serializer.toJson<String?>(batchNumber),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'manufacturingDate': serializer.toJson<DateTime?>(manufacturingDate),
    };
  }

  InvoiceItem copyWith(
          {int? id,
          int? invoiceId,
          int? productId,
          String? productName,
          double? quantity,
          double? unitPrice,
          double? taxPercentage,
          double? discountAmount,
          double? total,
          Value<String?> hsnCode = const Value.absent(),
          Value<String?> purity = const Value.absent(),
          Value<double?> grossWeight = const Value.absent(),
          Value<double?> stoneWeight = const Value.absent(),
          Value<double?> makingCharges = const Value.absent(),
          Value<double?> netWeight = const Value.absent(),
          Value<double?> rate = const Value.absent(),
          Value<double?> taxableValue = const Value.absent(),
          Value<String?> batchNumber = const Value.absent(),
          Value<DateTime?> expiryDate = const Value.absent(),
          Value<DateTime?> manufacturingDate = const Value.absent()}) =>
      InvoiceItem(
        id: id ?? this.id,
        invoiceId: invoiceId ?? this.invoiceId,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
        taxPercentage: taxPercentage ?? this.taxPercentage,
        discountAmount: discountAmount ?? this.discountAmount,
        total: total ?? this.total,
        hsnCode: hsnCode.present ? hsnCode.value : this.hsnCode,
        purity: purity.present ? purity.value : this.purity,
        grossWeight: grossWeight.present ? grossWeight.value : this.grossWeight,
        stoneWeight: stoneWeight.present ? stoneWeight.value : this.stoneWeight,
        makingCharges:
            makingCharges.present ? makingCharges.value : this.makingCharges,
        netWeight: netWeight.present ? netWeight.value : this.netWeight,
        rate: rate.present ? rate.value : this.rate,
        taxableValue:
            taxableValue.present ? taxableValue.value : this.taxableValue,
        batchNumber: batchNumber.present ? batchNumber.value : this.batchNumber,
        expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
        manufacturingDate: manufacturingDate.present
            ? manufacturingDate.value
            : this.manufacturingDate,
      );
  InvoiceItem copyWithCompanion(InvoiceItemsCompanion data) {
    return InvoiceItem(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      taxPercentage: data.taxPercentage.present
          ? data.taxPercentage.value
          : this.taxPercentage,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      total: data.total.present ? data.total.value : this.total,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      purity: data.purity.present ? data.purity.value : this.purity,
      grossWeight:
          data.grossWeight.present ? data.grossWeight.value : this.grossWeight,
      stoneWeight:
          data.stoneWeight.present ? data.stoneWeight.value : this.stoneWeight,
      makingCharges: data.makingCharges.present
          ? data.makingCharges.value
          : this.makingCharges,
      netWeight: data.netWeight.present ? data.netWeight.value : this.netWeight,
      rate: data.rate.present ? data.rate.value : this.rate,
      taxableValue: data.taxableValue.present
          ? data.taxableValue.value
          : this.taxableValue,
      batchNumber:
          data.batchNumber.present ? data.batchNumber.value : this.batchNumber,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      manufacturingDate: data.manufacturingDate.present
          ? data.manufacturingDate.value
          : this.manufacturingDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItem(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('taxPercentage: $taxPercentage, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('total: $total, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('purity: $purity, ')
          ..write('grossWeight: $grossWeight, ')
          ..write('stoneWeight: $stoneWeight, ')
          ..write('makingCharges: $makingCharges, ')
          ..write('netWeight: $netWeight, ')
          ..write('rate: $rate, ')
          ..write('taxableValue: $taxableValue, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('manufacturingDate: $manufacturingDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      invoiceId,
      productId,
      productName,
      quantity,
      unitPrice,
      taxPercentage,
      discountAmount,
      total,
      hsnCode,
      purity,
      grossWeight,
      stoneWeight,
      makingCharges,
      netWeight,
      rate,
      taxableValue,
      batchNumber,
      expiryDate,
      manufacturingDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceItem &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.taxPercentage == this.taxPercentage &&
          other.discountAmount == this.discountAmount &&
          other.total == this.total &&
          other.hsnCode == this.hsnCode &&
          other.purity == this.purity &&
          other.grossWeight == this.grossWeight &&
          other.stoneWeight == this.stoneWeight &&
          other.makingCharges == this.makingCharges &&
          other.netWeight == this.netWeight &&
          other.rate == this.rate &&
          other.taxableValue == this.taxableValue &&
          other.batchNumber == this.batchNumber &&
          other.expiryDate == this.expiryDate &&
          other.manufacturingDate == this.manufacturingDate);
}

class InvoiceItemsCompanion extends UpdateCompanion<InvoiceItem> {
  final Value<int> id;
  final Value<int> invoiceId;
  final Value<int> productId;
  final Value<String> productName;
  final Value<double> quantity;
  final Value<double> unitPrice;
  final Value<double> taxPercentage;
  final Value<double> discountAmount;
  final Value<double> total;
  final Value<String?> hsnCode;
  final Value<String?> purity;
  final Value<double?> grossWeight;
  final Value<double?> stoneWeight;
  final Value<double?> makingCharges;
  final Value<double?> netWeight;
  final Value<double?> rate;
  final Value<double?> taxableValue;
  final Value<String?> batchNumber;
  final Value<DateTime?> expiryDate;
  final Value<DateTime?> manufacturingDate;
  const InvoiceItemsCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.taxPercentage = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.total = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.purity = const Value.absent(),
    this.grossWeight = const Value.absent(),
    this.stoneWeight = const Value.absent(),
    this.makingCharges = const Value.absent(),
    this.netWeight = const Value.absent(),
    this.rate = const Value.absent(),
    this.taxableValue = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.manufacturingDate = const Value.absent(),
  });
  InvoiceItemsCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceId,
    required int productId,
    required String productName,
    required double quantity,
    required double unitPrice,
    required double taxPercentage,
    this.discountAmount = const Value.absent(),
    required double total,
    this.hsnCode = const Value.absent(),
    this.purity = const Value.absent(),
    this.grossWeight = const Value.absent(),
    this.stoneWeight = const Value.absent(),
    this.makingCharges = const Value.absent(),
    this.netWeight = const Value.absent(),
    this.rate = const Value.absent(),
    this.taxableValue = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.manufacturingDate = const Value.absent(),
  })  : invoiceId = Value(invoiceId),
        productId = Value(productId),
        productName = Value(productName),
        quantity = Value(quantity),
        unitPrice = Value(unitPrice),
        taxPercentage = Value(taxPercentage),
        total = Value(total);
  static Insertable<InvoiceItem> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<int>? productId,
    Expression<String>? productName,
    Expression<double>? quantity,
    Expression<double>? unitPrice,
    Expression<double>? taxPercentage,
    Expression<double>? discountAmount,
    Expression<double>? total,
    Expression<String>? hsnCode,
    Expression<String>? purity,
    Expression<double>? grossWeight,
    Expression<double>? stoneWeight,
    Expression<double>? makingCharges,
    Expression<double>? netWeight,
    Expression<double>? rate,
    Expression<double>? taxableValue,
    Expression<String>? batchNumber,
    Expression<DateTime>? expiryDate,
    Expression<DateTime>? manufacturingDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (taxPercentage != null) 'tax_percentage': taxPercentage,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (total != null) 'total': total,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (purity != null) 'purity': purity,
      if (grossWeight != null) 'gross_weight': grossWeight,
      if (stoneWeight != null) 'stone_weight': stoneWeight,
      if (makingCharges != null) 'making_charges': makingCharges,
      if (netWeight != null) 'net_weight': netWeight,
      if (rate != null) 'rate': rate,
      if (taxableValue != null) 'taxable_value': taxableValue,
      if (batchNumber != null) 'batch_number': batchNumber,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (manufacturingDate != null) 'manufacturing_date': manufacturingDate,
    });
  }

  InvoiceItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? invoiceId,
      Value<int>? productId,
      Value<String>? productName,
      Value<double>? quantity,
      Value<double>? unitPrice,
      Value<double>? taxPercentage,
      Value<double>? discountAmount,
      Value<double>? total,
      Value<String?>? hsnCode,
      Value<String?>? purity,
      Value<double?>? grossWeight,
      Value<double?>? stoneWeight,
      Value<double?>? makingCharges,
      Value<double?>? netWeight,
      Value<double?>? rate,
      Value<double?>? taxableValue,
      Value<String?>? batchNumber,
      Value<DateTime?>? expiryDate,
      Value<DateTime?>? manufacturingDate}) {
    return InvoiceItemsCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      discountAmount: discountAmount ?? this.discountAmount,
      total: total ?? this.total,
      hsnCode: hsnCode ?? this.hsnCode,
      purity: purity ?? this.purity,
      grossWeight: grossWeight ?? this.grossWeight,
      stoneWeight: stoneWeight ?? this.stoneWeight,
      makingCharges: makingCharges ?? this.makingCharges,
      netWeight: netWeight ?? this.netWeight,
      rate: rate ?? this.rate,
      taxableValue: taxableValue ?? this.taxableValue,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      manufacturingDate: manufacturingDate ?? this.manufacturingDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (taxPercentage.present) {
      map['tax_percentage'] = Variable<double>(taxPercentage.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (purity.present) {
      map['purity'] = Variable<String>(purity.value);
    }
    if (grossWeight.present) {
      map['gross_weight'] = Variable<double>(grossWeight.value);
    }
    if (stoneWeight.present) {
      map['stone_weight'] = Variable<double>(stoneWeight.value);
    }
    if (makingCharges.present) {
      map['making_charges'] = Variable<double>(makingCharges.value);
    }
    if (netWeight.present) {
      map['net_weight'] = Variable<double>(netWeight.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (taxableValue.present) {
      map['taxable_value'] = Variable<double>(taxableValue.value);
    }
    if (batchNumber.present) {
      map['batch_number'] = Variable<String>(batchNumber.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (manufacturingDate.present) {
      map['manufacturing_date'] = Variable<DateTime>(manufacturingDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItemsCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('taxPercentage: $taxPercentage, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('total: $total, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('purity: $purity, ')
          ..write('grossWeight: $grossWeight, ')
          ..write('stoneWeight: $stoneWeight, ')
          ..write('makingCharges: $makingCharges, ')
          ..write('netWeight: $netWeight, ')
          ..write('rate: $rate, ')
          ..write('taxableValue: $taxableValue, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('manufacturingDate: $manufacturingDate')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTable extends Purchases
    with TableInfo<$PurchasesTable, Purchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _purchaseNumberMeta =
      const VerificationMeta('purchaseNumber');
  @override
  late final GeneratedColumn<String> purchaseNumber = GeneratedColumn<String>(
      'purchase_number', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _supplierNameMeta =
      const VerificationMeta('supplierName');
  @override
  late final GeneratedColumn<String> supplierName = GeneratedColumn<String>(
      'supplier_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, purchaseNumber, supplierName, date, totalAmount, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchases';
  @override
  VerificationContext validateIntegrity(Insertable<Purchase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_number')) {
      context.handle(
          _purchaseNumberMeta,
          purchaseNumber.isAcceptableOrUnknown(
              data['purchase_number']!, _purchaseNumberMeta));
    } else if (isInserting) {
      context.missing(_purchaseNumberMeta);
    }
    if (data.containsKey('supplier_name')) {
      context.handle(
          _supplierNameMeta,
          supplierName.isAcceptableOrUnknown(
              data['supplier_name']!, _supplierNameMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Purchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Purchase(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      purchaseNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}purchase_number'])!,
      supplierName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_name']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $PurchasesTable createAlias(String alias) {
    return $PurchasesTable(attachedDatabase, alias);
  }
}

class Purchase extends DataClass implements Insertable<Purchase> {
  final int id;
  final String purchaseNumber;
  final String? supplierName;
  final DateTime date;
  final double totalAmount;
  final String? notes;
  const Purchase(
      {required this.id,
      required this.purchaseNumber,
      this.supplierName,
      required this.date,
      required this.totalAmount,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_number'] = Variable<String>(purchaseNumber);
    if (!nullToAbsent || supplierName != null) {
      map['supplier_name'] = Variable<String>(supplierName);
    }
    map['date'] = Variable<DateTime>(date);
    map['total_amount'] = Variable<double>(totalAmount);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PurchasesCompanion toCompanion(bool nullToAbsent) {
    return PurchasesCompanion(
      id: Value(id),
      purchaseNumber: Value(purchaseNumber),
      supplierName: supplierName == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierName),
      date: Value(date),
      totalAmount: Value(totalAmount),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory Purchase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Purchase(
      id: serializer.fromJson<int>(json['id']),
      purchaseNumber: serializer.fromJson<String>(json['purchaseNumber']),
      supplierName: serializer.fromJson<String?>(json['supplierName']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseNumber': serializer.toJson<String>(purchaseNumber),
      'supplierName': serializer.toJson<String?>(supplierName),
      'date': serializer.toJson<DateTime>(date),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Purchase copyWith(
          {int? id,
          String? purchaseNumber,
          Value<String?> supplierName = const Value.absent(),
          DateTime? date,
          double? totalAmount,
          Value<String?> notes = const Value.absent()}) =>
      Purchase(
        id: id ?? this.id,
        purchaseNumber: purchaseNumber ?? this.purchaseNumber,
        supplierName:
            supplierName.present ? supplierName.value : this.supplierName,
        date: date ?? this.date,
        totalAmount: totalAmount ?? this.totalAmount,
        notes: notes.present ? notes.value : this.notes,
      );
  Purchase copyWithCompanion(PurchasesCompanion data) {
    return Purchase(
      id: data.id.present ? data.id.value : this.id,
      purchaseNumber: data.purchaseNumber.present
          ? data.purchaseNumber.value
          : this.purchaseNumber,
      supplierName: data.supplierName.present
          ? data.supplierName.value
          : this.supplierName,
      date: data.date.present ? data.date.value : this.date,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Purchase(')
          ..write('id: $id, ')
          ..write('purchaseNumber: $purchaseNumber, ')
          ..write('supplierName: $supplierName, ')
          ..write('date: $date, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, purchaseNumber, supplierName, date, totalAmount, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Purchase &&
          other.id == this.id &&
          other.purchaseNumber == this.purchaseNumber &&
          other.supplierName == this.supplierName &&
          other.date == this.date &&
          other.totalAmount == this.totalAmount &&
          other.notes == this.notes);
}

class PurchasesCompanion extends UpdateCompanion<Purchase> {
  final Value<int> id;
  final Value<String> purchaseNumber;
  final Value<String?> supplierName;
  final Value<DateTime> date;
  final Value<double> totalAmount;
  final Value<String?> notes;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.purchaseNumber = const Value.absent(),
    this.supplierName = const Value.absent(),
    this.date = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.notes = const Value.absent(),
  });
  PurchasesCompanion.insert({
    this.id = const Value.absent(),
    required String purchaseNumber,
    this.supplierName = const Value.absent(),
    this.date = const Value.absent(),
    required double totalAmount,
    this.notes = const Value.absent(),
  })  : purchaseNumber = Value(purchaseNumber),
        totalAmount = Value(totalAmount);
  static Insertable<Purchase> custom({
    Expression<int>? id,
    Expression<String>? purchaseNumber,
    Expression<String>? supplierName,
    Expression<DateTime>? date,
    Expression<double>? totalAmount,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseNumber != null) 'purchase_number': purchaseNumber,
      if (supplierName != null) 'supplier_name': supplierName,
      if (date != null) 'date': date,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (notes != null) 'notes': notes,
    });
  }

  PurchasesCompanion copyWith(
      {Value<int>? id,
      Value<String>? purchaseNumber,
      Value<String?>? supplierName,
      Value<DateTime>? date,
      Value<double>? totalAmount,
      Value<String?>? notes}) {
    return PurchasesCompanion(
      id: id ?? this.id,
      purchaseNumber: purchaseNumber ?? this.purchaseNumber,
      supplierName: supplierName ?? this.supplierName,
      date: date ?? this.date,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseNumber.present) {
      map['purchase_number'] = Variable<String>(purchaseNumber.value);
    }
    if (supplierName.present) {
      map['supplier_name'] = Variable<String>(supplierName.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesCompanion(')
          ..write('id: $id, ')
          ..write('purchaseNumber: $purchaseNumber, ')
          ..write('supplierName: $supplierName, ')
          ..write('date: $date, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $PurchaseItemsTable extends PurchaseItems
    with TableInfo<$PurchaseItemsTable, PurchaseItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _purchaseIdMeta =
      const VerificationMeta('purchaseId');
  @override
  late final GeneratedColumn<int> purchaseId = GeneratedColumn<int>(
      'purchase_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES purchases (id) ON DELETE CASCADE'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _purchasePriceMeta =
      const VerificationMeta('purchasePrice');
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
      'purchase_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, purchaseId, productId, productName, quantity, purchasePrice, total];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_items';
  @override
  VerificationContext validateIntegrity(Insertable<PurchaseItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
          _purchaseIdMeta,
          purchaseId.isAcceptableOrUnknown(
              data['purchase_id']!, _purchaseIdMeta));
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
          _purchasePriceMeta,
          purchasePrice.isAcceptableOrUnknown(
              data['purchase_price']!, _purchasePriceMeta));
    } else if (isInserting) {
      context.missing(_purchasePriceMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      purchaseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}purchase_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      purchasePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}purchase_price'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
    );
  }

  @override
  $PurchaseItemsTable createAlias(String alias) {
    return $PurchaseItemsTable(attachedDatabase, alias);
  }
}

class PurchaseItem extends DataClass implements Insertable<PurchaseItem> {
  final int id;
  final int purchaseId;
  final int productId;
  final String productName;
  final double quantity;
  final double purchasePrice;
  final double total;
  const PurchaseItem(
      {required this.id,
      required this.purchaseId,
      required this.productId,
      required this.productName,
      required this.quantity,
      required this.purchasePrice,
      required this.total});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_id'] = Variable<int>(purchaseId);
    map['product_id'] = Variable<int>(productId);
    map['product_name'] = Variable<String>(productName);
    map['quantity'] = Variable<double>(quantity);
    map['purchase_price'] = Variable<double>(purchasePrice);
    map['total'] = Variable<double>(total);
    return map;
  }

  PurchaseItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseItemsCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      productId: Value(productId),
      productName: Value(productName),
      quantity: Value(quantity),
      purchasePrice: Value(purchasePrice),
      total: Value(total),
    );
  }

  factory PurchaseItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseItem(
      id: serializer.fromJson<int>(json['id']),
      purchaseId: serializer.fromJson<int>(json['purchaseId']),
      productId: serializer.fromJson<int>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      purchasePrice: serializer.fromJson<double>(json['purchasePrice']),
      total: serializer.fromJson<double>(json['total']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseId': serializer.toJson<int>(purchaseId),
      'productId': serializer.toJson<int>(productId),
      'productName': serializer.toJson<String>(productName),
      'quantity': serializer.toJson<double>(quantity),
      'purchasePrice': serializer.toJson<double>(purchasePrice),
      'total': serializer.toJson<double>(total),
    };
  }

  PurchaseItem copyWith(
          {int? id,
          int? purchaseId,
          int? productId,
          String? productName,
          double? quantity,
          double? purchasePrice,
          double? total}) =>
      PurchaseItem(
        id: id ?? this.id,
        purchaseId: purchaseId ?? this.purchaseId,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        quantity: quantity ?? this.quantity,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        total: total ?? this.total,
      );
  PurchaseItem copyWithCompanion(PurchaseItemsCompanion data) {
    return PurchaseItem(
      id: data.id.present ? data.id.value : this.id,
      purchaseId:
          data.purchaseId.present ? data.purchaseId.value : this.purchaseId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      total: data.total.present ? data.total.value : this.total,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItem(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, purchaseId, productId, productName, quantity, purchasePrice, total);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseItem &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.quantity == this.quantity &&
          other.purchasePrice == this.purchasePrice &&
          other.total == this.total);
}

class PurchaseItemsCompanion extends UpdateCompanion<PurchaseItem> {
  final Value<int> id;
  final Value<int> purchaseId;
  final Value<int> productId;
  final Value<String> productName;
  final Value<double> quantity;
  final Value<double> purchasePrice;
  final Value<double> total;
  const PurchaseItemsCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.total = const Value.absent(),
  });
  PurchaseItemsCompanion.insert({
    this.id = const Value.absent(),
    required int purchaseId,
    required int productId,
    required String productName,
    required double quantity,
    required double purchasePrice,
    required double total,
  })  : purchaseId = Value(purchaseId),
        productId = Value(productId),
        productName = Value(productName),
        quantity = Value(quantity),
        purchasePrice = Value(purchasePrice),
        total = Value(total);
  static Insertable<PurchaseItem> custom({
    Expression<int>? id,
    Expression<int>? purchaseId,
    Expression<int>? productId,
    Expression<String>? productName,
    Expression<double>? quantity,
    Expression<double>? purchasePrice,
    Expression<double>? total,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (quantity != null) 'quantity': quantity,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (total != null) 'total': total,
    });
  }

  PurchaseItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? purchaseId,
      Value<int>? productId,
      Value<String>? productName,
      Value<double>? quantity,
      Value<double>? purchasePrice,
      Value<double>? total}) {
    return PurchaseItemsCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      total: total ?? this.total,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<int>(purchaseId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItemsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTable extends StockMovements
    with TableInfo<$StockMovementsTable, StockMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES products (id) ON DELETE CASCADE'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _referenceIdMeta =
      const VerificationMeta('referenceId');
  @override
  late final GeneratedColumn<int> referenceId = GeneratedColumn<int>(
      'reference_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, productId, quantity, type, reason, date, referenceId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements';
  @override
  VerificationContext validateIntegrity(Insertable<StockMovement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('reference_id')) {
      context.handle(
          _referenceIdMeta,
          referenceId.isAcceptableOrUnknown(
              data['reference_id']!, _referenceIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMovement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      referenceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reference_id']),
    );
  }

  @override
  $StockMovementsTable createAlias(String alias) {
    return $StockMovementsTable(attachedDatabase, alias);
  }
}

class StockMovement extends DataClass implements Insertable<StockMovement> {
  final int id;
  final int productId;
  final double quantity;
  final String type;
  final String? reason;
  final DateTime date;
  final int? referenceId;
  const StockMovement(
      {required this.id,
      required this.productId,
      required this.quantity,
      required this.type,
      this.reason,
      required this.date,
      this.referenceId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['quantity'] = Variable<double>(quantity);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<int>(referenceId);
    }
    return map;
  }

  StockMovementsCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsCompanion(
      id: Value(id),
      productId: Value(productId),
      quantity: Value(quantity),
      type: Value(type),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      date: Value(date),
      referenceId: referenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceId),
    );
  }

  factory StockMovement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMovement(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      type: serializer.fromJson<String>(json['type']),
      reason: serializer.fromJson<String?>(json['reason']),
      date: serializer.fromJson<DateTime>(json['date']),
      referenceId: serializer.fromJson<int?>(json['referenceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'quantity': serializer.toJson<double>(quantity),
      'type': serializer.toJson<String>(type),
      'reason': serializer.toJson<String?>(reason),
      'date': serializer.toJson<DateTime>(date),
      'referenceId': serializer.toJson<int?>(referenceId),
    };
  }

  StockMovement copyWith(
          {int? id,
          int? productId,
          double? quantity,
          String? type,
          Value<String?> reason = const Value.absent(),
          DateTime? date,
          Value<int?> referenceId = const Value.absent()}) =>
      StockMovement(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        type: type ?? this.type,
        reason: reason.present ? reason.value : this.reason,
        date: date ?? this.date,
        referenceId: referenceId.present ? referenceId.value : this.referenceId,
      );
  StockMovement copyWithCompanion(StockMovementsCompanion data) {
    return StockMovement(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      type: data.type.present ? data.type.value : this.type,
      reason: data.reason.present ? data.reason.value : this.reason,
      date: data.date.present ? data.date.value : this.date,
      referenceId:
          data.referenceId.present ? data.referenceId.value : this.referenceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockMovement(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('type: $type, ')
          ..write('reason: $reason, ')
          ..write('date: $date, ')
          ..write('referenceId: $referenceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, quantity, type, reason, date, referenceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMovement &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.type == this.type &&
          other.reason == this.reason &&
          other.date == this.date &&
          other.referenceId == this.referenceId);
}

class StockMovementsCompanion extends UpdateCompanion<StockMovement> {
  final Value<int> id;
  final Value<int> productId;
  final Value<double> quantity;
  final Value<String> type;
  final Value<String?> reason;
  final Value<DateTime> date;
  final Value<int?> referenceId;
  const StockMovementsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.type = const Value.absent(),
    this.reason = const Value.absent(),
    this.date = const Value.absent(),
    this.referenceId = const Value.absent(),
  });
  StockMovementsCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required double quantity,
    required String type,
    this.reason = const Value.absent(),
    this.date = const Value.absent(),
    this.referenceId = const Value.absent(),
  })  : productId = Value(productId),
        quantity = Value(quantity),
        type = Value(type);
  static Insertable<StockMovement> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<double>? quantity,
    Expression<String>? type,
    Expression<String>? reason,
    Expression<DateTime>? date,
    Expression<int>? referenceId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (type != null) 'type': type,
      if (reason != null) 'reason': reason,
      if (date != null) 'date': date,
      if (referenceId != null) 'reference_id': referenceId,
    });
  }

  StockMovementsCompanion copyWith(
      {Value<int>? id,
      Value<int>? productId,
      Value<double>? quantity,
      Value<String>? type,
      Value<String?>? reason,
      Value<DateTime>? date,
      Value<int?>? referenceId}) {
    return StockMovementsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      reason: reason ?? this.reason,
      date: date ?? this.date,
      referenceId: referenceId ?? this.referenceId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<int>(referenceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('type: $type, ')
          ..write('reason: $reason, ')
          ..write('date: $date, ')
          ..write('referenceId: $referenceId')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
      'invoice_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES invoices (id)'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, invoiceId, customerId, amount, method, date, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<Payment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}invoice_id']),
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;
  final int? invoiceId;
  final int customerId;
  final double amount;
  final String method;
  final DateTime date;
  final String? notes;
  const Payment(
      {required this.id,
      this.invoiceId,
      required this.customerId,
      required this.amount,
      required this.method,
      required this.date,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || invoiceId != null) {
      map['invoice_id'] = Variable<int>(invoiceId);
    }
    map['customer_id'] = Variable<int>(customerId);
    map['amount'] = Variable<double>(amount);
    map['method'] = Variable<String>(method);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      invoiceId: invoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceId),
      customerId: Value(customerId),
      amount: Value(amount),
      method: Value(method),
      date: Value(date),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory Payment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int?>(json['invoiceId']),
      customerId: serializer.fromJson<int>(json['customerId']),
      amount: serializer.fromJson<double>(json['amount']),
      method: serializer.fromJson<String>(json['method']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int?>(invoiceId),
      'customerId': serializer.toJson<int>(customerId),
      'amount': serializer.toJson<double>(amount),
      'method': serializer.toJson<String>(method),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Payment copyWith(
          {int? id,
          Value<int?> invoiceId = const Value.absent(),
          int? customerId,
          double? amount,
          String? method,
          DateTime? date,
          Value<String?> notes = const Value.absent()}) =>
      Payment(
        id: id ?? this.id,
        invoiceId: invoiceId.present ? invoiceId.value : this.invoiceId,
        customerId: customerId ?? this.customerId,
        amount: amount ?? this.amount,
        method: method ?? this.method,
        date: date ?? this.date,
        notes: notes.present ? notes.value : this.notes,
      );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      amount: data.amount.present ? data.amount.value : this.amount,
      method: data.method.present ? data.method.value : this.method,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('customerId: $customerId, ')
          ..write('amount: $amount, ')
          ..write('method: $method, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, invoiceId, customerId, amount, method, date, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.customerId == this.customerId &&
          other.amount == this.amount &&
          other.method == this.method &&
          other.date == this.date &&
          other.notes == this.notes);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<int?> invoiceId;
  final Value<int> customerId;
  final Value<double> amount;
  final Value<String> method;
  final Value<DateTime> date;
  final Value<String?> notes;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.amount = const Value.absent(),
    this.method = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    required int customerId,
    required double amount,
    required String method,
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
  })  : customerId = Value(customerId),
        amount = Value(amount),
        method = Value(method);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<int>? customerId,
    Expression<double>? amount,
    Expression<String>? method,
    Expression<DateTime>? date,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (customerId != null) 'customer_id': customerId,
      if (amount != null) 'amount': amount,
      if (method != null) 'method': method,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
    });
  }

  PaymentsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? invoiceId,
      Value<int>? customerId,
      Value<double>? amount,
      Value<String>? method,
      Value<DateTime>? date,
      Value<String?>? notes}) {
    return PaymentsCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      customerId: customerId ?? this.customerId,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('customerId: $customerId, ')
          ..write('amount: $amount, ')
          ..write('method: $method, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $BusinessProfileTable extends BusinessProfile
    with TableInfo<$BusinessProfileTable, BusinessProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('My Business'));
  static const VerificationMeta _ownerNameMeta =
      const VerificationMeta('ownerName');
  @override
  late final GeneratedColumn<String> ownerName = GeneratedColumn<String>(
      'owner_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _gstinMeta = const VerificationMeta('gstin');
  @override
  late final GeneratedColumn<String> gstin = GeneratedColumn<String>(
      'gstin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _upiIdMeta = const VerificationMeta('upiId');
  @override
  late final GeneratedColumn<String> upiId = GeneratedColumn<String>(
      'upi_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _logoPathMeta =
      const VerificationMeta('logoPath');
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
      'logo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _invoicePrefixMeta =
      const VerificationMeta('invoicePrefix');
  @override
  late final GeneratedColumn<String> invoicePrefix = GeneratedColumn<String>(
      'invoice_prefix', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('RB'));
  static const VerificationMeta _currencySymbolMeta =
      const VerificationMeta('currencySymbol');
  @override
  late final GeneratedColumn<String> currencySymbol = GeneratedColumn<String>(
      'currency_symbol', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Rs'));
  static const VerificationMeta _defaultTaxPercentageMeta =
      const VerificationMeta('defaultTaxPercentage');
  @override
  late final GeneratedColumn<double> defaultTaxPercentage =
      GeneratedColumn<double>('default_tax_percentage', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _shopCategoryMeta =
      const VerificationMeta('shopCategory');
  @override
  late final GeneratedColumn<String> shopCategory = GeneratedColumn<String>(
      'shop_category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('General'));
  static const VerificationMeta _bankNameMeta =
      const VerificationMeta('bankName');
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
      'bank_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _accountNumberMeta =
      const VerificationMeta('accountNumber');
  @override
  late final GeneratedColumn<String> accountNumber = GeneratedColumn<String>(
      'account_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ifscCodeMeta =
      const VerificationMeta('ifscCode');
  @override
  late final GeneratedColumn<String> ifscCode = GeneratedColumn<String>(
      'ifsc_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _termsAndConditionsMeta =
      const VerificationMeta('termsAndConditions');
  @override
  late final GeneratedColumn<String> termsAndConditions =
      GeneratedColumn<String>('terms_and_conditions', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        ownerName,
        phone,
        email,
        address,
        gstin,
        upiId,
        logoPath,
        invoicePrefix,
        currencySymbol,
        defaultTaxPercentage,
        shopCategory,
        bankName,
        accountNumber,
        ifscCode,
        termsAndConditions
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_profile';
  @override
  VerificationContext validateIntegrity(
      Insertable<BusinessProfileData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('owner_name')) {
      context.handle(_ownerNameMeta,
          ownerName.isAcceptableOrUnknown(data['owner_name']!, _ownerNameMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('gstin')) {
      context.handle(
          _gstinMeta, gstin.isAcceptableOrUnknown(data['gstin']!, _gstinMeta));
    }
    if (data.containsKey('upi_id')) {
      context.handle(
          _upiIdMeta, upiId.isAcceptableOrUnknown(data['upi_id']!, _upiIdMeta));
    }
    if (data.containsKey('logo_path')) {
      context.handle(_logoPathMeta,
          logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta));
    }
    if (data.containsKey('invoice_prefix')) {
      context.handle(
          _invoicePrefixMeta,
          invoicePrefix.isAcceptableOrUnknown(
              data['invoice_prefix']!, _invoicePrefixMeta));
    }
    if (data.containsKey('currency_symbol')) {
      context.handle(
          _currencySymbolMeta,
          currencySymbol.isAcceptableOrUnknown(
              data['currency_symbol']!, _currencySymbolMeta));
    }
    if (data.containsKey('default_tax_percentage')) {
      context.handle(
          _defaultTaxPercentageMeta,
          defaultTaxPercentage.isAcceptableOrUnknown(
              data['default_tax_percentage']!, _defaultTaxPercentageMeta));
    }
    if (data.containsKey('shop_category')) {
      context.handle(
          _shopCategoryMeta,
          shopCategory.isAcceptableOrUnknown(
              data['shop_category']!, _shopCategoryMeta));
    }
    if (data.containsKey('bank_name')) {
      context.handle(_bankNameMeta,
          bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta));
    }
    if (data.containsKey('account_number')) {
      context.handle(
          _accountNumberMeta,
          accountNumber.isAcceptableOrUnknown(
              data['account_number']!, _accountNumberMeta));
    }
    if (data.containsKey('ifsc_code')) {
      context.handle(_ifscCodeMeta,
          ifscCode.isAcceptableOrUnknown(data['ifsc_code']!, _ifscCodeMeta));
    }
    if (data.containsKey('terms_and_conditions')) {
      context.handle(
          _termsAndConditionsMeta,
          termsAndConditions.isAcceptableOrUnknown(
              data['terms_and_conditions']!, _termsAndConditionsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessProfileData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      ownerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_name']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      gstin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gstin']),
      upiId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}upi_id']),
      logoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_path']),
      invoicePrefix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_prefix'])!,
      currencySymbol: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}currency_symbol'])!,
      defaultTaxPercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}default_tax_percentage'])!,
      shopCategory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shop_category'])!,
      bankName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_name']),
      accountNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_number']),
      ifscCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ifsc_code']),
      termsAndConditions: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}terms_and_conditions']),
    );
  }

  @override
  $BusinessProfileTable createAlias(String alias) {
    return $BusinessProfileTable(attachedDatabase, alias);
  }
}

class BusinessProfileData extends DataClass
    implements Insertable<BusinessProfileData> {
  final int id;
  final String name;
  final String? ownerName;
  final String? phone;
  final String? email;
  final String? address;
  final String? gstin;
  final String? upiId;
  final String? logoPath;
  final String invoicePrefix;
  final String currencySymbol;
  final double defaultTaxPercentage;
  final String shopCategory;
  final String? bankName;
  final String? accountNumber;
  final String? ifscCode;
  final String? termsAndConditions;
  const BusinessProfileData(
      {required this.id,
      required this.name,
      this.ownerName,
      this.phone,
      this.email,
      this.address,
      this.gstin,
      this.upiId,
      this.logoPath,
      required this.invoicePrefix,
      required this.currencySymbol,
      required this.defaultTaxPercentage,
      required this.shopCategory,
      this.bankName,
      this.accountNumber,
      this.ifscCode,
      this.termsAndConditions});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || ownerName != null) {
      map['owner_name'] = Variable<String>(ownerName);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || gstin != null) {
      map['gstin'] = Variable<String>(gstin);
    }
    if (!nullToAbsent || upiId != null) {
      map['upi_id'] = Variable<String>(upiId);
    }
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    map['invoice_prefix'] = Variable<String>(invoicePrefix);
    map['currency_symbol'] = Variable<String>(currencySymbol);
    map['default_tax_percentage'] = Variable<double>(defaultTaxPercentage);
    map['shop_category'] = Variable<String>(shopCategory);
    if (!nullToAbsent || bankName != null) {
      map['bank_name'] = Variable<String>(bankName);
    }
    if (!nullToAbsent || accountNumber != null) {
      map['account_number'] = Variable<String>(accountNumber);
    }
    if (!nullToAbsent || ifscCode != null) {
      map['ifsc_code'] = Variable<String>(ifscCode);
    }
    if (!nullToAbsent || termsAndConditions != null) {
      map['terms_and_conditions'] = Variable<String>(termsAndConditions);
    }
    return map;
  }

  BusinessProfileCompanion toCompanion(bool nullToAbsent) {
    return BusinessProfileCompanion(
      id: Value(id),
      name: Value(name),
      ownerName: ownerName == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerName),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      gstin:
          gstin == null && nullToAbsent ? const Value.absent() : Value(gstin),
      upiId:
          upiId == null && nullToAbsent ? const Value.absent() : Value(upiId),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      invoicePrefix: Value(invoicePrefix),
      currencySymbol: Value(currencySymbol),
      defaultTaxPercentage: Value(defaultTaxPercentage),
      shopCategory: Value(shopCategory),
      bankName: bankName == null && nullToAbsent
          ? const Value.absent()
          : Value(bankName),
      accountNumber: accountNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(accountNumber),
      ifscCode: ifscCode == null && nullToAbsent
          ? const Value.absent()
          : Value(ifscCode),
      termsAndConditions: termsAndConditions == null && nullToAbsent
          ? const Value.absent()
          : Value(termsAndConditions),
    );
  }

  factory BusinessProfileData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessProfileData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      ownerName: serializer.fromJson<String?>(json['ownerName']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      gstin: serializer.fromJson<String?>(json['gstin']),
      upiId: serializer.fromJson<String?>(json['upiId']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      invoicePrefix: serializer.fromJson<String>(json['invoicePrefix']),
      currencySymbol: serializer.fromJson<String>(json['currencySymbol']),
      defaultTaxPercentage:
          serializer.fromJson<double>(json['defaultTaxPercentage']),
      shopCategory: serializer.fromJson<String>(json['shopCategory']),
      bankName: serializer.fromJson<String?>(json['bankName']),
      accountNumber: serializer.fromJson<String?>(json['accountNumber']),
      ifscCode: serializer.fromJson<String?>(json['ifscCode']),
      termsAndConditions:
          serializer.fromJson<String?>(json['termsAndConditions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'ownerName': serializer.toJson<String?>(ownerName),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'gstin': serializer.toJson<String?>(gstin),
      'upiId': serializer.toJson<String?>(upiId),
      'logoPath': serializer.toJson<String?>(logoPath),
      'invoicePrefix': serializer.toJson<String>(invoicePrefix),
      'currencySymbol': serializer.toJson<String>(currencySymbol),
      'defaultTaxPercentage': serializer.toJson<double>(defaultTaxPercentage),
      'shopCategory': serializer.toJson<String>(shopCategory),
      'bankName': serializer.toJson<String?>(bankName),
      'accountNumber': serializer.toJson<String?>(accountNumber),
      'ifscCode': serializer.toJson<String?>(ifscCode),
      'termsAndConditions': serializer.toJson<String?>(termsAndConditions),
    };
  }

  BusinessProfileData copyWith(
          {int? id,
          String? name,
          Value<String?> ownerName = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> gstin = const Value.absent(),
          Value<String?> upiId = const Value.absent(),
          Value<String?> logoPath = const Value.absent(),
          String? invoicePrefix,
          String? currencySymbol,
          double? defaultTaxPercentage,
          String? shopCategory,
          Value<String?> bankName = const Value.absent(),
          Value<String?> accountNumber = const Value.absent(),
          Value<String?> ifscCode = const Value.absent(),
          Value<String?> termsAndConditions = const Value.absent()}) =>
      BusinessProfileData(
        id: id ?? this.id,
        name: name ?? this.name,
        ownerName: ownerName.present ? ownerName.value : this.ownerName,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        gstin: gstin.present ? gstin.value : this.gstin,
        upiId: upiId.present ? upiId.value : this.upiId,
        logoPath: logoPath.present ? logoPath.value : this.logoPath,
        invoicePrefix: invoicePrefix ?? this.invoicePrefix,
        currencySymbol: currencySymbol ?? this.currencySymbol,
        defaultTaxPercentage: defaultTaxPercentage ?? this.defaultTaxPercentage,
        shopCategory: shopCategory ?? this.shopCategory,
        bankName: bankName.present ? bankName.value : this.bankName,
        accountNumber:
            accountNumber.present ? accountNumber.value : this.accountNumber,
        ifscCode: ifscCode.present ? ifscCode.value : this.ifscCode,
        termsAndConditions: termsAndConditions.present
            ? termsAndConditions.value
            : this.termsAndConditions,
      );
  BusinessProfileData copyWithCompanion(BusinessProfileCompanion data) {
    return BusinessProfileData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      ownerName: data.ownerName.present ? data.ownerName.value : this.ownerName,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      gstin: data.gstin.present ? data.gstin.value : this.gstin,
      upiId: data.upiId.present ? data.upiId.value : this.upiId,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      invoicePrefix: data.invoicePrefix.present
          ? data.invoicePrefix.value
          : this.invoicePrefix,
      currencySymbol: data.currencySymbol.present
          ? data.currencySymbol.value
          : this.currencySymbol,
      defaultTaxPercentage: data.defaultTaxPercentage.present
          ? data.defaultTaxPercentage.value
          : this.defaultTaxPercentage,
      shopCategory: data.shopCategory.present
          ? data.shopCategory.value
          : this.shopCategory,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      ifscCode: data.ifscCode.present ? data.ifscCode.value : this.ifscCode,
      termsAndConditions: data.termsAndConditions.present
          ? data.termsAndConditions.value
          : this.termsAndConditions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfileData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ownerName: $ownerName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('gstin: $gstin, ')
          ..write('upiId: $upiId, ')
          ..write('logoPath: $logoPath, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('defaultTaxPercentage: $defaultTaxPercentage, ')
          ..write('shopCategory: $shopCategory, ')
          ..write('bankName: $bankName, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('ifscCode: $ifscCode, ')
          ..write('termsAndConditions: $termsAndConditions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      ownerName,
      phone,
      email,
      address,
      gstin,
      upiId,
      logoPath,
      invoicePrefix,
      currencySymbol,
      defaultTaxPercentage,
      shopCategory,
      bankName,
      accountNumber,
      ifscCode,
      termsAndConditions);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessProfileData &&
          other.id == this.id &&
          other.name == this.name &&
          other.ownerName == this.ownerName &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.gstin == this.gstin &&
          other.upiId == this.upiId &&
          other.logoPath == this.logoPath &&
          other.invoicePrefix == this.invoicePrefix &&
          other.currencySymbol == this.currencySymbol &&
          other.defaultTaxPercentage == this.defaultTaxPercentage &&
          other.shopCategory == this.shopCategory &&
          other.bankName == this.bankName &&
          other.accountNumber == this.accountNumber &&
          other.ifscCode == this.ifscCode &&
          other.termsAndConditions == this.termsAndConditions);
}

class BusinessProfileCompanion extends UpdateCompanion<BusinessProfileData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> ownerName;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> gstin;
  final Value<String?> upiId;
  final Value<String?> logoPath;
  final Value<String> invoicePrefix;
  final Value<String> currencySymbol;
  final Value<double> defaultTaxPercentage;
  final Value<String> shopCategory;
  final Value<String?> bankName;
  final Value<String?> accountNumber;
  final Value<String?> ifscCode;
  final Value<String?> termsAndConditions;
  const BusinessProfileCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ownerName = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.gstin = const Value.absent(),
    this.upiId = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.defaultTaxPercentage = const Value.absent(),
    this.shopCategory = const Value.absent(),
    this.bankName = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.ifscCode = const Value.absent(),
    this.termsAndConditions = const Value.absent(),
  });
  BusinessProfileCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ownerName = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.gstin = const Value.absent(),
    this.upiId = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.defaultTaxPercentage = const Value.absent(),
    this.shopCategory = const Value.absent(),
    this.bankName = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.ifscCode = const Value.absent(),
    this.termsAndConditions = const Value.absent(),
  });
  static Insertable<BusinessProfileData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? ownerName,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? gstin,
    Expression<String>? upiId,
    Expression<String>? logoPath,
    Expression<String>? invoicePrefix,
    Expression<String>? currencySymbol,
    Expression<double>? defaultTaxPercentage,
    Expression<String>? shopCategory,
    Expression<String>? bankName,
    Expression<String>? accountNumber,
    Expression<String>? ifscCode,
    Expression<String>? termsAndConditions,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (ownerName != null) 'owner_name': ownerName,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (gstin != null) 'gstin': gstin,
      if (upiId != null) 'upi_id': upiId,
      if (logoPath != null) 'logo_path': logoPath,
      if (invoicePrefix != null) 'invoice_prefix': invoicePrefix,
      if (currencySymbol != null) 'currency_symbol': currencySymbol,
      if (defaultTaxPercentage != null)
        'default_tax_percentage': defaultTaxPercentage,
      if (shopCategory != null) 'shop_category': shopCategory,
      if (bankName != null) 'bank_name': bankName,
      if (accountNumber != null) 'account_number': accountNumber,
      if (ifscCode != null) 'ifsc_code': ifscCode,
      if (termsAndConditions != null)
        'terms_and_conditions': termsAndConditions,
    });
  }

  BusinessProfileCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? ownerName,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<String?>? gstin,
      Value<String?>? upiId,
      Value<String?>? logoPath,
      Value<String>? invoicePrefix,
      Value<String>? currencySymbol,
      Value<double>? defaultTaxPercentage,
      Value<String>? shopCategory,
      Value<String?>? bankName,
      Value<String?>? accountNumber,
      Value<String?>? ifscCode,
      Value<String?>? termsAndConditions}) {
    return BusinessProfileCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      gstin: gstin ?? this.gstin,
      upiId: upiId ?? this.upiId,
      logoPath: logoPath ?? this.logoPath,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      defaultTaxPercentage: defaultTaxPercentage ?? this.defaultTaxPercentage,
      shopCategory: shopCategory ?? this.shopCategory,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ownerName.present) {
      map['owner_name'] = Variable<String>(ownerName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (gstin.present) {
      map['gstin'] = Variable<String>(gstin.value);
    }
    if (upiId.present) {
      map['upi_id'] = Variable<String>(upiId.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (invoicePrefix.present) {
      map['invoice_prefix'] = Variable<String>(invoicePrefix.value);
    }
    if (currencySymbol.present) {
      map['currency_symbol'] = Variable<String>(currencySymbol.value);
    }
    if (defaultTaxPercentage.present) {
      map['default_tax_percentage'] =
          Variable<double>(defaultTaxPercentage.value);
    }
    if (shopCategory.present) {
      map['shop_category'] = Variable<String>(shopCategory.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (ifscCode.present) {
      map['ifsc_code'] = Variable<String>(ifscCode.value);
    }
    if (termsAndConditions.present) {
      map['terms_and_conditions'] = Variable<String>(termsAndConditions.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfileCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ownerName: $ownerName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('gstin: $gstin, ')
          ..write('upiId: $upiId, ')
          ..write('logoPath: $logoPath, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('defaultTaxPercentage: $defaultTaxPercentage, ')
          ..write('shopCategory: $shopCategory, ')
          ..write('bankName: $bankName, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('ifscCode: $ifscCode, ')
          ..write('termsAndConditions: $termsAndConditions')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('en'));
  static const VerificationMeta _remindersEnabledMeta =
      const VerificationMeta('remindersEnabled');
  @override
  late final GeneratedColumn<bool> remindersEnabled = GeneratedColumn<bool>(
      'reminders_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("reminders_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _barcodeBeepEnabledMeta =
      const VerificationMeta('barcodeBeepEnabled');
  @override
  late final GeneratedColumn<bool> barcodeBeepEnabled = GeneratedColumn<bool>(
      'barcode_beep_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("barcode_beep_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _hideGstinMeta =
      const VerificationMeta('hideGstin');
  @override
  late final GeneratedColumn<bool> hideGstin = GeneratedColumn<bool>(
      'hide_gstin', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("hide_gstin" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _barcodeScanEnabledMeta =
      const VerificationMeta('barcodeScanEnabled');
  @override
  late final GeneratedColumn<bool> barcodeScanEnabled = GeneratedColumn<bool>(
      'barcode_scan_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("barcode_scan_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _dateFormatMeta =
      const VerificationMeta('dateFormat');
  @override
  late final GeneratedColumn<String> dateFormat = GeneratedColumn<String>(
      'date_format', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('dd/MM/yyyy'));
  static const VerificationMeta _timeFormatMeta =
      const VerificationMeta('timeFormat');
  @override
  late final GeneratedColumn<String> timeFormat = GeneratedColumn<String>(
      'time_format', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('hh:mm a'));
  static const VerificationMeta _themeModeMeta =
      const VerificationMeta('themeMode');
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
      'theme_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('light'));
  static const VerificationMeta _thankYouNoteMeta =
      const VerificationMeta('thankYouNote');
  @override
  late final GeneratedColumn<String> thankYouNote = GeneratedColumn<String>(
      'thank_you_note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Thank you for shopping with us!'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        language,
        remindersEnabled,
        barcodeBeepEnabled,
        hideGstin,
        barcodeScanEnabled,
        dateFormat,
        timeFormat,
        themeMode,
        thankYouNote
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSettingsData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('reminders_enabled')) {
      context.handle(
          _remindersEnabledMeta,
          remindersEnabled.isAcceptableOrUnknown(
              data['reminders_enabled']!, _remindersEnabledMeta));
    }
    if (data.containsKey('barcode_beep_enabled')) {
      context.handle(
          _barcodeBeepEnabledMeta,
          barcodeBeepEnabled.isAcceptableOrUnknown(
              data['barcode_beep_enabled']!, _barcodeBeepEnabledMeta));
    }
    if (data.containsKey('hide_gstin')) {
      context.handle(_hideGstinMeta,
          hideGstin.isAcceptableOrUnknown(data['hide_gstin']!, _hideGstinMeta));
    }
    if (data.containsKey('barcode_scan_enabled')) {
      context.handle(
          _barcodeScanEnabledMeta,
          barcodeScanEnabled.isAcceptableOrUnknown(
              data['barcode_scan_enabled']!, _barcodeScanEnabledMeta));
    }
    if (data.containsKey('date_format')) {
      context.handle(
          _dateFormatMeta,
          dateFormat.isAcceptableOrUnknown(
              data['date_format']!, _dateFormatMeta));
    }
    if (data.containsKey('time_format')) {
      context.handle(
          _timeFormatMeta,
          timeFormat.isAcceptableOrUnknown(
              data['time_format']!, _timeFormatMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(_themeModeMeta,
          themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta));
    }
    if (data.containsKey('thank_you_note')) {
      context.handle(
          _thankYouNoteMeta,
          thankYouNote.isAcceptableOrUnknown(
              data['thank_you_note']!, _thankYouNoteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      remindersEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}reminders_enabled'])!,
      barcodeBeepEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}barcode_beep_enabled'])!,
      hideGstin: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}hide_gstin'])!,
      barcodeScanEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}barcode_scan_enabled'])!,
      dateFormat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_format'])!,
      timeFormat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time_format'])!,
      themeMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_mode'])!,
      thankYouNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thank_you_note'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingsData extends DataClass implements Insertable<AppSettingsData> {
  final int id;
  final String language;
  final bool remindersEnabled;
  final bool barcodeBeepEnabled;
  final bool hideGstin;
  final bool barcodeScanEnabled;
  final String dateFormat;
  final String timeFormat;
  final String themeMode;
  final String thankYouNote;
  const AppSettingsData(
      {required this.id,
      required this.language,
      required this.remindersEnabled,
      required this.barcodeBeepEnabled,
      required this.hideGstin,
      required this.barcodeScanEnabled,
      required this.dateFormat,
      required this.timeFormat,
      required this.themeMode,
      required this.thankYouNote});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['language'] = Variable<String>(language);
    map['reminders_enabled'] = Variable<bool>(remindersEnabled);
    map['barcode_beep_enabled'] = Variable<bool>(barcodeBeepEnabled);
    map['hide_gstin'] = Variable<bool>(hideGstin);
    map['barcode_scan_enabled'] = Variable<bool>(barcodeScanEnabled);
    map['date_format'] = Variable<String>(dateFormat);
    map['time_format'] = Variable<String>(timeFormat);
    map['theme_mode'] = Variable<String>(themeMode);
    map['thank_you_note'] = Variable<String>(thankYouNote);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      language: Value(language),
      remindersEnabled: Value(remindersEnabled),
      barcodeBeepEnabled: Value(barcodeBeepEnabled),
      hideGstin: Value(hideGstin),
      barcodeScanEnabled: Value(barcodeScanEnabled),
      dateFormat: Value(dateFormat),
      timeFormat: Value(timeFormat),
      themeMode: Value(themeMode),
      thankYouNote: Value(thankYouNote),
    );
  }

  factory AppSettingsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsData(
      id: serializer.fromJson<int>(json['id']),
      language: serializer.fromJson<String>(json['language']),
      remindersEnabled: serializer.fromJson<bool>(json['remindersEnabled']),
      barcodeBeepEnabled: serializer.fromJson<bool>(json['barcodeBeepEnabled']),
      hideGstin: serializer.fromJson<bool>(json['hideGstin']),
      barcodeScanEnabled: serializer.fromJson<bool>(json['barcodeScanEnabled']),
      dateFormat: serializer.fromJson<String>(json['dateFormat']),
      timeFormat: serializer.fromJson<String>(json['timeFormat']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      thankYouNote: serializer.fromJson<String>(json['thankYouNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'language': serializer.toJson<String>(language),
      'remindersEnabled': serializer.toJson<bool>(remindersEnabled),
      'barcodeBeepEnabled': serializer.toJson<bool>(barcodeBeepEnabled),
      'hideGstin': serializer.toJson<bool>(hideGstin),
      'barcodeScanEnabled': serializer.toJson<bool>(barcodeScanEnabled),
      'dateFormat': serializer.toJson<String>(dateFormat),
      'timeFormat': serializer.toJson<String>(timeFormat),
      'themeMode': serializer.toJson<String>(themeMode),
      'thankYouNote': serializer.toJson<String>(thankYouNote),
    };
  }

  AppSettingsData copyWith(
          {int? id,
          String? language,
          bool? remindersEnabled,
          bool? barcodeBeepEnabled,
          bool? hideGstin,
          bool? barcodeScanEnabled,
          String? dateFormat,
          String? timeFormat,
          String? themeMode,
          String? thankYouNote}) =>
      AppSettingsData(
        id: id ?? this.id,
        language: language ?? this.language,
        remindersEnabled: remindersEnabled ?? this.remindersEnabled,
        barcodeBeepEnabled: barcodeBeepEnabled ?? this.barcodeBeepEnabled,
        hideGstin: hideGstin ?? this.hideGstin,
        barcodeScanEnabled: barcodeScanEnabled ?? this.barcodeScanEnabled,
        dateFormat: dateFormat ?? this.dateFormat,
        timeFormat: timeFormat ?? this.timeFormat,
        themeMode: themeMode ?? this.themeMode,
        thankYouNote: thankYouNote ?? this.thankYouNote,
      );
  AppSettingsData copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingsData(
      id: data.id.present ? data.id.value : this.id,
      language: data.language.present ? data.language.value : this.language,
      remindersEnabled: data.remindersEnabled.present
          ? data.remindersEnabled.value
          : this.remindersEnabled,
      barcodeBeepEnabled: data.barcodeBeepEnabled.present
          ? data.barcodeBeepEnabled.value
          : this.barcodeBeepEnabled,
      hideGstin: data.hideGstin.present ? data.hideGstin.value : this.hideGstin,
      barcodeScanEnabled: data.barcodeScanEnabled.present
          ? data.barcodeScanEnabled.value
          : this.barcodeScanEnabled,
      dateFormat:
          data.dateFormat.present ? data.dateFormat.value : this.dateFormat,
      timeFormat:
          data.timeFormat.present ? data.timeFormat.value : this.timeFormat,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      thankYouNote: data.thankYouNote.present
          ? data.thankYouNote.value
          : this.thankYouNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsData(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('barcodeBeepEnabled: $barcodeBeepEnabled, ')
          ..write('hideGstin: $hideGstin, ')
          ..write('barcodeScanEnabled: $barcodeScanEnabled, ')
          ..write('dateFormat: $dateFormat, ')
          ..write('timeFormat: $timeFormat, ')
          ..write('themeMode: $themeMode, ')
          ..write('thankYouNote: $thankYouNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      language,
      remindersEnabled,
      barcodeBeepEnabled,
      hideGstin,
      barcodeScanEnabled,
      dateFormat,
      timeFormat,
      themeMode,
      thankYouNote);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsData &&
          other.id == this.id &&
          other.language == this.language &&
          other.remindersEnabled == this.remindersEnabled &&
          other.barcodeBeepEnabled == this.barcodeBeepEnabled &&
          other.hideGstin == this.hideGstin &&
          other.barcodeScanEnabled == this.barcodeScanEnabled &&
          other.dateFormat == this.dateFormat &&
          other.timeFormat == this.timeFormat &&
          other.themeMode == this.themeMode &&
          other.thankYouNote == this.thankYouNote);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingsData> {
  final Value<int> id;
  final Value<String> language;
  final Value<bool> remindersEnabled;
  final Value<bool> barcodeBeepEnabled;
  final Value<bool> hideGstin;
  final Value<bool> barcodeScanEnabled;
  final Value<String> dateFormat;
  final Value<String> timeFormat;
  final Value<String> themeMode;
  final Value<String> thankYouNote;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.language = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.barcodeBeepEnabled = const Value.absent(),
    this.hideGstin = const Value.absent(),
    this.barcodeScanEnabled = const Value.absent(),
    this.dateFormat = const Value.absent(),
    this.timeFormat = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.thankYouNote = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.language = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.barcodeBeepEnabled = const Value.absent(),
    this.hideGstin = const Value.absent(),
    this.barcodeScanEnabled = const Value.absent(),
    this.dateFormat = const Value.absent(),
    this.timeFormat = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.thankYouNote = const Value.absent(),
  });
  static Insertable<AppSettingsData> custom({
    Expression<int>? id,
    Expression<String>? language,
    Expression<bool>? remindersEnabled,
    Expression<bool>? barcodeBeepEnabled,
    Expression<bool>? hideGstin,
    Expression<bool>? barcodeScanEnabled,
    Expression<String>? dateFormat,
    Expression<String>? timeFormat,
    Expression<String>? themeMode,
    Expression<String>? thankYouNote,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (language != null) 'language': language,
      if (remindersEnabled != null) 'reminders_enabled': remindersEnabled,
      if (barcodeBeepEnabled != null)
        'barcode_beep_enabled': barcodeBeepEnabled,
      if (hideGstin != null) 'hide_gstin': hideGstin,
      if (barcodeScanEnabled != null)
        'barcode_scan_enabled': barcodeScanEnabled,
      if (dateFormat != null) 'date_format': dateFormat,
      if (timeFormat != null) 'time_format': timeFormat,
      if (themeMode != null) 'theme_mode': themeMode,
      if (thankYouNote != null) 'thank_you_note': thankYouNote,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? language,
      Value<bool>? remindersEnabled,
      Value<bool>? barcodeBeepEnabled,
      Value<bool>? hideGstin,
      Value<bool>? barcodeScanEnabled,
      Value<String>? dateFormat,
      Value<String>? timeFormat,
      Value<String>? themeMode,
      Value<String>? thankYouNote}) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      language: language ?? this.language,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      barcodeBeepEnabled: barcodeBeepEnabled ?? this.barcodeBeepEnabled,
      hideGstin: hideGstin ?? this.hideGstin,
      barcodeScanEnabled: barcodeScanEnabled ?? this.barcodeScanEnabled,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      themeMode: themeMode ?? this.themeMode,
      thankYouNote: thankYouNote ?? this.thankYouNote,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (remindersEnabled.present) {
      map['reminders_enabled'] = Variable<bool>(remindersEnabled.value);
    }
    if (barcodeBeepEnabled.present) {
      map['barcode_beep_enabled'] = Variable<bool>(barcodeBeepEnabled.value);
    }
    if (hideGstin.present) {
      map['hide_gstin'] = Variable<bool>(hideGstin.value);
    }
    if (barcodeScanEnabled.present) {
      map['barcode_scan_enabled'] = Variable<bool>(barcodeScanEnabled.value);
    }
    if (dateFormat.present) {
      map['date_format'] = Variable<String>(dateFormat.value);
    }
    if (timeFormat.present) {
      map['time_format'] = Variable<String>(timeFormat.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (thankYouNote.present) {
      map['thank_you_note'] = Variable<String>(thankYouNote.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('barcodeBeepEnabled: $barcodeBeepEnabled, ')
          ..write('hideGstin: $hideGstin, ')
          ..write('barcodeScanEnabled: $barcodeScanEnabled, ')
          ..write('dateFormat: $dateFormat, ')
          ..write('timeFormat: $timeFormat, ')
          ..write('themeMode: $themeMode, ')
          ..write('thankYouNote: $thankYouNote')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $InvoiceItemsTable invoiceItems = $InvoiceItemsTable(this);
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final $PurchaseItemsTable purchaseItems = $PurchaseItemsTable(this);
  late final $StockMovementsTable stockMovements = $StockMovementsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $BusinessProfileTable businessProfile =
      $BusinessProfileTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categories,
        products,
        customers,
        invoices,
        invoiceItems,
        purchases,
        purchaseItems,
        stockMovements,
        payments,
        businessProfile,
        appSettings
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('categories',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('products', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('invoices',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('invoice_items', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('purchases',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('purchase_items', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('products',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('stock_movements', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  Value<DateTime> createdAt,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<DateTime> createdAt,
});

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CategoriesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CategoriesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            description: description,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            description: description,
            createdAt: createdAt,
          ),
        ));
}

class $$CategoriesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter productsRefs(
      ComposableFilter Function($$ProductsTableFilterComposer f) f) {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> sku,
  Value<String?> barcode,
  Value<int?> categoryId,
  Value<double> purchasePrice,
  Value<double> sellingPrice,
  Value<double> taxPercentage,
  Value<double> currentStock,
  Value<double> minimumStock,
  Value<String> unit,
  Value<String?> description,
  Value<String?> rackNumber,
  Value<String?> batchNumber,
  Value<DateTime?> expiryDate,
  Value<DateTime?> manufacturingDate,
  Value<String?> hsnCode,
  Value<String?> purity,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> sku,
  Value<String?> barcode,
  Value<int?> categoryId,
  Value<double> purchasePrice,
  Value<double> sellingPrice,
  Value<double> taxPercentage,
  Value<double> currentStock,
  Value<double> minimumStock,
  Value<String> unit,
  Value<String?> description,
  Value<String?> rackNumber,
  Value<String?> batchNumber,
  Value<DateTime?> expiryDate,
  Value<DateTime?> manufacturingDate,
  Value<String?> hsnCode,
  Value<String?> purity,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ProductsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ProductsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> sku = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<double> purchasePrice = const Value.absent(),
            Value<double> sellingPrice = const Value.absent(),
            Value<double> taxPercentage = const Value.absent(),
            Value<double> currentStock = const Value.absent(),
            Value<double> minimumStock = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> rackNumber = const Value.absent(),
            Value<String?> batchNumber = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<DateTime?> manufacturingDate = const Value.absent(),
            Value<String?> hsnCode = const Value.absent(),
            Value<String?> purity = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            name: name,
            sku: sku,
            barcode: barcode,
            categoryId: categoryId,
            purchasePrice: purchasePrice,
            sellingPrice: sellingPrice,
            taxPercentage: taxPercentage,
            currentStock: currentStock,
            minimumStock: minimumStock,
            unit: unit,
            description: description,
            rackNumber: rackNumber,
            batchNumber: batchNumber,
            expiryDate: expiryDate,
            manufacturingDate: manufacturingDate,
            hsnCode: hsnCode,
            purity: purity,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> sku = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<double> purchasePrice = const Value.absent(),
            Value<double> sellingPrice = const Value.absent(),
            Value<double> taxPercentage = const Value.absent(),
            Value<double> currentStock = const Value.absent(),
            Value<double> minimumStock = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> rackNumber = const Value.absent(),
            Value<String?> batchNumber = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<DateTime?> manufacturingDate = const Value.absent(),
            Value<String?> hsnCode = const Value.absent(),
            Value<String?> purity = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            name: name,
            sku: sku,
            barcode: barcode,
            categoryId: categoryId,
            purchasePrice: purchasePrice,
            sellingPrice: sellingPrice,
            taxPercentage: taxPercentage,
            currentStock: currentStock,
            minimumStock: minimumStock,
            unit: unit,
            description: description,
            rackNumber: rackNumber,
            batchNumber: batchNumber,
            expiryDate: expiryDate,
            manufacturingDate: manufacturingDate,
            hsnCode: hsnCode,
            purity: purity,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
        ));
}

class $$ProductsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sku => $state.composableBuilder(
      column: $state.table.sku,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get barcode => $state.composableBuilder(
      column: $state.table.barcode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get purchasePrice => $state.composableBuilder(
      column: $state.table.purchasePrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get sellingPrice => $state.composableBuilder(
      column: $state.table.sellingPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get taxPercentage => $state.composableBuilder(
      column: $state.table.taxPercentage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get currentStock => $state.composableBuilder(
      column: $state.table.currentStock,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get minimumStock => $state.composableBuilder(
      column: $state.table.minimumStock,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get rackNumber => $state.composableBuilder(
      column: $state.table.rackNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get batchNumber => $state.composableBuilder(
      column: $state.table.batchNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get expiryDate => $state.composableBuilder(
      column: $state.table.expiryDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get manufacturingDate => $state.composableBuilder(
      column: $state.table.manufacturingDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get hsnCode => $state.composableBuilder(
      column: $state.table.hsnCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get purity => $state.composableBuilder(
      column: $state.table.purity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $state.db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CategoriesTableFilterComposer(ComposerState($state.db,
                $state.db.categories, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter invoiceItemsRefs(
      ComposableFilter Function($$InvoiceItemsTableFilterComposer f) f) {
    final $$InvoiceItemsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.invoiceItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder, parentComposers) =>
            $$InvoiceItemsTableFilterComposer(ComposerState($state.db,
                $state.db.invoiceItems, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter purchaseItemsRefs(
      ComposableFilter Function($$PurchaseItemsTableFilterComposer f) f) {
    final $$PurchaseItemsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.purchaseItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder, parentComposers) =>
            $$PurchaseItemsTableFilterComposer(ComposerState($state.db,
                $state.db.purchaseItems, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter stockMovementsRefs(
      ComposableFilter Function($$StockMovementsTableFilterComposer f) f) {
    final $$StockMovementsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.stockMovements,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder, parentComposers) =>
            $$StockMovementsTableFilterComposer(ComposerState($state.db,
                $state.db.stockMovements, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sku => $state.composableBuilder(
      column: $state.table.sku,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get barcode => $state.composableBuilder(
      column: $state.table.barcode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get purchasePrice => $state.composableBuilder(
      column: $state.table.purchasePrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get sellingPrice => $state.composableBuilder(
      column: $state.table.sellingPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get taxPercentage => $state.composableBuilder(
      column: $state.table.taxPercentage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get currentStock => $state.composableBuilder(
      column: $state.table.currentStock,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get minimumStock => $state.composableBuilder(
      column: $state.table.minimumStock,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get rackNumber => $state.composableBuilder(
      column: $state.table.rackNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get batchNumber => $state.composableBuilder(
      column: $state.table.batchNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get expiryDate => $state.composableBuilder(
      column: $state.table.expiryDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get manufacturingDate => $state.composableBuilder(
      column: $state.table.manufacturingDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get hsnCode => $state.composableBuilder(
      column: $state.table.hsnCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get purity => $state.composableBuilder(
      column: $state.table.purity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $state.db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CategoriesTableOrderingComposer(ComposerState($state.db,
                $state.db.categories, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<double> openingBalance,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<double> openingBalance,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CustomersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CustomersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<double> openingBalance = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            openingBalance: openingBalance,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<double> openingBalance = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            openingBalance: openingBalance,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
        ));
}

class $$CustomersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get openingBalance => $state.composableBuilder(
      column: $state.table.openingBalance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter invoicesRefs(
      ComposableFilter Function($$InvoicesTableFilterComposer f) f) {
    final $$InvoicesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.invoices,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder, parentComposers) =>
            $$InvoicesTableFilterComposer(ComposerState(
                $state.db, $state.db.invoices, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter paymentsRefs(
      ComposableFilter Function($$PaymentsTableFilterComposer f) f) {
    final $$PaymentsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.payments,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder, parentComposers) =>
            $$PaymentsTableFilterComposer(ComposerState(
                $state.db, $state.db.payments, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get openingBalance => $state.composableBuilder(
      column: $state.table.openingBalance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$InvoicesTableCreateCompanionBuilder = InvoicesCompanion Function({
  Value<int> id,
  required String invoiceNumber,
  required int customerId,
  Value<DateTime> date,
  Value<double> subtotal,
  Value<double> taxAmount,
  Value<double> discountAmount,
  Value<double?> discountPercentage,
  Value<double> grandTotal,
  Value<double> paidAmount,
  Value<double> dueAmount,
  Value<String> paymentMethod,
  Value<String?> notes,
  Value<double?> cgst,
  Value<double?> sgst,
  Value<double?> roundOff,
});
typedef $$InvoicesTableUpdateCompanionBuilder = InvoicesCompanion Function({
  Value<int> id,
  Value<String> invoiceNumber,
  Value<int> customerId,
  Value<DateTime> date,
  Value<double> subtotal,
  Value<double> taxAmount,
  Value<double> discountAmount,
  Value<double?> discountPercentage,
  Value<double> grandTotal,
  Value<double> paidAmount,
  Value<double> dueAmount,
  Value<String> paymentMethod,
  Value<String?> notes,
  Value<double?> cgst,
  Value<double?> sgst,
  Value<double?> roundOff,
});

class $$InvoicesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvoicesTable,
    Invoice,
    $$InvoicesTableFilterComposer,
    $$InvoicesTableOrderingComposer,
    $$InvoicesTableCreateCompanionBuilder,
    $$InvoicesTableUpdateCompanionBuilder> {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$InvoicesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$InvoicesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> invoiceNumber = const Value.absent(),
            Value<int> customerId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> taxAmount = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double?> discountPercentage = const Value.absent(),
            Value<double> grandTotal = const Value.absent(),
            Value<double> paidAmount = const Value.absent(),
            Value<double> dueAmount = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<double?> cgst = const Value.absent(),
            Value<double?> sgst = const Value.absent(),
            Value<double?> roundOff = const Value.absent(),
          }) =>
              InvoicesCompanion(
            id: id,
            invoiceNumber: invoiceNumber,
            customerId: customerId,
            date: date,
            subtotal: subtotal,
            taxAmount: taxAmount,
            discountAmount: discountAmount,
            discountPercentage: discountPercentage,
            grandTotal: grandTotal,
            paidAmount: paidAmount,
            dueAmount: dueAmount,
            paymentMethod: paymentMethod,
            notes: notes,
            cgst: cgst,
            sgst: sgst,
            roundOff: roundOff,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String invoiceNumber,
            required int customerId,
            Value<DateTime> date = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> taxAmount = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double?> discountPercentage = const Value.absent(),
            Value<double> grandTotal = const Value.absent(),
            Value<double> paidAmount = const Value.absent(),
            Value<double> dueAmount = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<double?> cgst = const Value.absent(),
            Value<double?> sgst = const Value.absent(),
            Value<double?> roundOff = const Value.absent(),
          }) =>
              InvoicesCompanion.insert(
            id: id,
            invoiceNumber: invoiceNumber,
            customerId: customerId,
            date: date,
            subtotal: subtotal,
            taxAmount: taxAmount,
            discountAmount: discountAmount,
            discountPercentage: discountPercentage,
            grandTotal: grandTotal,
            paidAmount: paidAmount,
            dueAmount: dueAmount,
            paymentMethod: paymentMethod,
            notes: notes,
            cgst: cgst,
            sgst: sgst,
            roundOff: roundOff,
          ),
        ));
}

class $$InvoicesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get invoiceNumber => $state.composableBuilder(
      column: $state.table.invoiceNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get subtotal => $state.composableBuilder(
      column: $state.table.subtotal,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get taxAmount => $state.composableBuilder(
      column: $state.table.taxAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get discountAmount => $state.composableBuilder(
      column: $state.table.discountAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get discountPercentage => $state.composableBuilder(
      column: $state.table.discountPercentage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get grandTotal => $state.composableBuilder(
      column: $state.table.grandTotal,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get paidAmount => $state.composableBuilder(
      column: $state.table.paidAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get dueAmount => $state.composableBuilder(
      column: $state.table.dueAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get paymentMethod => $state.composableBuilder(
      column: $state.table.paymentMethod,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get cgst => $state.composableBuilder(
      column: $state.table.cgst,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get sgst => $state.composableBuilder(
      column: $state.table.sgst,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get roundOff => $state.composableBuilder(
      column: $state.table.roundOff,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $state.db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CustomersTableFilterComposer(ComposerState(
                $state.db, $state.db.customers, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter invoiceItemsRefs(
      ComposableFilter Function($$InvoiceItemsTableFilterComposer f) f) {
    final $$InvoiceItemsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.invoiceItems,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder, parentComposers) =>
            $$InvoiceItemsTableFilterComposer(ComposerState($state.db,
                $state.db.invoiceItems, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter paymentsRefs(
      ComposableFilter Function($$PaymentsTableFilterComposer f) f) {
    final $$PaymentsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.payments,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder, parentComposers) =>
            $$PaymentsTableFilterComposer(ComposerState(
                $state.db, $state.db.payments, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$InvoicesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get invoiceNumber => $state.composableBuilder(
      column: $state.table.invoiceNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get subtotal => $state.composableBuilder(
      column: $state.table.subtotal,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get taxAmount => $state.composableBuilder(
      column: $state.table.taxAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get discountAmount => $state.composableBuilder(
      column: $state.table.discountAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get discountPercentage => $state.composableBuilder(
      column: $state.table.discountPercentage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get grandTotal => $state.composableBuilder(
      column: $state.table.grandTotal,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get paidAmount => $state.composableBuilder(
      column: $state.table.paidAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get dueAmount => $state.composableBuilder(
      column: $state.table.dueAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get paymentMethod => $state.composableBuilder(
      column: $state.table.paymentMethod,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get cgst => $state.composableBuilder(
      column: $state.table.cgst,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get sgst => $state.composableBuilder(
      column: $state.table.sgst,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get roundOff => $state.composableBuilder(
      column: $state.table.roundOff,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $state.db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CustomersTableOrderingComposer(ComposerState(
                $state.db, $state.db.customers, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$InvoiceItemsTableCreateCompanionBuilder = InvoiceItemsCompanion
    Function({
  Value<int> id,
  required int invoiceId,
  required int productId,
  required String productName,
  required double quantity,
  required double unitPrice,
  required double taxPercentage,
  Value<double> discountAmount,
  required double total,
  Value<String?> hsnCode,
  Value<String?> purity,
  Value<double?> grossWeight,
  Value<double?> stoneWeight,
  Value<double?> makingCharges,
  Value<double?> netWeight,
  Value<double?> rate,
  Value<double?> taxableValue,
  Value<String?> batchNumber,
  Value<DateTime?> expiryDate,
  Value<DateTime?> manufacturingDate,
});
typedef $$InvoiceItemsTableUpdateCompanionBuilder = InvoiceItemsCompanion
    Function({
  Value<int> id,
  Value<int> invoiceId,
  Value<int> productId,
  Value<String> productName,
  Value<double> quantity,
  Value<double> unitPrice,
  Value<double> taxPercentage,
  Value<double> discountAmount,
  Value<double> total,
  Value<String?> hsnCode,
  Value<String?> purity,
  Value<double?> grossWeight,
  Value<double?> stoneWeight,
  Value<double?> makingCharges,
  Value<double?> netWeight,
  Value<double?> rate,
  Value<double?> taxableValue,
  Value<String?> batchNumber,
  Value<DateTime?> expiryDate,
  Value<DateTime?> manufacturingDate,
});

class $$InvoiceItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvoiceItemsTable,
    InvoiceItem,
    $$InvoiceItemsTableFilterComposer,
    $$InvoiceItemsTableOrderingComposer,
    $$InvoiceItemsTableCreateCompanionBuilder,
    $$InvoiceItemsTableUpdateCompanionBuilder> {
  $$InvoiceItemsTableTableManager(_$AppDatabase db, $InvoiceItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$InvoiceItemsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$InvoiceItemsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> invoiceId = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<String> productName = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<double> taxPercentage = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String?> hsnCode = const Value.absent(),
            Value<String?> purity = const Value.absent(),
            Value<double?> grossWeight = const Value.absent(),
            Value<double?> stoneWeight = const Value.absent(),
            Value<double?> makingCharges = const Value.absent(),
            Value<double?> netWeight = const Value.absent(),
            Value<double?> rate = const Value.absent(),
            Value<double?> taxableValue = const Value.absent(),
            Value<String?> batchNumber = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<DateTime?> manufacturingDate = const Value.absent(),
          }) =>
              InvoiceItemsCompanion(
            id: id,
            invoiceId: invoiceId,
            productId: productId,
            productName: productName,
            quantity: quantity,
            unitPrice: unitPrice,
            taxPercentage: taxPercentage,
            discountAmount: discountAmount,
            total: total,
            hsnCode: hsnCode,
            purity: purity,
            grossWeight: grossWeight,
            stoneWeight: stoneWeight,
            makingCharges: makingCharges,
            netWeight: netWeight,
            rate: rate,
            taxableValue: taxableValue,
            batchNumber: batchNumber,
            expiryDate: expiryDate,
            manufacturingDate: manufacturingDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int invoiceId,
            required int productId,
            required String productName,
            required double quantity,
            required double unitPrice,
            required double taxPercentage,
            Value<double> discountAmount = const Value.absent(),
            required double total,
            Value<String?> hsnCode = const Value.absent(),
            Value<String?> purity = const Value.absent(),
            Value<double?> grossWeight = const Value.absent(),
            Value<double?> stoneWeight = const Value.absent(),
            Value<double?> makingCharges = const Value.absent(),
            Value<double?> netWeight = const Value.absent(),
            Value<double?> rate = const Value.absent(),
            Value<double?> taxableValue = const Value.absent(),
            Value<String?> batchNumber = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<DateTime?> manufacturingDate = const Value.absent(),
          }) =>
              InvoiceItemsCompanion.insert(
            id: id,
            invoiceId: invoiceId,
            productId: productId,
            productName: productName,
            quantity: quantity,
            unitPrice: unitPrice,
            taxPercentage: taxPercentage,
            discountAmount: discountAmount,
            total: total,
            hsnCode: hsnCode,
            purity: purity,
            grossWeight: grossWeight,
            stoneWeight: stoneWeight,
            makingCharges: makingCharges,
            netWeight: netWeight,
            rate: rate,
            taxableValue: taxableValue,
            batchNumber: batchNumber,
            expiryDate: expiryDate,
            manufacturingDate: manufacturingDate,
          ),
        ));
}

class $$InvoiceItemsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get productName => $state.composableBuilder(
      column: $state.table.productName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get unitPrice => $state.composableBuilder(
      column: $state.table.unitPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get taxPercentage => $state.composableBuilder(
      column: $state.table.taxPercentage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get discountAmount => $state.composableBuilder(
      column: $state.table.discountAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get total => $state.composableBuilder(
      column: $state.table.total,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get hsnCode => $state.composableBuilder(
      column: $state.table.hsnCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get purity => $state.composableBuilder(
      column: $state.table.purity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get grossWeight => $state.composableBuilder(
      column: $state.table.grossWeight,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get stoneWeight => $state.composableBuilder(
      column: $state.table.stoneWeight,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get makingCharges => $state.composableBuilder(
      column: $state.table.makingCharges,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get netWeight => $state.composableBuilder(
      column: $state.table.netWeight,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get rate => $state.composableBuilder(
      column: $state.table.rate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get taxableValue => $state.composableBuilder(
      column: $state.table.taxableValue,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get batchNumber => $state.composableBuilder(
      column: $state.table.batchNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get expiryDate => $state.composableBuilder(
      column: $state.table.expiryDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get manufacturingDate => $state.composableBuilder(
      column: $state.table.manufacturingDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $state.db.invoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$InvoicesTableFilterComposer(ComposerState(
                $state.db, $state.db.invoices, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$InvoiceItemsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get productName => $state.composableBuilder(
      column: $state.table.productName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get unitPrice => $state.composableBuilder(
      column: $state.table.unitPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get taxPercentage => $state.composableBuilder(
      column: $state.table.taxPercentage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get discountAmount => $state.composableBuilder(
      column: $state.table.discountAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get total => $state.composableBuilder(
      column: $state.table.total,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get hsnCode => $state.composableBuilder(
      column: $state.table.hsnCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get purity => $state.composableBuilder(
      column: $state.table.purity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get grossWeight => $state.composableBuilder(
      column: $state.table.grossWeight,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get stoneWeight => $state.composableBuilder(
      column: $state.table.stoneWeight,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get makingCharges => $state.composableBuilder(
      column: $state.table.makingCharges,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get netWeight => $state.composableBuilder(
      column: $state.table.netWeight,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get rate => $state.composableBuilder(
      column: $state.table.rate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get taxableValue => $state.composableBuilder(
      column: $state.table.taxableValue,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get batchNumber => $state.composableBuilder(
      column: $state.table.batchNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get expiryDate => $state.composableBuilder(
      column: $state.table.expiryDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get manufacturingDate => $state.composableBuilder(
      column: $state.table.manufacturingDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $state.db.invoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$InvoicesTableOrderingComposer(ComposerState(
                $state.db, $state.db.invoices, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableOrderingComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$PurchasesTableCreateCompanionBuilder = PurchasesCompanion Function({
  Value<int> id,
  required String purchaseNumber,
  Value<String?> supplierName,
  Value<DateTime> date,
  required double totalAmount,
  Value<String?> notes,
});
typedef $$PurchasesTableUpdateCompanionBuilder = PurchasesCompanion Function({
  Value<int> id,
  Value<String> purchaseNumber,
  Value<String?> supplierName,
  Value<DateTime> date,
  Value<double> totalAmount,
  Value<String?> notes,
});

class $$PurchasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchasesTable,
    Purchase,
    $$PurchasesTableFilterComposer,
    $$PurchasesTableOrderingComposer,
    $$PurchasesTableCreateCompanionBuilder,
    $$PurchasesTableUpdateCompanionBuilder> {
  $$PurchasesTableTableManager(_$AppDatabase db, $PurchasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PurchasesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PurchasesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> purchaseNumber = const Value.absent(),
            Value<String?> supplierName = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              PurchasesCompanion(
            id: id,
            purchaseNumber: purchaseNumber,
            supplierName: supplierName,
            date: date,
            totalAmount: totalAmount,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String purchaseNumber,
            Value<String?> supplierName = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            required double totalAmount,
            Value<String?> notes = const Value.absent(),
          }) =>
              PurchasesCompanion.insert(
            id: id,
            purchaseNumber: purchaseNumber,
            supplierName: supplierName,
            date: date,
            totalAmount: totalAmount,
            notes: notes,
          ),
        ));
}

class $$PurchasesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get purchaseNumber => $state.composableBuilder(
      column: $state.table.purchaseNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get supplierName => $state.composableBuilder(
      column: $state.table.supplierName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get totalAmount => $state.composableBuilder(
      column: $state.table.totalAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter purchaseItemsRefs(
      ComposableFilter Function($$PurchaseItemsTableFilterComposer f) f) {
    final $$PurchaseItemsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.purchaseItems,
        getReferencedColumn: (t) => t.purchaseId,
        builder: (joinBuilder, parentComposers) =>
            $$PurchaseItemsTableFilterComposer(ComposerState($state.db,
                $state.db.purchaseItems, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$PurchasesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get purchaseNumber => $state.composableBuilder(
      column: $state.table.purchaseNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get supplierName => $state.composableBuilder(
      column: $state.table.supplierName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get totalAmount => $state.composableBuilder(
      column: $state.table.totalAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PurchaseItemsTableCreateCompanionBuilder = PurchaseItemsCompanion
    Function({
  Value<int> id,
  required int purchaseId,
  required int productId,
  required String productName,
  required double quantity,
  required double purchasePrice,
  required double total,
});
typedef $$PurchaseItemsTableUpdateCompanionBuilder = PurchaseItemsCompanion
    Function({
  Value<int> id,
  Value<int> purchaseId,
  Value<int> productId,
  Value<String> productName,
  Value<double> quantity,
  Value<double> purchasePrice,
  Value<double> total,
});

class $$PurchaseItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchaseItemsTable,
    PurchaseItem,
    $$PurchaseItemsTableFilterComposer,
    $$PurchaseItemsTableOrderingComposer,
    $$PurchaseItemsTableCreateCompanionBuilder,
    $$PurchaseItemsTableUpdateCompanionBuilder> {
  $$PurchaseItemsTableTableManager(_$AppDatabase db, $PurchaseItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PurchaseItemsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PurchaseItemsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> purchaseId = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<String> productName = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> purchasePrice = const Value.absent(),
            Value<double> total = const Value.absent(),
          }) =>
              PurchaseItemsCompanion(
            id: id,
            purchaseId: purchaseId,
            productId: productId,
            productName: productName,
            quantity: quantity,
            purchasePrice: purchasePrice,
            total: total,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int purchaseId,
            required int productId,
            required String productName,
            required double quantity,
            required double purchasePrice,
            required double total,
          }) =>
              PurchaseItemsCompanion.insert(
            id: id,
            purchaseId: purchaseId,
            productId: productId,
            productName: productName,
            quantity: quantity,
            purchasePrice: purchasePrice,
            total: total,
          ),
        ));
}

class $$PurchaseItemsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get productName => $state.composableBuilder(
      column: $state.table.productName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get purchasePrice => $state.composableBuilder(
      column: $state.table.purchasePrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get total => $state.composableBuilder(
      column: $state.table.total,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$PurchasesTableFilterComposer get purchaseId {
    final $$PurchasesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseId,
        referencedTable: $state.db.purchases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$PurchasesTableFilterComposer(ComposerState(
                $state.db, $state.db.purchases, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$PurchaseItemsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get productName => $state.composableBuilder(
      column: $state.table.productName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get purchasePrice => $state.composableBuilder(
      column: $state.table.purchasePrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get total => $state.composableBuilder(
      column: $state.table.total,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$PurchasesTableOrderingComposer get purchaseId {
    final $$PurchasesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseId,
        referencedTable: $state.db.purchases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$PurchasesTableOrderingComposer(ComposerState(
                $state.db, $state.db.purchases, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableOrderingComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$StockMovementsTableCreateCompanionBuilder = StockMovementsCompanion
    Function({
  Value<int> id,
  required int productId,
  required double quantity,
  required String type,
  Value<String?> reason,
  Value<DateTime> date,
  Value<int?> referenceId,
});
typedef $$StockMovementsTableUpdateCompanionBuilder = StockMovementsCompanion
    Function({
  Value<int> id,
  Value<int> productId,
  Value<double> quantity,
  Value<String> type,
  Value<String?> reason,
  Value<DateTime> date,
  Value<int?> referenceId,
});

class $$StockMovementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockMovementsTable,
    StockMovement,
    $$StockMovementsTableFilterComposer,
    $$StockMovementsTableOrderingComposer,
    $$StockMovementsTableCreateCompanionBuilder,
    $$StockMovementsTableUpdateCompanionBuilder> {
  $$StockMovementsTableTableManager(
      _$AppDatabase db, $StockMovementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$StockMovementsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$StockMovementsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int?> referenceId = const Value.absent(),
          }) =>
              StockMovementsCompanion(
            id: id,
            productId: productId,
            quantity: quantity,
            type: type,
            reason: reason,
            date: date,
            referenceId: referenceId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int productId,
            required double quantity,
            required String type,
            Value<String?> reason = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int?> referenceId = const Value.absent(),
          }) =>
              StockMovementsCompanion.insert(
            id: id,
            productId: productId,
            quantity: quantity,
            type: type,
            reason: reason,
            date: date,
            referenceId: referenceId,
          ),
        ));
}

class $$StockMovementsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reason => $state.composableBuilder(
      column: $state.table.reason,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get referenceId => $state.composableBuilder(
      column: $state.table.referenceId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$StockMovementsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reason => $state.composableBuilder(
      column: $state.table.reason,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get referenceId => $state.composableBuilder(
      column: $state.table.referenceId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableOrderingComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  Value<int?> invoiceId,
  required int customerId,
  required double amount,
  required String method,
  Value<DateTime> date,
  Value<String?> notes,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  Value<int?> invoiceId,
  Value<int> customerId,
  Value<double> amount,
  Value<String> method,
  Value<DateTime> date,
  Value<String?> notes,
});

class $$PaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder> {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PaymentsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PaymentsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> invoiceId = const Value.absent(),
            Value<int> customerId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              PaymentsCompanion(
            id: id,
            invoiceId: invoiceId,
            customerId: customerId,
            amount: amount,
            method: method,
            date: date,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> invoiceId = const Value.absent(),
            required int customerId,
            required double amount,
            required String method,
            Value<DateTime> date = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              PaymentsCompanion.insert(
            id: id,
            invoiceId: invoiceId,
            customerId: customerId,
            amount: amount,
            method: method,
            date: date,
            notes: notes,
          ),
        ));
}

class $$PaymentsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get method => $state.composableBuilder(
      column: $state.table.method,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $state.db.invoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$InvoicesTableFilterComposer(ComposerState(
                $state.db, $state.db.invoices, joinBuilder, parentComposers)));
    return composer;
  }

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $state.db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CustomersTableFilterComposer(ComposerState(
                $state.db, $state.db.customers, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get method => $state.composableBuilder(
      column: $state.table.method,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $state.db.invoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$InvoicesTableOrderingComposer(ComposerState(
                $state.db, $state.db.invoices, joinBuilder, parentComposers)));
    return composer;
  }

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $state.db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CustomersTableOrderingComposer(ComposerState(
                $state.db, $state.db.customers, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$BusinessProfileTableCreateCompanionBuilder = BusinessProfileCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String?> ownerName,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> gstin,
  Value<String?> upiId,
  Value<String?> logoPath,
  Value<String> invoicePrefix,
  Value<String> currencySymbol,
  Value<double> defaultTaxPercentage,
  Value<String> shopCategory,
  Value<String?> bankName,
  Value<String?> accountNumber,
  Value<String?> ifscCode,
  Value<String?> termsAndConditions,
});
typedef $$BusinessProfileTableUpdateCompanionBuilder = BusinessProfileCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String?> ownerName,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> gstin,
  Value<String?> upiId,
  Value<String?> logoPath,
  Value<String> invoicePrefix,
  Value<String> currencySymbol,
  Value<double> defaultTaxPercentage,
  Value<String> shopCategory,
  Value<String?> bankName,
  Value<String?> accountNumber,
  Value<String?> ifscCode,
  Value<String?> termsAndConditions,
});

class $$BusinessProfileTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BusinessProfileTable,
    BusinessProfileData,
    $$BusinessProfileTableFilterComposer,
    $$BusinessProfileTableOrderingComposer,
    $$BusinessProfileTableCreateCompanionBuilder,
    $$BusinessProfileTableUpdateCompanionBuilder> {
  $$BusinessProfileTableTableManager(
      _$AppDatabase db, $BusinessProfileTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BusinessProfileTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BusinessProfileTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> ownerName = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> gstin = const Value.absent(),
            Value<String?> upiId = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<String> invoicePrefix = const Value.absent(),
            Value<String> currencySymbol = const Value.absent(),
            Value<double> defaultTaxPercentage = const Value.absent(),
            Value<String> shopCategory = const Value.absent(),
            Value<String?> bankName = const Value.absent(),
            Value<String?> accountNumber = const Value.absent(),
            Value<String?> ifscCode = const Value.absent(),
            Value<String?> termsAndConditions = const Value.absent(),
          }) =>
              BusinessProfileCompanion(
            id: id,
            name: name,
            ownerName: ownerName,
            phone: phone,
            email: email,
            address: address,
            gstin: gstin,
            upiId: upiId,
            logoPath: logoPath,
            invoicePrefix: invoicePrefix,
            currencySymbol: currencySymbol,
            defaultTaxPercentage: defaultTaxPercentage,
            shopCategory: shopCategory,
            bankName: bankName,
            accountNumber: accountNumber,
            ifscCode: ifscCode,
            termsAndConditions: termsAndConditions,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> ownerName = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> gstin = const Value.absent(),
            Value<String?> upiId = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<String> invoicePrefix = const Value.absent(),
            Value<String> currencySymbol = const Value.absent(),
            Value<double> defaultTaxPercentage = const Value.absent(),
            Value<String> shopCategory = const Value.absent(),
            Value<String?> bankName = const Value.absent(),
            Value<String?> accountNumber = const Value.absent(),
            Value<String?> ifscCode = const Value.absent(),
            Value<String?> termsAndConditions = const Value.absent(),
          }) =>
              BusinessProfileCompanion.insert(
            id: id,
            name: name,
            ownerName: ownerName,
            phone: phone,
            email: email,
            address: address,
            gstin: gstin,
            upiId: upiId,
            logoPath: logoPath,
            invoicePrefix: invoicePrefix,
            currencySymbol: currencySymbol,
            defaultTaxPercentage: defaultTaxPercentage,
            shopCategory: shopCategory,
            bankName: bankName,
            accountNumber: accountNumber,
            ifscCode: ifscCode,
            termsAndConditions: termsAndConditions,
          ),
        ));
}

class $$BusinessProfileTableFilterComposer
    extends FilterComposer<_$AppDatabase, $BusinessProfileTable> {
  $$BusinessProfileTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get ownerName => $state.composableBuilder(
      column: $state.table.ownerName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get gstin => $state.composableBuilder(
      column: $state.table.gstin,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get upiId => $state.composableBuilder(
      column: $state.table.upiId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get logoPath => $state.composableBuilder(
      column: $state.table.logoPath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get invoicePrefix => $state.composableBuilder(
      column: $state.table.invoicePrefix,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get currencySymbol => $state.composableBuilder(
      column: $state.table.currencySymbol,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get defaultTaxPercentage => $state.composableBuilder(
      column: $state.table.defaultTaxPercentage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get shopCategory => $state.composableBuilder(
      column: $state.table.shopCategory,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get bankName => $state.composableBuilder(
      column: $state.table.bankName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get accountNumber => $state.composableBuilder(
      column: $state.table.accountNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get ifscCode => $state.composableBuilder(
      column: $state.table.ifscCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get termsAndConditions => $state.composableBuilder(
      column: $state.table.termsAndConditions,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$BusinessProfileTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $BusinessProfileTable> {
  $$BusinessProfileTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get ownerName => $state.composableBuilder(
      column: $state.table.ownerName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get gstin => $state.composableBuilder(
      column: $state.table.gstin,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get upiId => $state.composableBuilder(
      column: $state.table.upiId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get logoPath => $state.composableBuilder(
      column: $state.table.logoPath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get invoicePrefix => $state.composableBuilder(
      column: $state.table.invoicePrefix,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get currencySymbol => $state.composableBuilder(
      column: $state.table.currencySymbol,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get defaultTaxPercentage => $state.composableBuilder(
      column: $state.table.defaultTaxPercentage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get shopCategory => $state.composableBuilder(
      column: $state.table.shopCategory,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get bankName => $state.composableBuilder(
      column: $state.table.bankName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get accountNumber => $state.composableBuilder(
      column: $state.table.accountNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get ifscCode => $state.composableBuilder(
      column: $state.table.ifscCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get termsAndConditions => $state.composableBuilder(
      column: $state.table.termsAndConditions,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<int> id,
  Value<String> language,
  Value<bool> remindersEnabled,
  Value<bool> barcodeBeepEnabled,
  Value<bool> hideGstin,
  Value<bool> barcodeScanEnabled,
  Value<String> dateFormat,
  Value<String> timeFormat,
  Value<String> themeMode,
  Value<String> thankYouNote,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<int> id,
  Value<String> language,
  Value<bool> remindersEnabled,
  Value<bool> barcodeBeepEnabled,
  Value<bool> hideGstin,
  Value<bool> barcodeScanEnabled,
  Value<String> dateFormat,
  Value<String> timeFormat,
  Value<String> themeMode,
  Value<String> thankYouNote,
});

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSettingsData,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AppSettingsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AppSettingsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<bool> remindersEnabled = const Value.absent(),
            Value<bool> barcodeBeepEnabled = const Value.absent(),
            Value<bool> hideGstin = const Value.absent(),
            Value<bool> barcodeScanEnabled = const Value.absent(),
            Value<String> dateFormat = const Value.absent(),
            Value<String> timeFormat = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<String> thankYouNote = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            id: id,
            language: language,
            remindersEnabled: remindersEnabled,
            barcodeBeepEnabled: barcodeBeepEnabled,
            hideGstin: hideGstin,
            barcodeScanEnabled: barcodeScanEnabled,
            dateFormat: dateFormat,
            timeFormat: timeFormat,
            themeMode: themeMode,
            thankYouNote: thankYouNote,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<bool> remindersEnabled = const Value.absent(),
            Value<bool> barcodeBeepEnabled = const Value.absent(),
            Value<bool> hideGstin = const Value.absent(),
            Value<bool> barcodeScanEnabled = const Value.absent(),
            Value<String> dateFormat = const Value.absent(),
            Value<String> timeFormat = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<String> thankYouNote = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            id: id,
            language: language,
            remindersEnabled: remindersEnabled,
            barcodeBeepEnabled: barcodeBeepEnabled,
            hideGstin: hideGstin,
            barcodeScanEnabled: barcodeScanEnabled,
            dateFormat: dateFormat,
            timeFormat: timeFormat,
            themeMode: themeMode,
            thankYouNote: thankYouNote,
          ),
        ));
}

class $$AppSettingsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get language => $state.composableBuilder(
      column: $state.table.language,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get remindersEnabled => $state.composableBuilder(
      column: $state.table.remindersEnabled,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get barcodeBeepEnabled => $state.composableBuilder(
      column: $state.table.barcodeBeepEnabled,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get hideGstin => $state.composableBuilder(
      column: $state.table.hideGstin,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get barcodeScanEnabled => $state.composableBuilder(
      column: $state.table.barcodeScanEnabled,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get dateFormat => $state.composableBuilder(
      column: $state.table.dateFormat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get timeFormat => $state.composableBuilder(
      column: $state.table.timeFormat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get themeMode => $state.composableBuilder(
      column: $state.table.themeMode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get thankYouNote => $state.composableBuilder(
      column: $state.table.thankYouNote,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AppSettingsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get language => $state.composableBuilder(
      column: $state.table.language,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get remindersEnabled => $state.composableBuilder(
      column: $state.table.remindersEnabled,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get barcodeBeepEnabled => $state.composableBuilder(
      column: $state.table.barcodeBeepEnabled,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get hideGstin => $state.composableBuilder(
      column: $state.table.hideGstin,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get barcodeScanEnabled => $state.composableBuilder(
      column: $state.table.barcodeScanEnabled,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get dateFormat => $state.composableBuilder(
      column: $state.table.dateFormat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get timeFormat => $state.composableBuilder(
      column: $state.table.timeFormat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get themeMode => $state.composableBuilder(
      column: $state.table.themeMode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get thankYouNote => $state.composableBuilder(
      column: $state.table.thankYouNote,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$InvoiceItemsTableTableManager get invoiceItems =>
      $$InvoiceItemsTableTableManager(_db, _db.invoiceItems);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
  $$PurchaseItemsTableTableManager get purchaseItems =>
      $$PurchaseItemsTableTableManager(_db, _db.purchaseItems);
  $$StockMovementsTableTableManager get stockMovements =>
      $$StockMovementsTableTableManager(_db, _db.stockMovements);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$BusinessProfileTableTableManager get businessProfile =>
      $$BusinessProfileTableTableManager(_db, _db.businessProfile);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
