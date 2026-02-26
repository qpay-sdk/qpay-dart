/// Physical or mailing address.
class Address {
  final String? city;
  final String? district;
  final String? street;
  final String? building;
  final String? address;
  final String? zipcode;
  final String? longitude;
  final String? latitude;

  const Address({
    this.city,
    this.district,
    this.street,
    this.building,
    this.address,
    this.zipcode,
    this.longitude,
    this.latitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] as String?,
      district: json['district'] as String?,
      street: json['street'] as String?,
      building: json['building'] as String?,
      address: json['address'] as String?,
      zipcode: json['zipcode'] as String?,
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (city != null) 'city': city,
      if (district != null) 'district': district,
      if (street != null) 'street': street,
      if (building != null) 'building': building,
      if (address != null) 'address': address,
      if (zipcode != null) 'zipcode': zipcode,
      if (longitude != null) 'longitude': longitude,
      if (latitude != null) 'latitude': latitude,
    };
  }
}

/// Sender branch information for invoices.
class SenderBranchData {
  final String? register;
  final String? name;
  final String? email;
  final String? phone;
  final Address? address;

  const SenderBranchData({
    this.register,
    this.name,
    this.email,
    this.phone,
    this.address,
  });

  factory SenderBranchData.fromJson(Map<String, dynamic> json) {
    return SenderBranchData(
      register: json['register'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] != null
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (register != null) 'register': register,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address!.toJson(),
    };
  }
}

/// Sender staff information for invoices.
class SenderStaffData {
  final String? name;
  final String? email;
  final String? phone;

  const SenderStaffData({
    this.name,
    this.email,
    this.phone,
  });

  factory SenderStaffData.fromJson(Map<String, dynamic> json) {
    return SenderStaffData(
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    };
  }
}

/// Invoice receiver information.
class InvoiceReceiverData {
  final String? register;
  final String? name;
  final String? email;
  final String? phone;
  final Address? address;

  const InvoiceReceiverData({
    this.register,
    this.name,
    this.email,
    this.phone,
    this.address,
  });

  factory InvoiceReceiverData.fromJson(Map<String, dynamic> json) {
    return InvoiceReceiverData(
      register: json['register'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] != null
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (register != null) 'register': register,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address!.toJson(),
    };
  }
}

/// Bank account for transactions.
class Account {
  final String accountBankCode;
  final String accountNumber;
  final String ibanNumber;
  final String accountName;
  final String accountCurrency;
  final bool isDefault;

  const Account({
    required this.accountBankCode,
    required this.accountNumber,
    required this.ibanNumber,
    required this.accountName,
    required this.accountCurrency,
    required this.isDefault,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountBankCode: json['account_bank_code'] as String? ?? '',
      accountNumber: json['account_number'] as String? ?? '',
      ibanNumber: json['iban_number'] as String? ?? '',
      accountName: json['account_name'] as String? ?? '',
      accountCurrency: json['account_currency'] as String? ?? '',
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_bank_code': accountBankCode,
      'account_number': accountNumber,
      'iban_number': ibanNumber,
      'account_name': accountName,
      'account_currency': accountCurrency,
      'is_default': isDefault,
    };
  }
}

/// Transaction within an invoice.
class Transaction {
  final String description;
  final String amount;
  final List<Account>? accounts;

  const Transaction({
    required this.description,
    required this.amount,
    this.accounts,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      description: json['description'] as String? ?? '',
      amount: json['amount'] as String? ?? '',
      accounts: (json['accounts'] as List<dynamic>?)
          ?.map((e) => Account.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'amount': amount,
      if (accounts != null)
        'accounts': accounts!.map((e) => e.toJson()).toList(),
    };
  }
}

/// Tax, discount, or surcharge entry for invoice lines.
class TaxEntry {
  final String? taxCode;
  final String? discountCode;
  final String? surchargeCode;
  final String description;
  final double amount;
  final String? note;

  const TaxEntry({
    this.taxCode,
    this.discountCode,
    this.surchargeCode,
    required this.description,
    required this.amount,
    this.note,
  });

