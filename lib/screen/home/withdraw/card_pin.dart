import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutteremv/flutteremv.dart';
import 'package:payrailpos/theme/colors.dart';
import 'package:payrailpos/widgets/pos/keyboard.dart';

class CardPin extends StatefulWidget {
  const CardPin({super.key});

  @override
  State<CardPin> createState() => _CardPinState();
}

class _CardPinState extends State<CardPin> {
  final TextEditingController _pinController = TextEditingController();

  final _topwisemp35pPlugin = Flutteremv();
  var amountController = "";

  void startkeyboarda() {
    startKeyboard(
        onchange: result,
        proceed: proceed,
        cancel: () {
          Navigator.pop(context);
        });
  }

  Future<void> proceed() async {
    stopKeyboard();
    print("PIN entered: ${_pinController.text}");
    _topwisemp35pPlugin.enterpin(_pinController.text);
    startKeyboard();
    // loader(Get.context, "Reading Card");
  }

  void result(String value) {
    if (value != "delete") {
      amountController += value;
    } else {
      if (amountController.isNotEmpty &&
          amountController != "0" &&
          amountController.toString().length > 1) {
        amountController =
            amountController.substring(0, amountController.length - 1);
      } else {
        amountController = "";
      }
    }
    _pinController.text = amountController;
    setState(() {});
  }

  @override
  void initState() {
    startkeyboarda();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Card Pin"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter Card Pin"),
            const SizedBox(height: 20),
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.none,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Card Pin',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                proceed();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class Carpin extends StatefulWidget {
  final String amount;
  const Carpin({Key? key, required this.amount}) : super(key: key);

  @override
  _CarpinState createState() => _CarpinState();
}

class _CarpinState extends State<Carpin> {
  int position = 0;
  String amountController = "";
  final _topwisemp35pPlugin = Flutteremv();

  @override
  void initState() {
    super.initState();
    _topwisemp35pPlugin.startkeyboard(
      onchange: result,
      proceed: proceed,
      cancel: cancel,
    );
  }

  @override
  void dispose() {
    _topwisemp35pPlugin.stopkeyboard();
    super.dispose();
  }

  void result(String value) {
    if (value != "delete") {
      if (amountController.length < 4) {
        amountController += value;
      }
    } else {
      if (amountController.isNotEmpty) {
        amountController =
            amountController.substring(0, amountController.length - 1);
      }
    }
    setState(() {});
  }

  void proceed() {
    Navigator.pop(context, amountController);
    _topwisemp35pPlugin.stopkeyboard();
  }

  void cancel() {
    _topwisemp35pPlugin.cancelcardprocess();
    Navigator.pop(context);
  }

  Color boxColor(int index) {
    return amountController.length > index
        ? AppColors.PRIMARY_COLOR // Green
        : const Color(0xFFE5E5E5); // Gray
  }

  Widget buildPinBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 50,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: boxColor(index),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black12,
              width: 1.5,
            ),
          ),
          child: Text(
            amountController.length > index ? "●" : "",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "₦${widget.amount}.00",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Enter 4-digit Card PIN",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 30),
            if (position == 0) buildPinBoxes(),
            if (position >= 1) ...[
              const SizedBox(height: 20),
              Text(
                position == 1 ? 'Validating...' : 'Processing transaction',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
