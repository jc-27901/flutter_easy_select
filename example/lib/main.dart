import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_select/flutter_easy_select.dart';

/// The entry point of the Flutter Easy Select Demo application.
void main() {
  runApp(const MyApp());
}

/// A widget that represents the root of the Flutter Easy Select Demo application.
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

/// The home page widget for the Flutter Easy Select Demo application.
class MyHomePage extends StatefulWidget {
  /// Creates an instance of [MyHomePage].
  ///
  /// The [title] parameter specifies the title of the page.
  const MyHomePage({super.key, required this.title});

  /// The title of the page.
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

/// The state for [MyHomePage], managing the selection of fruits and countries.
class MyHomePageState extends State<MyHomePage> {
  /// The selected fruit.
  String? _selectedFruit;

  /// The list of selected countries.
  List<Country> _selectedCountries = [];

  /// A list of fruits available for selection.
  final List<String> _fruits = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape'
  ];

  /// A list of countries available for selection.
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

  /// Displays a dialog to select a fruit from the list.
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

  /// Displays a dialog to select multiple countries from the list.
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

/// Represents a country with a name, code, and population.
class Country {
  /// Creates an instance of [Country].
  ///
  /// The [name], [code], and [population] parameters are required.
  Country({required this.name, required this.code, required this.population});

  /// The name of the country.
  final String name;

  /// The code of the country (e.g., "US" for United States).
  final String code;

  /// The population of the country.
  final int population;
}
