# QPay Dart SDK

[![pub package](https://img.shields.io/pub/v/qpay.svg)](https://pub.dev/packages/qpay)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A Dart/Flutter client library for the [QPay V2 API](https://merchant.qpay.mn) with automatic token management, strong typing, and comprehensive error handling.

## Features

- Automatic access token acquisition and refresh
- Strongly typed request/response models for all endpoints
- Invoice creation (simple, full, and ebarimt/tax)
- Payment checking, listing, cancellation, and refund
- Ebarimt (electronic tax receipt) creation and cancellation
- Named error code constants for easy matching
- Works with Dart CLI apps and Flutter

## Installation

### Dart

```bash
dart pub add qpay
```

### Flutter

```bash
flutter pub add qpay
```

Or add it manually to your `pubspec.yaml`:

```yaml
dependencies:
  qpay: ^1.0.0
```

Then run:

```bash
dart pub get
```

## Quick Start

```dart
import 'package:qpay/qpay.dart';

void main() async {
  final client = QPayClient(QPayConfig(
    baseUrl: 'https://merchant.qpay.mn',
    username: 'YOUR_USERNAME',
    password: 'YOUR_PASSWORD',
    invoiceCode: 'YOUR_INVOICE_CODE',
    callbackUrl: 'https://yourapp.com/callback',
  ));

  try {
    // Create a simple invoice
    final invoice = await client.createSimpleInvoice(CreateSimpleInvoiceRequest(
      invoiceCode: 'YOUR_INVOICE_CODE',
      senderInvoiceNo: 'INV-001',
      invoiceReceiverCode: 'terminal',
      invoiceDescription: 'Order #001',
      amount: 10000,
      callbackUrl: 'https://yourapp.com/callback',
    ));

    print('Invoice ID: ${invoice.invoiceId}');
    print('QR Image: ${invoice.qrImage}');
    print('Short URL: ${invoice.qPayShortUrl}');

    // Check payment status
    final check = await client.checkPayment(PaymentCheckRequest(
      objectType: 'INVOICE',
      objectId: invoice.invoiceId,
    ));

    print('Paid: ${check.count > 0}');
  } on QPayException catch (e) {
    print('QPay error: ${e.code} - ${e.message}');
  } finally {
    client.close();
  }
}
```

## Configuration

### Direct Configuration

```dart
const config = QPayConfig(
  baseUrl: 'https://merchant.qpay.mn',
  username: 'YOUR_USERNAME',
  password: 'YOUR_PASSWORD',
  invoiceCode: 'YOUR_INVOICE_CODE',
  callbackUrl: 'https://yourapp.com/callback',
);
```

### From Environment Variables

For server-side Dart applications, you can load configuration from environment variables:

```dart
final config = QPayConfig.fromEnvironment();
```

This reads the following environment variables:

| Variable | Description |
|---|---|
| `QPAY_BASE_URL` | QPay API base URL (e.g. `https://merchant.qpay.mn`) |
| `QPAY_USERNAME` | QPay merchant username |
| `QPAY_PASSWORD` | QPay merchant password |
| `QPAY_INVOICE_CODE` | Default invoice code |
| `QPAY_CALLBACK_URL` | Payment callback URL |

Throws `ArgumentError` if any required variable is missing.

### Custom HTTP Client

You can provide your own `http.Client` for custom configurations or testing:

```dart
import 'package:http/http.dart' as http;

final httpClient = http.Client();
final client = QPayClient(config, httpClient: httpClient);
```

When you provide your own HTTP client, calling `client.close()` will **not** close it -- you are responsible for its lifecycle.

## Usage

### Authentication

The client handles authentication automatically. Tokens are acquired on the first request and refreshed transparently when they expire. You can also manage tokens manually:

```dart
// Manually get a new token
final token = await client.getToken();
print('Access token: ${token.accessToken}');

// Manually refresh the token
final refreshed = await client.refreshToken();
```

### Create a Simple Invoice

```dart
final invoice = await client.createSimpleInvoice(CreateSimpleInvoiceRequest(
  invoiceCode: 'YOUR_INVOICE_CODE',
  senderInvoiceNo: 'INV-001',
  invoiceReceiverCode: 'terminal',
  invoiceDescription: 'Coffee x2',
  amount: 12000,
  callbackUrl: 'https://yourapp.com/callback',
));

print('Invoice ID: ${invoice.invoiceId}');
print('QR: ${invoice.qrText}');

// Deep links for bank apps
for (final url in invoice.urls) {
  print('${url.name}: ${url.link}');
}
```

### Create a Full Invoice

```dart
final invoice = await client.createInvoice(CreateInvoiceRequest(
  invoiceCode: 'YOUR_INVOICE_CODE',
  senderInvoiceNo: 'INV-002',
  invoiceReceiverCode: 'terminal',
  invoiceDescription: 'Detailed order',
  amount: 25000,
  callbackUrl: 'https://yourapp.com/callback',
  allowPartial: false,
  allowExceed: false,
  note: 'Order note',
  senderBranchData: SenderBranchData(
    name: 'Main Branch',
    email: 'branch@example.com',
    phone: '99001122',
    address: Address(city: 'Ulaanbaatar', district: 'KHN'),
  ),
  invoiceReceiverData: InvoiceReceiverData(
    name: 'Customer',
    email: 'customer@example.com',
    phone: '88001122',
  ),
  lines: [
    InvoiceLine(
      lineDescription: 'Widget A',
      lineQuantity: '2',
      lineUnitPrice: '10000',
      taxes: [
        TaxEntry(taxCode: 'VAT', description: 'VAT 10%', amount: 2000),
      ],
    ),
    InvoiceLine(
      lineDescription: 'Widget B',
      lineQuantity: '1',
      lineUnitPrice: '5000',
    ),
  ],
));
```

### Create an Ebarimt Invoice (Tax Invoice)

```dart
final invoice = await client.createEbarimtInvoice(CreateEbarimtInvoiceRequest(
  invoiceCode: 'YOUR_INVOICE_CODE',
  senderInvoiceNo: 'INV-003',
  invoiceReceiverCode: 'terminal',
  invoiceDescription: 'Tax invoice',
  taxType: 'VAT',
  districtCode: 'UB01',
  callbackUrl: 'https://yourapp.com/callback',
  lines: [
    EbarimtInvoiceLine(
      taxProductCode: 'TP001',
      lineDescription: 'Service fee',
      lineQuantity: '1',
      lineUnitPrice: '50000',
      classificationCode: 'CL01',
    ),
  ],
));
```

### Cancel an Invoice

```dart
await client.cancelInvoice('invoice-id');
```

### Check Payment Status

```dart
final result = await client.checkPayment(PaymentCheckRequest(
  objectType: 'INVOICE',
  objectId: 'invoice-id',
));

if (result.count > 0) {
  print('Paid amount: ${result.paidAmount}');
  for (final row in result.rows) {
    print('Payment ${row.paymentId}: ${row.paymentStatus}');
    print('  Amount: ${row.paymentAmount} ${row.paymentCurrency}');
    print('  Wallet: ${row.paymentWallet}');
  }
}
```

### Get Payment Details

```dart
final payment = await client.getPayment('payment-id');

print('Status: ${payment.paymentStatus}');
print('Amount: ${payment.paymentAmount}');
print('Date: ${payment.paymentDate}');

// Card transaction details
for (final ct in payment.cardTransactions) {
  print('Card: ${ct.cardType} ${ct.cardNumber}');
  print('Settlement: ${ct.settlementStatus}');
}

// P2P transaction details
for (final p2p in payment.p2pTransactions) {
  print('Bank: ${p2p.accountBankName}');
  print('Account: ${p2p.accountNumber}');
}
```

### List Payments

```dart
final payments = await client.listPayments(PaymentListRequest(
  objectType: 'INVOICE',
  objectId: 'invoice-id',
  startDate: '2025-01-01',
  endDate: '2025-12-31',
  offset: Offset(pageNumber: 1, pageLimit: 20),
));

print('Total: ${payments.count}');
for (final item in payments.rows) {
  print('${item.paymentId}: ${item.paymentAmount} ${item.paymentCurrency}');
}
```

### Cancel a Payment

```dart
await client.cancelPayment(
  'payment-id',
  PaymentCancelRequest(
    callbackUrl: 'https://yourapp.com/cancel-callback',
    note: 'Customer requested cancellation',
  ),
);
```

### Refund a Payment

```dart
await client.refundPayment(
  'payment-id',
  PaymentRefundRequest(
    callbackUrl: 'https://yourapp.com/refund-callback',
    note: 'Defective product',
  ),
);
```

### Create an Ebarimt (Tax Receipt)

```dart
final ebarimt = await client.createEbarimt(CreateEbarimtRequest(
  paymentId: 'payment-id',
  ebarimtReceiverType: 'INDIVIDUAL',
  ebarimtReceiver: '99001122',
  districtCode: 'UB01',
));

print('Ebarimt ID: ${ebarimt.id}');
print('Lottery: ${ebarimt.ebarimtLottery}');
print('QR Data: ${ebarimt.ebarimtQrData}');
print('VAT: ${ebarimt.vatAmount}');
```

### Cancel an Ebarimt

```dart
final cancelled = await client.cancelEbarimt('payment-id');
print('Status: ${cancelled.barimtStatus}');
```

## Error Handling

All API errors throw `QPayException` with structured information:

```dart
try {
  await client.cancelInvoice('nonexistent-id');
} on QPayException catch (e) {
  print('Status: ${e.statusCode}');   // HTTP status code (e.g. 404)
  print('Code: ${e.code}');           // QPay error code (e.g. "INVOICE_NOTFOUND")
  print('Message: ${e.message}');     // Human-readable message
  print('Body: ${e.rawBody}');        // Raw response body for debugging

  // Match against known error codes
  if (e.code == QPayException.invoiceNotFound) {
    print('Invoice does not exist');
  } else if (e.code == QPayException.invoicePaid) {
    print('Invoice has already been paid');
  } else if (e.code == QPayException.authenticationFailed) {
    print('Check your credentials');
  }
}
```

### Error Code Constants

The `QPayException` class provides named constants for all known QPay error codes:

```dart
QPayException.authenticationFailed    // "AUTHENTICATION_FAILED"
QPayException.invoiceNotFound         // "INVOICE_NOTFOUND"
QPayException.invoicePaid             // "INVOICE_PAID"
QPayException.invoiceAlreadyCanceled  // "INVOICE_ALREADY_CANCELED"
QPayException.invoiceCodeInvalid      // "INVOICE_CODE_INVALID"
QPayException.invoiceLineRequired     // "INVOICE_LINE_REQUIRED"
QPayException.paymentNotFound         // "PAYMENT_NOTFOUND"
QPayException.paymentAlreadyCanceled  // "PAYMENT_ALREADY_CANCELED"
QPayException.paymentNotPaid          // "PAYMENT_NOT_PAID"
QPayException.permissionDenied        // "PERMISSION_DENIED"
QPayException.invalidAmount           // "INVALID_AMOUNT"
QPayException.minAmountErr            // "MIN_AMOUNT_ERR"
QPayException.maxAmountErr            // "MAX_AMOUNT_ERR"
QPayException.merchantNotFound        // "MERCHANT_NOTFOUND"
QPayException.merchantInactive        // "MERCHANT_INACTIVE"
QPayException.noCredentials           // "NO_CREDENDIALS"
QPayException.ebarimtNotRegistered    // "EBARIMT_NOT_REGISTERED"
QPayException.transactionRequired     // "TRANSACTION_REQUIRED"
// ... and more
```

## Flutter Integration Tips

### Display QR Code

The `qrImage` field in `InvoiceResponse` contains a base64-encoded PNG image:

```dart
import 'dart:convert';
import 'package:flutter/material.dart';

Widget buildQrImage(InvoiceResponse invoice) {
  final bytes = base64Decode(invoice.qrImage);
  return Image.memory(bytes);
}
```

### Open Bank App Deep Links

Use `url_launcher` to open bank app deep links from `InvoiceResponse.urls`:

```dart
import 'package:url_launcher/url_launcher.dart';

Future<void> openBankApp(Deeplink deeplink) async {
  final uri = Uri.parse(deeplink.link);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

// Show a list of available banks
Widget buildBankList(InvoiceResponse invoice) {
  return ListView.builder(
    itemCount: invoice.urls.length,
    itemBuilder: (context, index) {
      final bank = invoice.urls[index];
      return ListTile(
        leading: Image.network(bank.logo),
        title: Text(bank.name),
        subtitle: Text(bank.description),
        onTap: () => openBankApp(bank),
      );
    },
  );
}
```

### Payment Polling

Poll for payment status after showing the QR code:

```dart
import 'dart:async';

Future<bool> waitForPayment(QPayClient client, String invoiceId) async {
  for (var i = 0; i < 60; i++) {
    await Future.delayed(Duration(seconds: 5));

    final result = await client.checkPayment(PaymentCheckRequest(
      objectType: 'INVOICE',
      objectId: invoiceId,
    ));

    if (result.count > 0) {
      return true; // Payment received
    }
  }
  return false; // Timeout after 5 minutes
}
```

### Provider / Riverpod Setup

```dart
// Using a simple singleton
class QPayService {
  late final QPayClient _client;

  QPayService() {
    _client = QPayClient(QPayConfig(
      baseUrl: 'https://merchant.qpay.mn',
      username: 'USERNAME',
      password: 'PASSWORD',
      invoiceCode: 'CODE',
      callbackUrl: 'https://yourapp.com/callback',
    ));
  }

  QPayClient get client => _client;

  void dispose() => _client.close();
}
```

## API Reference

### QPayClient Methods

| Method | Description |
|---|---|
| `getToken()` | Authenticate and get a new token pair |
| `refreshToken()` | Refresh the current access token |
| `createInvoice(request)` | Create a full invoice with all options |
| `createSimpleInvoice(request)` | Create a simple invoice with minimal fields |
| `createEbarimtInvoice(request)` | Create an invoice with ebarimt (tax) info |
| `cancelInvoice(invoiceId)` | Cancel an existing invoice |
| `getPayment(paymentId)` | Get payment details by ID |
| `checkPayment(request)` | Check if a payment has been made |
| `listPayments(request)` | List payments with filters and pagination |
| `cancelPayment(paymentId, request)` | Cancel a card payment |
| `refundPayment(paymentId, request)` | Refund a card payment |
| `createEbarimt(request)` | Create an electronic tax receipt |
| `cancelEbarimt(paymentId)` | Cancel an electronic tax receipt |
| `close()` | Close the underlying HTTP client |

### Models

**Request models** (used as method arguments):
- `CreateInvoiceRequest` -- Full invoice creation
- `CreateSimpleInvoiceRequest` -- Simple invoice creation
- `CreateEbarimtInvoiceRequest` -- Invoice with tax info
- `PaymentCheckRequest` -- Check payment status
- `PaymentListRequest` -- List payments with filters
- `PaymentCancelRequest` -- Cancel a payment
- `PaymentRefundRequest` -- Refund a payment
- `CreateEbarimtRequest` -- Create a tax receipt

**Response models** (returned from methods):
- `TokenResponse` -- Authentication token pair
- `InvoiceResponse` -- Created invoice with QR code and deep links
- `PaymentDetail` -- Full payment information
- `PaymentCheckResponse` / `PaymentCheckRow` -- Payment check results
- `PaymentListResponse` / `PaymentListItem` -- Payment list results
- `EbarimtResponse` -- Tax receipt information

**Common models** (used in requests and responses):
- `Address` -- Physical address
- `SenderBranchData` -- Branch information
- `SenderStaffData` -- Staff information
- `InvoiceReceiverData` -- Invoice receiver info
- `Account` -- Bank account
- `Transaction` -- Invoice transaction
- `InvoiceLine` -- Invoice line item
- `EbarimtInvoiceLine` -- Tax invoice line item
- `TaxEntry` -- Tax/discount/surcharge entry
- `Deeplink` -- Bank app deep link
- `Offset` -- Pagination offset
- `EbarimtItem` -- Tax receipt line item
- `EbarimtHistory` -- Tax receipt history record

## License

MIT License. See [LICENSE](LICENSE) for details.
