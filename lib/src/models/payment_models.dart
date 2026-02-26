import 'common.dart';

/// Request to check if a payment has been made for an invoice.
class PaymentCheckRequest {
  final String objectType;
  final String objectId;
  final Offset? offset;

  const PaymentCheckRequest({
    required this.objectType,
    required this.objectId,
    this.offset,
  });

  Map<String, dynamic> toJson() {
    return {
      'object_type': objectType,
      'object_id': objectId,
      if (offset != null) 'offset': offset!.toJson(),
    };
  }
}

/// Response from a payment check request.
class PaymentCheckResponse {
  final int count;
  final double? paidAmount;
  final List<PaymentCheckRow> rows;

  const PaymentCheckResponse({
    required this.count,
    this.paidAmount,
    required this.rows,
  });

  factory PaymentCheckResponse.fromJson(Map<String, dynamic> json) {
    return PaymentCheckResponse(
      count: json['count'] as int? ?? 0,
      paidAmount: (json['paid_amount'] as num?)?.toDouble(),
      rows: (json['rows'] as List<dynamic>?)
              ?.map(
                  (e) => PaymentCheckRow.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      if (paidAmount != null) 'paid_amount': paidAmount,
      'rows': rows.map((e) => e.toJson()).toList(),
    };
  }
}

/// A single row in a payment check response.
class PaymentCheckRow {
  final String paymentId;
  final String paymentStatus;
  final String paymentAmount;
  final String trxFee;
  final String paymentCurrency;
  final String paymentWallet;
  final String paymentType;
  final String? nextPaymentDate;
  final String? nextPaymentDatetime;
  final List<CardTransaction> cardTransactions;
  final List<P2PTransaction> p2pTransactions;

  const PaymentCheckRow({
    required this.paymentId,
    required this.paymentStatus,
    required this.paymentAmount,
    required this.trxFee,
    required this.paymentCurrency,
    required this.paymentWallet,
    required this.paymentType,
    this.nextPaymentDate,
    this.nextPaymentDatetime,
    required this.cardTransactions,
    required this.p2pTransactions,
  });

