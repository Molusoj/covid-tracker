import 'dart:convert';

import 'package:covid_tracker/pages/countryPage.dart';
import 'package:covid_tracker/panels/infopanel.dart';
import 'package:covid_tracker/panels/mostaffectedcountries.dart';
import 'package:covid_tracker/panels/worldwidepanel.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import './datasource.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map worldData;

  fetchWorldWideData() async {
    final String url = 'https://corona.lmao.ninja/v2/all';
    http.Response response = await http.get(url);
    setState(() {
      worldData = json.decode((response.body));
    });
  }

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
    fetchWorldWideData();
    fetchCountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Theme.of(context).brightness==Brightness.light? Icons.lightbulb_outline: Icons.highlight),
          onPressed: (){ 
            DynamicTheme.of(context).setBrightness((Theme.of(context).brightness==Brightness.light? Brightness.dark : Brightness.light)); 
          },)
        ],
        centerTitle: false,
        title: Text('COVID-19 TRACKER'),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 100,
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            color: Colors.orange[100],
            child: Text(
              DataSource.quote,
              style: TextStyle(
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Worldwide',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CountryPage()));
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryBlack,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Regional',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )),
                ),
              ],
            ),
          ),
          worldData == null
              ? CircularProgressIndicator()
              : WorldWidePanel(
                  worldData: worldData,
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Most Affected Countries',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          countryData == null
              ? Container()
              : MostAffectedPanel(
                  countryData: countryData,
                ),
          SizedBox(
            height: 20,
          ),
          InfoPanel(),
          SizedBox(
            height: 50,
          ),
          Center(
              child: Text(
            'WE ARE HERE TOGETHER',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          )),
          SizedBox(
            height: 50,
          ),
        ],
      )),
    );
  }
}
