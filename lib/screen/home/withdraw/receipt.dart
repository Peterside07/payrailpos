import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutteremv/print.dart';
import 'package:get/get.dart';
import 'package:flutteremv/flutteremv.dart';
import 'package:payrailpos/screen/home/home_screen.dart'; // Assuming this is the package for printing

class ReceiptScreen extends StatefulWidget {
  final Map<String, dynamic>? cardData;
  final String? amount;
  final bool isSuccess;
  final String? message;

  const ReceiptScreen({
    super.key,
    this.cardData,
    this.amount,
    this.isSuccess = true,
    this.message,
  });

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
    late String base64string;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
        loadLogo();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


    Future<void> loadLogo() async {
    final ByteData assetByteData = await rootBundle.load("assets/images/logo.png");
    final Uint8List imagebytes = assetByteData.buffer.asUint8List();
    base64string = base64.encode(imagebytes);
  }

  void _printReceipt() {
    final maskedPan = widget.cardData?["applicationPrimaryAccountNumber"] ?? "************";
    final args = Print(
      base64image: base64string,
      marchantname: "PAYRAIL AGENCY",
      datetime: DateTime.now().toString(),
      terminalid: "2LUX4199",
      merchantid: "2LUXAA00000001",
      transactiontype: "CARD WITHDRAWAL",
      copytype: "Merchant",
      rrn: "561409897476",
      stan: '',
      pan: maskedPan,
      expiry: widget.cardData?["expirationDate"] ?? "--",
      transactionstatus: widget.isSuccess ? "APPROVED" : "DECLINED",
      responsecode: widget.isSuccess ? "00" : "55",
      message: widget.message ?? "Transaction processed",
      appversion: "1.5.3",
      amount: widget.amount ?? "0.00",
      bottommessage: "Thanks for using our service!",
      marchantaddress: '',
      serialno: widget.cardData?["interfaceDeviceSerialNumber"] ?? "083030303030303031",
      accountname: widget.cardData?["cardHolderName"] ?? "CARDHOLDER NAME",
    );
    Flutteremv().startprinting(args);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ListView(
         //   mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Approval Icon
              Icon(
                widget.isSuccess ? Icons.check_circle : Icons.cancel,
                color: widget.isSuccess ? Colors.green : Colors.red,
                size: 100,
              ),
              const SizedBox(height: 20),

              // Transaction Status
              Center(
                child: Text(
                  widget.isSuccess ? 'Transaction Approved' : 'Transaction Declined',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.isSuccess ? Colors.green : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Receipt Details
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   margin: const EdgeInsets.symmetric(horizontal: 20),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.2),
              //         spreadRadius: 2,
              //         blurRadius: 5,
              //       ),
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       _buildDetailRow('Amount', widget.amount ?? '0.00'),
              //       _buildDetailRow('Card Number', widget.cardData?['applicationPrimaryAccountNumber'] ?? '**** **** **** ****'),
              //       _buildDetailRow('Expiry', widget.cardData?['expirationDate'] ?? '--'),
              //       _buildDetailRow('Date/Time', DateTime.now().toString().substring(0, 19)),
              //       _buildDetailRow('Terminal ID', '2LUX4199'),
              //       _buildDetailRow('Status', widget.isSuccess ? 'APPROVED' : 'DECLINED'),
              //       if (widget.message != null) _buildDetailRow('Message', widget.message!),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 30),

              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _printReceipt,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Print Receipt',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.offAll(() => const HomeScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Home',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

