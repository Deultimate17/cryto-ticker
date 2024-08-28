import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'NGN'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '431BEBE4-103C-4940-86A4-9E53A3B66C92';


class CoinData {


  Future<Map<String,String>> getCoinData(String selectedCurrency) async {
    Map<String,String> crytoRates = {};
    for (String crypto in cryptoList) {
      String url = '$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey';
      http.Response response = await http.get(Uri.parse(Uri.encodeFull(url)));
      if (response.statusCode == 200) {
        String data = response.body;
        print(response.body);
        var decodeData = jsonDecode(data);
        double rate = decodeData['rate'];
        crytoRates[crypto] = rate.toStringAsFixed(0);
      } else {
        crytoRates[crypto] = '?';
        print(response.statusCode);
      }
    }
    return crytoRates;
    }

}
