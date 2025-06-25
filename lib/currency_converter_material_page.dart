import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyConverterMaterialPage extends StatefulWidget {
  const CurrencyConverterMaterialPage({super.key});
  @override
  State createState() => _CurrencyConverterMaterialPageState();
}

class _CurrencyConverterMaterialPageState extends State {
  double result = 0;
  TextEditingController textEditingController = TextEditingController();
  Map<String, dynamic> _rates = {};
  List<String> _items = [];
  var _dropdownvalue = "";

  void fetchdata() async {
    var url = Uri.http('api.frankfurter.app', 'latest', {'from': 'USD'});
    final res = await http.get(url);
    final map = jsonDecode(res.body);

    setState(() {
      _rates = map['rates'];
      _items = _rates.keys.toList();
      _dropdownvalue = _items.first;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(width: 1.5, style: BorderStyle.solid),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 1),
      appBar: AppBar(
        title: Text(
          "Currency Converter",
          style: TextStyle(color: Colors.white, fontSize: 35),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextField(
                controller: textEditingController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.attach_money,
                    color: Colors.black,
                  ),
                  hintText: "Please enter the amount in USD",
                  hintStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            DropdownButton(
              value: _dropdownvalue,
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              items: _items.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item, style: TextStyle(color: Colors.blue)),
                );
              }).toList(),
              onChanged: (String? newvalue) {
                setState(() {
                  _dropdownvalue = newvalue!;
                });
              },
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(50, 16, 50, 16),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    result =
                        double.parse(textEditingController.text) *
                        _rates[_dropdownvalue];
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Convert", style: TextStyle(fontSize: 25)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
