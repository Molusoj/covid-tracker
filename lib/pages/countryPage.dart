import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  List countryData;
  fetchCountryData() async {
    final String url = 'https://corona.lmao.ninja/v2/countries?sort=cases';
    http.Response response = await http.get(url);
    setState(() {
      countryData = json.decode((response.body));
    });
  }

  @override
  void initState() {
    fetchCountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Country Stats')),
        body: countryData == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    height: 130,
                    margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Colors.grey[100],
                          blurRadius: 10,
                          offset: Offset(0, 30))
                    ]),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                countryData[index]['country'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Image.network(
                                countryData[index]['countryInfo']['flag'],
                                height: 50,
                                width: 60,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Text('CONFIRMED: ' + countryData[index]['cases'].toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
                                Text('ACTIVE: ' + countryData[index]['active'].toString(),style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
                                Text('RECOVERED: ' + countryData[index]['recovered'].toString(),style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),),
                                Text('DEATHS: ' + countryData[index]['deaths'].toString(),style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),),

                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: countryData == null ? 0 : countryData.length,
              ));
  }
}