  factory TaxEntry.fromJson(Map<String, dynamic> json) {
    return TaxEntry(
      taxCode: json['tax_code'] as String?,
      discountCode: json['discount_code'] as String?,
      surchargeCode: json['surcharge_code'] as String?,
      description: json['description'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (taxCode != null) 'tax_code': taxCode,
      if (discountCode != null) 'discount_code': discountCode,
      if (surchargeCode != null) 'surcharge_code': surchargeCode,
      'description': description,
      'amount': amount,
      if (note != null) 'note': note,
    };
  }
}

/// Invoice line item.
class InvoiceLine {
  final String? taxProductCode;
  final String lineDescription;
  final String lineQuantity;
  final String lineUnitPrice;
  final String? note;
  final List<TaxEntry>? discounts;
  final List<TaxEntry>? surcharges;
  final List<TaxEntry>? taxes;

  const InvoiceLine({
    this.taxProductCode,
    required this.lineDescription,
    required this.lineQuantity,
    required this.lineUnitPrice,
    this.note,
    this.discounts,
    this.surcharges,
    this.taxes,
  });

  factory InvoiceLine.fromJson(Map<String, dynamic> json) {
    return InvoiceLine(
      taxProductCode: json['tax_product_code'] as String?,
      lineDescription: json['line_description'] as String? ?? '',
      lineQuantity: json['line_quantity'] as String? ?? '',
      lineUnitPrice: json['line_unit_price'] as String? ?? '',
      note: json['note'] as String?,
      discounts: (json['discounts'] as List<dynamic>?)
          ?.map((e) => TaxEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      surcharges: (json['surcharges'] as List<dynamic>?)
          ?.map((e) => TaxEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      taxes: (json['taxes'] as List<dynamic>?)
          ?.map((e) => TaxEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (taxProductCode != null) 'tax_product_code': taxProductCode,
      'line_description': lineDescription,
      'line_quantity': lineQuantity,
      'line_unit_price': lineUnitPrice,
      if (note != null) 'note': note,
      if (discounts != null)
        'discounts': discounts!.map((e) => e.toJson()).toList(),
      if (surcharges != null)
        'surcharges': surcharges!.map((e) => e.toJson()).toList(),
      if (taxes != null) 'taxes': taxes!.map((e) => e.toJson()).toList(),
    };
  }
}

/// Ebarimt invoice line item (tax receipt line).
class EbarimtInvoiceLine {
  final String? taxProductCode;
  final String lineDescription;
  final String? barcode;
  final String lineQuantity;
  final String lineUnitPrice;
  final String? note;
  final String? classificationCode;
  final List<TaxEntry>? taxes;

  const EbarimtInvoiceLine({
    this.taxProductCode,
    required this.lineDescription,
    this.barcode,
    required this.lineQuantity,
    required this.lineUnitPrice,
    this.note,
    this.classificationCode,
    this.taxes,
  });

  factory EbarimtInvoiceLine.fromJson(Map<String, dynamic> json) {
    return EbarimtInvoiceLine(
      taxProductCode: json['tax_product_code'] as String?,
      lineDescription: json['line_description'] as String? ?? '',
      barcode: json['barcode'] as String?,
      lineQuantity: json['line_quantity'] as String? ?? '',
      lineUnitPrice: json['line_unit_price'] as String? ?? '',
      note: json['note'] as String?,
      classificationCode: json['classification_code'] as String?,
      taxes: (json['taxes'] as List<dynamic>?)
          ?.map((e) => TaxEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (taxProductCode != null) 'tax_product_code': taxProductCode,
      'line_description': lineDescription,
      if (barcode != null) 'barcode': barcode,
      'line_quantity': lineQuantity,
      'line_unit_price': lineUnitPrice,
      if (note != null) 'note': note,
      if (classificationCode != null)
        'classification_code': classificationCode,
      if (taxes != null) 'taxes': taxes!.map((e) => e.toJson()).toList(),
    };
  }
}

/// Deeplink for a bank/wallet payment app.
class Deeplink {
  final String name;
  final String description;
  final String logo;
  final String link;

  const Deeplink({
    required this.name,
    required this.description,
    required this.logo,
    required this.link,
  });

  factory Deeplink.fromJson(Map<String, dynamic> json) {
    return Deeplink(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
      link: json['link'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'logo': logo,
      'link': link,
    };
  }
}

/// Pagination offset for list requests.
class Offset {
  final int pageNumber;
  final int pageLimit;

  const Offset({
    required this.pageNumber,
    required this.pageLimit,
  });

  factory Offset.fromJson(Map<String, dynamic> json) {
    return Offset(
      pageNumber: json['page_number'] as int? ?? 0,
      pageLimit: json['page_limit'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page_number': pageNumber,
      'page_limit': pageLimit,
    };
  }
}
