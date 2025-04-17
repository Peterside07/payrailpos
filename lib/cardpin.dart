import 'package:flutter/material.dart';
import 'package:topwisemp35p/topwisemp35p.dart';

import 'keyboard.dart';

class CardPin extends StatefulWidget {
  const CardPin({super.key});

  @override
  State<CardPin> createState() => _CardPinState();
}

class _CardPinState extends State<CardPin> {
  final TextEditingController _pinController = TextEditingController();

  final _topwisemp35pPlugin = Topwisemp35p();
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
    Navigator.pop(context, _pinController.text);
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
        title: Text("Card Pin"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter Card Pin"),
            SizedBox(height: 20),
            TextField(
              controller: _pinController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Card Pin',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                proceed();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
