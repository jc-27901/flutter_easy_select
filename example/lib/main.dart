import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_select/flutter_easy_select.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Easy Select Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Easy Select Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String? _selectedFruit;
  List<Country> _selectedCountries = [];

  final List<String> _fruits = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape'
  ];

  final List<Country> _countries = [
    Country(name: 'United States', code: 'US', population: 331002651),
    Country(name: 'China', code: 'CN', population: 1439323776),
    Country(name: 'India', code: 'IN', population: 1380004385),
    Country(name: 'Indonesia', code: 'ID', population: 273523615),
    Country(name: 'Pakistan', code: 'PK', population: 220892340),
    Country(name: 'Brazil', code: 'BR', population: 212559417),
    Country(name: 'Nigeria', code: 'NG', population: 206139589),
    Country(name: 'Bangladesh', code: 'BD', population: 164689383),
    Country(name: 'Russia', code: 'RU', population: 145934462),
    Country(name: 'Mexico', code: 'MX', population: 128932753),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _selectFruit,
              child: const Text('Select a Fruit'),
            ),
            const SizedBox(height: 20),
            Text(
              'Selected Fruit: ${_selectedFruit ?? "None"}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _selectCountries,
              child: const Text('Select Countries'),
            ),
            const SizedBox(height: 20),
            Text(
              'Selected Countries:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            ..._selectedCountries.map((country) => Text(country.name)),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFruit() async {
    final String? result = await FlutterEasySelect.single<String>(
      context: context,
      items: _fruits,
      itemBuilder: (fruit) => ListTile(
        title: Text(fruit),
        leading: CircleAvatar(
          child: Text(fruit[0]),
        ),
      ),
      searchProperty: (fruit) => fruit,
      title: 'Select a Fruit',
      initialSelectedItem: _selectedFruit,
      enableFreeText: false,
      freeTextSelected: (value) {
        if (kDebugMode) {
          print('Custom fruit entered: $value');
        }
      },
    );

    if (result != null) {
      setState(() {
        _selectedFruit = result;
      });
    }
  }

  Future<void> _selectCountries() async {
    final List<Country>? results = await FlutterEasySelect.multi<Country>(
      context: context,
      items: _countries,
      itemBuilder: (country) => ListTile(
        title: Text(country.name),
        subtitle: Text('Population: ${country.population}'),
        leading: CircleAvatar(
          child: Text(country.code),
        ),
      ),
      searchProperty: (country) => country.name,
      itemIdentifier: (country) => country.code,
      title: 'Select Countries',
      isSearchEnabled: true,
      initialSelectedItems: _selectedCountries,
    );

    if (results != null) {
      setState(() {
        _selectedCountries = results;
      });
    }
  }
}

class Country {
  final String name;
  final String code;
  final int population;

  Country({required this.name, required this.code, required this.population});
}
