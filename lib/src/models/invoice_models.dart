import 'common.dart';

/// Request to create a full-featured invoice.
class CreateInvoiceRequest {
  final String invoiceCode;
  final String senderInvoiceNo;
  final String? senderBranchCode;
  final SenderBranchData? senderBranchData;
  final SenderStaffData? senderStaffData;
  final String? senderStaffCode;
  final String invoiceReceiverCode;
  final InvoiceReceiverData? invoiceReceiverData;
  final String invoiceDescription;
  final String? enableExpiry;
  final bool? allowPartial;
  final double? minimumAmount;
  final bool? allowExceed;
  final double? maximumAmount;
  final double amount;
  final String callbackUrl;
  final String? senderTerminalCode;
  final Map<String, dynamic>? senderTerminalData;
  final bool? allowSubscribe;
  final String? subscriptionInterval;
  final String? subscriptionWebhook;
  final String? note;
  final List<Transaction>? transactions;
  final List<InvoiceLine>? lines;

  const CreateInvoiceRequest({
    required this.invoiceCode,
    required this.senderInvoiceNo,
    this.senderBranchCode,
    this.senderBranchData,
    this.senderStaffData,
    this.senderStaffCode,
    required this.invoiceReceiverCode,
    this.invoiceReceiverData,
    required this.invoiceDescription,
    this.enableExpiry,
    this.allowPartial,
    this.minimumAmount,
    this.allowExceed,
    this.maximumAmount,
    required this.amount,
    required this.callbackUrl,
    this.senderTerminalCode,
    this.senderTerminalData,
    this.allowSubscribe,
    this.subscriptionInterval,
    this.subscriptionWebhook,
    this.note,
    this.transactions,
    this.lines,
  });

  Map<String, dynamic> toJson() {
    return {
      'invoice_code': invoiceCode,
      'sender_invoice_no': senderInvoiceNo,
      if (senderBranchCode != null) 'sender_branch_code': senderBranchCode,
      if (senderBranchData != null)
        'sender_branch_data': senderBranchData!.toJson(),
      if (senderStaffData != null)
        'sender_staff_data': senderStaffData!.toJson(),
      if (senderStaffCode != null) 'sender_staff_code': senderStaffCode,
      'invoice_receiver_code': invoiceReceiverCode,
      if (invoiceReceiverData != null)
        'invoice_receiver_data': invoiceReceiverData!.toJson(),
      'invoice_description': invoiceDescription,
      if (enableExpiry != null) 'enable_expiry': enableExpiry,
      if (allowPartial != null) 'allow_partial': allowPartial,
      if (minimumAmount != null) 'minimum_amount': minimumAmount,
      if (allowExceed != null) 'allow_exceed': allowExceed,
      if (maximumAmount != null) 'maximum_amount': maximumAmount,
      'amount': amount,
      'callback_url': callbackUrl,
      if (senderTerminalCode != null)
        'sender_terminal_code': senderTerminalCode,
      if (senderTerminalData != null)
        'sender_terminal_data': senderTerminalData,
      if (allowSubscribe != null) 'allow_subscribe': allowSubscribe,
      if (subscriptionInterval != null)
        'subscription_interval': subscriptionInterval,
      if (subscriptionWebhook != null)
        'subscription_webhook': subscriptionWebhook,
      if (note != null) 'note': note,
      if (transactions != null)
        'transactions': transactions!.map((e) => e.toJson()).toList(),
      if (lines != null) 'lines': lines!.map((e) => e.toJson()).toList(),
    };
  }
}

/// Request to create a simple invoice with minimal fields.
class CreateSimpleInvoiceRequest {
  final String invoiceCode;
  final String senderInvoiceNo;
  final String invoiceReceiverCode;
  final String invoiceDescription;
  final String? senderBranchCode;
  final double amount;
  final String callbackUrl;

  const CreateSimpleInvoiceRequest({
    required this.invoiceCode,
    required this.senderInvoiceNo,
    required this.invoiceReceiverCode,
    required this.invoiceDescription,
    this.senderBranchCode,
    required this.amount,
    required this.callbackUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'invoice_code': invoiceCode,
      'sender_invoice_no': senderInvoiceNo,
      'invoice_receiver_code': invoiceReceiverCode,
      'invoice_description': invoiceDescription,
      if (senderBranchCode != null) 'sender_branch_code': senderBranchCode,
      'amount': amount,
      'callback_url': callbackUrl,
    };
  }
}

/// Request to create an invoice with ebarimt (tax) information.
class CreateEbarimtInvoiceRequest {
  final String invoiceCode;
  final String senderInvoiceNo;
  final String? senderBranchCode;
  final SenderStaffData? senderStaffData;
  final String? senderStaffCode;
  final String invoiceReceiverCode;
  final InvoiceReceiverData? invoiceReceiverData;
  final String invoiceDescription;
  final String taxType;
  final String districtCode;
  final String callbackUrl;
  final List<EbarimtInvoiceLine> lines;

  const CreateEbarimtInvoiceRequest({
    required this.invoiceCode,
    required this.senderInvoiceNo,
    this.senderBranchCode,
    this.senderStaffData,
    this.senderStaffCode,
    required this.invoiceReceiverCode,
    this.invoiceReceiverData,
    required this.invoiceDescription,
    required this.taxType,
    required this.districtCode,
    required this.callbackUrl,
    required this.lines,
  });

  Map<String, dynamic> toJson() {
    return {
      'invoice_code': invoiceCode,
      'sender_invoice_no': senderInvoiceNo,
      if (senderBranchCode != null) 'sender_branch_code': senderBranchCode,
      if (senderStaffData != null)
        'sender_staff_data': senderStaffData!.toJson(),
      if (senderStaffCode != null) 'sender_staff_code': senderStaffCode,
      'invoice_receiver_code': invoiceReceiverCode,
      if (invoiceReceiverData != null)
        'invoice_receiver_data': invoiceReceiverData!.toJson(),
      'invoice_description': invoiceDescription,
      'tax_type': taxType,
      'district_code': districtCode,
      'callback_url': callbackUrl,
      'lines': lines.map((e) => e.toJson()).toList(),
    };
  }
}

/// Response from creating an invoice.
class InvoiceResponse {
  final String invoiceId;
  final String qrText;
  final String qrImage;
  final String qPayShortUrl;
  final List<Deeplink> urls;

  const InvoiceResponse({
    required this.invoiceId,
    required this.qrText,
    required this.qrImage,
    required this.qPayShortUrl,
    required this.urls,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) {
    return InvoiceResponse(
      invoiceId: json['invoice_id'] as String? ?? '',
      qrText: json['qr_text'] as String? ?? '',
      qrImage: json['qr_image'] as String? ?? '',
      qPayShortUrl: json['qPay_shortUrl'] as String? ?? '',
      urls: (json['urls'] as List<dynamic>?)
              ?.map((e) => Deeplink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoice_id': invoiceId,
      'qr_text': qrText,
      'qr_image': qrImage,
      'qPay_shortUrl': qPayShortUrl,
      'urls': urls.map((e) => e.toJson()).toList(),
    };
  }
}
