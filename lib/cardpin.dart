import 'package:flutter/material.dart';

class CardPin extends StatefulWidget {
  const CardPin({super.key});

  @override
  State<CardPin> createState() => _CardPinState();
}

class _CardPinState extends State<CardPin> {
  final TextEditingController _pinController = TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                Navigator.pop(context, _pinController.text);
                
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}