  factory PaymentCheckRow.fromJson(Map<String, dynamic> json) {
    return PaymentCheckRow(
      paymentId: json['payment_id'] as String? ?? '',
      paymentStatus: json['payment_status'] as String? ?? '',
      paymentAmount: json['payment_amount'] as String? ?? '',
      trxFee: json['trx_fee'] as String? ?? '',
      paymentCurrency: json['payment_currency'] as String? ?? '',
      paymentWallet: json['payment_wallet'] as String? ?? '',
      paymentType: json['payment_type'] as String? ?? '',
      nextPaymentDate: json['next_payment_date'] as String?,
      nextPaymentDatetime: json['next_payment_datetime'] as String?,
      cardTransactions: (json['card_transactions'] as List<dynamic>?)
              ?.map(
                  (e) => CardTransaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      p2pTransactions: (json['p2p_transactions'] as List<dynamic>?)
              ?.map(
                  (e) => P2PTransaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'payment_status': paymentStatus,
      'payment_amount': paymentAmount,
      'trx_fee': trxFee,
      'payment_currency': paymentCurrency,
      'payment_wallet': paymentWallet,
      'payment_type': paymentType,
      if (nextPaymentDate != null) 'next_payment_date': nextPaymentDate,
      if (nextPaymentDatetime != null)
        'next_payment_datetime': nextPaymentDatetime,
      'card_transactions':
          cardTransactions.map((e) => e.toJson()).toList(),
      'p2p_transactions':
          p2pTransactions.map((e) => e.toJson()).toList(),
    };
  }
}

/// Detailed information about a single payment.
class PaymentDetail {
  final String paymentId;
  final String paymentStatus;
  final String paymentFee;
  final String paymentAmount;
  final String paymentCurrency;
  final String paymentDate;
  final String paymentWallet;
  final String transactionType;
  final String objectType;
  final String objectId;
  final String? nextPaymentDate;
  final String? nextPaymentDatetime;
  final List<CardTransaction> cardTransactions;
  final List<P2PTransaction> p2pTransactions;

  const PaymentDetail({
    required this.paymentId,
    required this.paymentStatus,
    required this.paymentFee,
    required this.paymentAmount,
    required this.paymentCurrency,
    required this.paymentDate,
    required this.paymentWallet,
    required this.transactionType,
    required this.objectType,
    required this.objectId,
    this.nextPaymentDate,
    this.nextPaymentDatetime,
    required this.cardTransactions,
    required this.p2pTransactions,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) {
    return PaymentDetail(
      paymentId: json['payment_id'] as String? ?? '',
      paymentStatus: json['payment_status'] as String? ?? '',
      paymentFee: json['payment_fee'] as String? ?? '',
      paymentAmount: json['payment_amount'] as String? ?? '',
      paymentCurrency: json['payment_currency'] as String? ?? '',
      paymentDate: json['payment_date'] as String? ?? '',
      paymentWallet: json['payment_wallet'] as String? ?? '',
      transactionType: json['transaction_type'] as String? ?? '',
      objectType: json['object_type'] as String? ?? '',
      objectId: json['object_id'] as String? ?? '',
      nextPaymentDate: json['next_payment_date'] as String?,
      nextPaymentDatetime: json['next_payment_datetime'] as String?,
      cardTransactions: (json['card_transactions'] as List<dynamic>?)
              ?.map(
                  (e) => CardTransaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      p2pTransactions: (json['p2p_transactions'] as List<dynamic>?)
              ?.map(
                  (e) => P2PTransaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'payment_status': paymentStatus,
      'payment_fee': paymentFee,
      'payment_amount': paymentAmount,
      'payment_currency': paymentCurrency,
      'payment_date': paymentDate,
      'payment_wallet': paymentWallet,
      'transaction_type': transactionType,
      'object_type': objectType,
      'object_id': objectId,
      if (nextPaymentDate != null) 'next_payment_date': nextPaymentDate,
      if (nextPaymentDatetime != null)
        'next_payment_datetime': nextPaymentDatetime,
      'card_transactions':
          cardTransactions.map((e) => e.toJson()).toList(),
      'p2p_transactions':
          p2pTransactions.map((e) => e.toJson()).toList(),
    };
  }
}

/// Card transaction details within a payment.
class CardTransaction {
  final String? cardMerchantCode;
  final String? cardTerminalCode;
  final String? cardNumber;
  final String cardType;
  final bool isCrossBorder;
  final String? amount;
  final String? transactionAmount;
  final String? currency;
  final String? transactionCurrency;
  final String? date;
  final String? transactionDate;
  final String? status;
  final String? transactionStatus;
  final String settlementStatus;
  final String settlementStatusDate;

  const CardTransaction({
    this.cardMerchantCode,
    this.cardTerminalCode,
    this.cardNumber,
    required this.cardType,
    required this.isCrossBorder,
    this.amount,
    this.transactionAmount,
    this.currency,
    this.transactionCurrency,
    this.date,
    this.transactionDate,
    this.status,
    this.transactionStatus,
    required this.settlementStatus,
    required this.settlementStatusDate,
  });

  factory CardTransaction.fromJson(Map<String, dynamic> json) {
    return CardTransaction(
      cardMerchantCode: json['card_merchant_code'] as String?,
      cardTerminalCode: json['card_terminal_code'] as String?,
      cardNumber: json['card_number'] as String?,
      cardType: json['card_type'] as String? ?? '',
      isCrossBorder: json['is_cross_border'] as bool? ?? false,
      amount: json['amount'] as String?,
      transactionAmount: json['transaction_amount'] as String?,
      currency: json['currency'] as String?,
      transactionCurrency: json['transaction_currency'] as String?,
      date: json['date'] as String?,
      transactionDate: json['transaction_date'] as String?,
      status: json['status'] as String?,
      transactionStatus: json['transaction_status'] as String?,
      settlementStatus: json['settlement_status'] as String? ?? '',
      settlementStatusDate: json['settlement_status_date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (cardMerchantCode != null) 'card_merchant_code': cardMerchantCode,
      if (cardTerminalCode != null) 'card_terminal_code': cardTerminalCode,
      if (cardNumber != null) 'card_number': cardNumber,
      'card_type': cardType,
      'is_cross_border': isCrossBorder,
      if (amount != null) 'amount': amount,
      if (transactionAmount != null) 'transaction_amount': transactionAmount,
      if (currency != null) 'currency': currency,
      if (transactionCurrency != null)
        'transaction_currency': transactionCurrency,
      if (date != null) 'date': date,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (status != null) 'status': status,
      if (transactionStatus != null) 'transaction_status': transactionStatus,
      'settlement_status': settlementStatus,
      'settlement_status_date': settlementStatusDate,
    };
  }
}

/// Peer-to-peer transaction details within a payment.
class P2PTransaction {
  final String transactionBankCode;
  final String accountBankCode;
  final String accountBankName;
  final String accountNumber;
  final String status;
  final String amount;
  final String currency;
  final String settlementStatus;

  const P2PTransaction({
    required this.transactionBankCode,
    required this.accountBankCode,
    required this.accountBankName,
    required this.accountNumber,
    required this.status,
    required this.amount,
    required this.currency,
    required this.settlementStatus,
  });

  factory P2PTransaction.fromJson(Map<String, dynamic> json) {
    return P2PTransaction(
      transactionBankCode: json['transaction_bank_code'] as String? ?? '',
      accountBankCode: json['account_bank_code'] as String? ?? '',
      accountBankName: json['account_bank_name'] as String? ?? '',
      accountNumber: json['account_number'] as String? ?? '',
      status: json['status'] as String? ?? '',
      amount: json['amount'] as String? ?? '',
      currency: json['currency'] as String? ?? '',
      settlementStatus: json['settlement_status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_bank_code': transactionBankCode,
      'account_bank_code': accountBankCode,
      'account_bank_name': accountBankName,
      'account_number': accountNumber,
      'status': status,
      'amount': amount,
      'currency': currency,
      'settlement_status': settlementStatus,
    };
  }
}

/// Request to list payments with filters.
class PaymentListRequest {
  final String objectType;
  final String objectId;
  final String startDate;
  final String endDate;
  final Offset offset;

  const PaymentListRequest({
    required this.objectType,
    required this.objectId,
    required this.startDate,
    required this.endDate,
    required this.offset,
  });

  Map<String, dynamic> toJson() {
    return {
      'object_type': objectType,
      'object_id': objectId,
      'start_date': startDate,
      'end_date': endDate,
      'offset': offset.toJson(),
    };
  }
}

/// Response from a payment list request.
class PaymentListResponse {
  final int count;
  final List<PaymentListItem> rows;

  const PaymentListResponse({
    required this.count,
    required this.rows,
  });

  factory PaymentListResponse.fromJson(Map<String, dynamic> json) {
    return PaymentListResponse(
      count: json['count'] as int? ?? 0,
      rows: (json['rows'] as List<dynamic>?)
              ?.map(
                  (e) => PaymentListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'rows': rows.map((e) => e.toJson()).toList(),
    };
  }
}

/// A single item in a payment list response.
class PaymentListItem {
  final String paymentId;
  final String paymentDate;
  final String paymentStatus;
  final String paymentFee;
  final String paymentAmount;
  final String paymentCurrency;
  final String paymentWallet;
  final String paymentName;
  final String paymentDescription;
  final String qrCode;
  final String paidBy;
  final String objectType;
  final String objectId;

  const PaymentListItem({
    required this.paymentId,
    required this.paymentDate,
    required this.paymentStatus,
    required this.paymentFee,
    required this.paymentAmount,
    required this.paymentCurrency,
    required this.paymentWallet,
    required this.paymentName,
    required this.paymentDescription,
    required this.qrCode,
    required this.paidBy,
    required this.objectType,
    required this.objectId,
  });

  factory PaymentListItem.fromJson(Map<String, dynamic> json) {
    return PaymentListItem(
      paymentId: json['payment_id'] as String? ?? '',
      paymentDate: json['payment_date'] as String? ?? '',
      paymentStatus: json['payment_status'] as String? ?? '',
      paymentFee: json['payment_fee'] as String? ?? '',
      paymentAmount: json['payment_amount'] as String? ?? '',
      paymentCurrency: json['payment_currency'] as String? ?? '',
      paymentWallet: json['payment_wallet'] as String? ?? '',
      paymentName: json['payment_name'] as String? ?? '',
      paymentDescription: json['payment_description'] as String? ?? '',
      qrCode: json['qr_code'] as String? ?? '',
      paidBy: json['paid_by'] as String? ?? '',
      objectType: json['object_type'] as String? ?? '',
      objectId: json['object_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'payment_date': paymentDate,
      'payment_status': paymentStatus,
      'payment_fee': paymentFee,
      'payment_amount': paymentAmount,
      'payment_currency': paymentCurrency,
      'payment_wallet': paymentWallet,
      'payment_name': paymentName,
      'payment_description': paymentDescription,
      'qr_code': qrCode,
      'paid_by': paidBy,
      'object_type': objectType,
      'object_id': objectId,
    };
  }
}

/// Request to cancel a payment (card transactions only).
class PaymentCancelRequest {
  final String? callbackUrl;
  final String? note;

  const PaymentCancelRequest({
    this.callbackUrl,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      if (callbackUrl != null) 'callback_url': callbackUrl,
      if (note != null) 'note': note,
    };
  }
}

/// Request to refund a payment (card transactions only).
class PaymentRefundRequest {
  final String? callbackUrl;
  final String? note;

  const PaymentRefundRequest({
    this.callbackUrl,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      if (callbackUrl != null) 'callback_url': callbackUrl,
      if (note != null) 'note': note,
    };
  }
}
