/// Request to create an ebarimt (electronic tax receipt) for a payment.
class CreateEbarimtRequest {
  final String paymentId;
  final String ebarimtReceiverType;
  final String? ebarimtReceiver;
  final String? districtCode;
  final String? classificationCode;

  const CreateEbarimtRequest({
    required this.paymentId,
    required this.ebarimtReceiverType,
    this.ebarimtReceiver,
    this.districtCode,
    this.classificationCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'ebarimt_receiver_type': ebarimtReceiverType,
      if (ebarimtReceiver != null) 'ebarimt_receiver': ebarimtReceiver,
      if (districtCode != null) 'district_code': districtCode,
      if (classificationCode != null)
        'classification_code': classificationCode,
    };
  }
}

/// Response from creating or canceling an ebarimt.
class EbarimtResponse {
  final String id;
  final String ebarimtBy;
  final String gWalletId;
  final String gWalletCustomerId;
  final String ebarimtReceiverType;
  final String ebarimtReceiver;
  final String ebarimtDistrictCode;
  final String ebarimtBillType;
  final String gMerchantId;
  final String merchantBranchCode;
  final String? merchantTerminalCode;
  final String? merchantStaffCode;
  final String merchantRegisterNo;
  final String gPaymentId;
  final String paidBy;
  final String objectType;
  final String objectId;
  final String amount;
  final String vatAmount;
  final String cityTaxAmount;
  final String ebarimtQrData;
  final String ebarimtLottery;
  final String? note;
  final String barimtStatus;
  final String barimtStatusDate;
  final String? ebarimtSentEmail;
  final String ebarimtReceiverPhone;
  final String taxType;
  final String? merchantTin;
  final String? ebarimtReceiptId;
  final String createdBy;
  final String createdDate;
  final String updatedBy;
  final String updatedDate;
  final bool status;
  final List<EbarimtItem>? barimtItems;
  final List<dynamic>? barimtTransactions;
  final List<EbarimtHistory>? barimtHistories;

  const EbarimtResponse({
    required this.id,
    required this.ebarimtBy,
    required this.gWalletId,
    required this.gWalletCustomerId,
    required this.ebarimtReceiverType,
    required this.ebarimtReceiver,
    required this.ebarimtDistrictCode,
    required this.ebarimtBillType,
    required this.gMerchantId,
    required this.merchantBranchCode,
    this.merchantTerminalCode,
    this.merchantStaffCode,
    required this.merchantRegisterNo,
    required this.gPaymentId,
    required this.paidBy,
    required this.objectType,
    required this.objectId,
    required this.amount,
    required this.vatAmount,
    required this.cityTaxAmount,
    required this.ebarimtQrData,
    required this.ebarimtLottery,
    this.note,
    required this.barimtStatus,
    required this.barimtStatusDate,
    this.ebarimtSentEmail,
    required this.ebarimtReceiverPhone,
    required this.taxType,
    this.merchantTin,
    this.ebarimtReceiptId,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.status,
    this.barimtItems,
    this.barimtTransactions,
    this.barimtHistories,
  });

