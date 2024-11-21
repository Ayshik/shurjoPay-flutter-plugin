import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shurjopay_sdk/shurjopay_sdk.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo shurjoPaySDK",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: "Flutter Demo shurjoPaySDK"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late ShurjopaySdk shurjopaySdk;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Pay By shurjoPay SDK"),
          onPressed: () {
            onShurjopaySdk(context);
          },
        ),
      ),
    );
  }

  void onShurjopaySdk(BuildContext context) {
    RequiredRequestData requiredRequestData = requestData;
    requiredRequestData.onPrint();

    shurjopaySdk = ShurjopaySdk(
      onSuccess: (BuildContext context, ErrorSuccess errorSuccess) {
        switch (errorSuccess.esType) {
          case ESType.INTERNET_SUCCESS:
            debugPrint("DEBUG_LOG_PRINT: surjoPay SDK SUCCESS: ${errorSuccess.message}");
            return;
          case ESType.SUCCESS:
            debugPrint("DEBUG_LOG_PRINT: surjoPay SDK SUCCESS: ${errorSuccess.message}");
            onTransaction(errorSuccess.transactionInfo);
            return;
        }
        debugPrint("DEBUG_LOG_PRINT: surjoPay SDK SUCCESS: ${errorSuccess.esType.name}");
      },
      onFailed: (BuildContext context, ErrorSuccess errorSuccess) {
        switch (errorSuccess.esType) {
          case ESType.INTERNET_ERROR:
            debugPrint("DEBUG_LOG_PRINT: surjoPay SDK ERROR: ${errorSuccess.message}");
            return;
          case ESType.HTTP_CANCEL:
            debugPrint("DEBUG_LOG_PRINT: surjoPay SDK ERROR: ${errorSuccess.message}");
            return;
          case ESType.ERROR:
            debugPrint("DEBUG_LOG_PRINT: surjoPay SDK ERROR: ${errorSuccess.message}");
            return;
        }
        debugPrint("DEBUG_LOG_PRINT: surjoPay SDK ERROR: ${errorSuccess.message}");
      },
    );

    // Show the payment page in a WebView after successful request setup
    showPaymentPage();
  }

  void onTransaction(TransactionInfo? transactionInfo) {
    debugPrint("DEBUG_LOG_PRINT: surjoPay SDK SUCCESS TransactionInfo:");
    transactionInfo?.onPrint();
  }

  void showPaymentPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentWebViewPage()),
    );
  }

  RequiredRequestData get requestData {
    int orderId = Random().nextInt(1000);
    RequiredRequestData requiredRequestData = RequiredRequestData(
      username: "sp_sandbox",
      password: "pyyk97hu&6u6",
      prefix: "NOK",
      currency: "BDT",
      amount: 1,
      orderId: "NOK$orderId",
      discountAmount: 0,
      discPercent: 0,
      customerName: "customer name",
      customerPhone: "01711486915",
      customerEmail: null,
      customerAddress: "customer address",
      customerCity: "customer city",
      customerState: null,
      customerPostcode: "1212",
      customerCountry: null,
      returnUrl: "https://www.sandbox.shurjopayment.com/response",
      cancelUrl: "https://www.sandbox.shurjopayment.com/response",
      clientIp: "127.0.0.1",
      value1: null,
      value2: null,
      value3: null,
      value4: null,
    );
    return requiredRequestData;
  }
}

class PaymentWebViewPage extends StatelessWidget {
  const PaymentWebViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Page"),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://www.sandbox.shurjopayment.com"),
        ),
      ),
    );
  }
}
