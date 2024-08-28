import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:http/http.dart';
class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  String btcValue = '?';
  String ethValue = '?';
  String ltcValue = '?';

  DropdownButton<String> andriodDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for(String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropdownItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value!;
            getData();
          });
        });
  }

  CupertinoPicker iOSPicker() {

    List<Text> pickerItems = [];
    for(String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.transparent,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  Future<void> getData() async {
    CoinData coinData = CoinData();
   Map<String, String> data = await coinData.getCoinData(selectedCurrency);
    setState(() {
      btcValue = data['BTC']!;
      ethValue = data['ETH']!;
      ltcValue = data['LTC']!;
    });
    print('BTC: $btcValue, ETH: $ethValue, LTC: $ltcValue');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              cryptoCard('BTC', btcValue, selectedCurrency),
              cryptoCard('ETH', ethValue, selectedCurrency),
              cryptoCard('LTC', ltcValue, selectedCurrency)
            ],
          ),

          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : andriodDropdown(),
          ),
        ],
      ),
    );
  }
  Card cryptoCard(String crypto, String value, String currency) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $crypto = $value $currency',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Platform.isIOS ? iOSPicker() : andriodDropdown()