  factory EbarimtResponse.fromJson(Map<String, dynamic> json) {
    return EbarimtResponse(
      id: json['id'] as String? ?? '',
      ebarimtBy: json['ebarimt_by'] as String? ?? '',
      gWalletId: json['g_wallet_id'] as String? ?? '',
      gWalletCustomerId: json['g_wallet_customer_id'] as String? ?? '',
      ebarimtReceiverType: json['ebarimt_receiver_type'] as String? ?? '',
      ebarimtReceiver: json['ebarimt_receiver'] as String? ?? '',
      ebarimtDistrictCode: json['ebarimt_district_code'] as String? ?? '',
      ebarimtBillType: json['ebarimt_bill_type'] as String? ?? '',
      gMerchantId: json['g_merchant_id'] as String? ?? '',
      merchantBranchCode: json['merchant_branch_code'] as String? ?? '',
      merchantTerminalCode: json['merchant_terminal_code'] as String?,
      merchantStaffCode: json['merchant_staff_code'] as String?,
      merchantRegisterNo: json['merchant_register_no'] as String? ?? '',
      gPaymentId: json['g_payment_id'] as String? ?? '',
      paidBy: json['paid_by'] as String? ?? '',
      objectType: json['object_type'] as String? ?? '',
      objectId: json['object_id'] as String? ?? '',
      amount: json['amount'] as String? ?? '',
      vatAmount: json['vat_amount'] as String? ?? '',
      cityTaxAmount: json['city_tax_amount'] as String? ?? '',
      ebarimtQrData: json['ebarimt_qr_data'] as String? ?? '',
      ebarimtLottery: json['ebarimt_lottery'] as String? ?? '',
      note: json['note'] as String?,
      barimtStatus: json['barimt_status'] as String? ?? '',
      barimtStatusDate: json['barimt_status_date'] as String? ?? '',
      ebarimtSentEmail: json['ebarimt_sent_email'] as String?,
      ebarimtReceiverPhone: json['ebarimt_receiver_phone'] as String? ?? '',
      taxType: json['tax_type'] as String? ?? '',
      merchantTin: json['merchant_tin'] as String?,
      ebarimtReceiptId: json['ebarimt_receipt_id'] as String?,
      createdBy: json['created_by'] as String? ?? '',
      createdDate: json['created_date'] as String? ?? '',
      updatedBy: json['updated_by'] as String? ?? '',
      updatedDate: json['updated_date'] as String? ?? '',
      status: json['status'] as bool? ?? false,
      barimtItems: (json['barimt_items'] as List<dynamic>?)
          ?.map((e) => EbarimtItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      barimtTransactions: json['barimt_transactions'] as List<dynamic>?,
      barimtHistories: (json['barimt_histories'] as List<dynamic>?)
          ?.map((e) => EbarimtHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ebarimt_by': ebarimtBy,
      'g_wallet_id': gWalletId,
      'g_wallet_customer_id': gWalletCustomerId,
      'ebarimt_receiver_type': ebarimtReceiverType,
      'ebarimt_receiver': ebarimtReceiver,
      'ebarimt_district_code': ebarimtDistrictCode,
      'ebarimt_bill_type': ebarimtBillType,
      'g_merchant_id': gMerchantId,
      'merchant_branch_code': merchantBranchCode,
      'merchant_terminal_code': merchantTerminalCode,
      'merchant_staff_code': merchantStaffCode,
      'merchant_register_no': merchantRegisterNo,
      'g_payment_id': gPaymentId,
      'paid_by': paidBy,
      'object_type': objectType,
      'object_id': objectId,
      'amount': amount,
      'vat_amount': vatAmount,
      'city_tax_amount': cityTaxAmount,
      'ebarimt_qr_data': ebarimtQrData,
      'ebarimt_lottery': ebarimtLottery,
      'note': note,
      'barimt_status': barimtStatus,
      'barimt_status_date': barimtStatusDate,
      'ebarimt_sent_email': ebarimtSentEmail,
      'ebarimt_receiver_phone': ebarimtReceiverPhone,
      'tax_type': taxType,
      if (merchantTin != null) 'merchant_tin': merchantTin,
      if (ebarimtReceiptId != null) 'ebarimt_receipt_id': ebarimtReceiptId,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'status': status,
      if (barimtItems != null)
        'barimt_items': barimtItems!.map((e) => e.toJson()).toList(),
      if (barimtTransactions != null)
        'barimt_transactions': barimtTransactions,
      if (barimtHistories != null)
        'barimt_histories':
            barimtHistories!.map((e) => e.toJson()).toList(),
    };
  }
}

/// A single line item within an ebarimt receipt.
class EbarimtItem {
  final String id;
  final String barimtId;
  final String? merchantProductCode;
  final String taxProductCode;
  final String? barCode;
  final String name;
  final String unitPrice;
  final String quantity;
  final String amount;
  final String cityTaxAmount;
  final String vatAmount;
  final String? note;
  final String createdBy;
  final String createdDate;
  final String updatedBy;
  final String updatedDate;
  final bool status;

  const EbarimtItem({
    required this.id,
    required this.barimtId,
    this.merchantProductCode,
    required this.taxProductCode,
    this.barCode,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.amount,
    required this.cityTaxAmount,
    required this.vatAmount,
    this.note,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.status,
  });

  factory EbarimtItem.fromJson(Map<String, dynamic> json) {
    return EbarimtItem(
      id: json['id'] as String? ?? '',
      barimtId: json['barimt_id'] as String? ?? '',
      merchantProductCode: json['merchant_product_code'] as String?,
      taxProductCode: json['tax_product_code'] as String? ?? '',
      barCode: json['bar_code'] as String?,
      name: json['name'] as String? ?? '',
      unitPrice: json['unit_price'] as String? ?? '',
      quantity: json['quantity'] as String? ?? '',
      amount: json['amount'] as String? ?? '',
      cityTaxAmount: json['city_tax_amount'] as String? ?? '',
      vatAmount: json['vat_amount'] as String? ?? '',
      note: json['note'] as String?,
      createdBy: json['created_by'] as String? ?? '',
      createdDate: json['created_date'] as String? ?? '',
      updatedBy: json['updated_by'] as String? ?? '',
      updatedDate: json['updated_date'] as String? ?? '',
      status: json['status'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barimt_id': barimtId,
      'merchant_product_code': merchantProductCode,
      'tax_product_code': taxProductCode,
      'bar_code': barCode,
      'name': name,
      'unit_price': unitPrice,
      'quantity': quantity,
      'amount': amount,
      'city_tax_amount': cityTaxAmount,
      'vat_amount': vatAmount,
      'note': note,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'status': status,
    };
  }
}

/// Historical record of an ebarimt receipt.
class EbarimtHistory {
  final String id;
  final String barimtId;
  final String ebarimtReceiverType;
  final String ebarimtReceiver;
  final String? ebarimtRegisterNo;
  final String ebarimtBillId;
  final String ebarimtDate;
  final String ebarimtMacAddress;
  final String ebarimtInternalCode;
  final String ebarimtBillType;
  final String ebarimtQrData;
  final String ebarimtLottery;
  final String? ebarimtLotteryMsg;
  final String? ebarimtErrorCode;
  final String? ebarimtErrorMsg;
  final String? ebarimtResponseCode;
  final String? ebarimtResponseMsg;
  final String? note;
  final String barimtStatus;
  final String barimtStatusDate;
  final String? ebarimtSentEmail;
  final String ebarimtReceiverPhone;
  final String taxType;
  final String createdBy;
  final String createdDate;
  final String updatedBy;
  final String updatedDate;
  final bool status;

  const EbarimtHistory({
    required this.id,
    required this.barimtId,
    required this.ebarimtReceiverType,
    required this.ebarimtReceiver,
    this.ebarimtRegisterNo,
    required this.ebarimtBillId,
    required this.ebarimtDate,
    required this.ebarimtMacAddress,
    required this.ebarimtInternalCode,
    required this.ebarimtBillType,
    required this.ebarimtQrData,
    required this.ebarimtLottery,
    this.ebarimtLotteryMsg,
    this.ebarimtErrorCode,
    this.ebarimtErrorMsg,
    this.ebarimtResponseCode,
    this.ebarimtResponseMsg,
    this.note,
    required this.barimtStatus,
    required this.barimtStatusDate,
    this.ebarimtSentEmail,
    required this.ebarimtReceiverPhone,
    required this.taxType,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.status,
  });

  factory EbarimtHistory.fromJson(Map<String, dynamic> json) {
    return EbarimtHistory(
      id: json['id'] as String? ?? '',
      barimtId: json['barimt_id'] as String? ?? '',
      ebarimtReceiverType: json['ebarimt_receiver_type'] as String? ?? '',
      ebarimtReceiver: json['ebarimt_receiver'] as String? ?? '',
      ebarimtRegisterNo: json['ebarimt_register_no'] as String?,
      ebarimtBillId: json['ebarimt_bill_id'] as String? ?? '',
      ebarimtDate: json['ebarimt_date'] as String? ?? '',
      ebarimtMacAddress: json['ebarimt_mac_address'] as String? ?? '',
      ebarimtInternalCode: json['ebarimt_internal_code'] as String? ?? '',
      ebarimtBillType: json['ebarimt_bill_type'] as String? ?? '',
      ebarimtQrData: json['ebarimt_qr_data'] as String? ?? '',
      ebarimtLottery: json['ebarimt_lottery'] as String? ?? '',
      ebarimtLotteryMsg: json['ebarimt_lottery_msg'] as String?,
      ebarimtErrorCode: json['ebarimt_error_code'] as String?,
      ebarimtErrorMsg: json['ebarimt_error_msg'] as String?,
      ebarimtResponseCode: json['ebarimt_response_code'] as String?,
      ebarimtResponseMsg: json['ebarimt_response_msg'] as String?,
      note: json['note'] as String?,
      barimtStatus: json['barimt_status'] as String? ?? '',
      barimtStatusDate: json['barimt_status_date'] as String? ?? '',
      ebarimtSentEmail: json['ebarimt_sent_email'] as String?,
      ebarimtReceiverPhone: json['ebarimt_receiver_phone'] as String? ?? '',
      taxType: json['tax_type'] as String? ?? '',
      createdBy: json['created_by'] as String? ?? '',
      createdDate: json['created_date'] as String? ?? '',
      updatedBy: json['updated_by'] as String? ?? '',
      updatedDate: json['updated_date'] as String? ?? '',
      status: json['status'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barimt_id': barimtId,
      'ebarimt_receiver_type': ebarimtReceiverType,
      'ebarimt_receiver': ebarimtReceiver,
      'ebarimt_register_no': ebarimtRegisterNo,
      'ebarimt_bill_id': ebarimtBillId,
      'ebarimt_date': ebarimtDate,
      'ebarimt_mac_address': ebarimtMacAddress,
      'ebarimt_internal_code': ebarimtInternalCode,
      'ebarimt_bill_type': ebarimtBillType,
      'ebarimt_qr_data': ebarimtQrData,
      'ebarimt_lottery': ebarimtLottery,
      'ebarimt_lottery_msg': ebarimtLotteryMsg,
      'ebarimt_error_code': ebarimtErrorCode,
      'ebarimt_error_msg': ebarimtErrorMsg,
      'ebarimt_response_code': ebarimtResponseCode,
      'ebarimt_response_msg': ebarimtResponseMsg,
      'note': note,
      'barimt_status': barimtStatus,
      'barimt_status_date': barimtStatusDate,
      'ebarimt_sent_email': ebarimtSentEmail,
      'ebarimt_receiver_phone': ebarimtReceiverPhone,
      'tax_type': taxType,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'status': status,
    };
  }
}
