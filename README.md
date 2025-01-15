# Flutter Easy Select

[![Pub Version](https://img.shields.io/pub/v/flutter_easy_select)](https://pub.dev/packages/flutter_easy_select)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A powerful, customizable Flutter package that simplifies item selection and filtering in your applications. Whether you need single or multi-select functionality, Flutter Easy Select provides an intuitive and elegant solution with support for both simple data types and complex objects.

## Features

- 🎯 **Single Selection Mode**: Simple one-item selection with a clean interface
- ✨ **Multi-Selection Support**: Select multiple items with ease
- 🔍 **Smart Search**: Built-in search functionality with customizable search properties
- ✏️ **Custom Text Input**: Option to add custom text entries in single selection mode
- 🎨 **Customizable Item Builder**: Create your own item layouts using custom widgets
- 🎭 **Pre-selection Support**: Initialize with pre-selected items
- 🔄 **Generic Type Support**: Works with both simple types and custom objects

## Demo
![easySelect](https://github.com/user-attachments/assets/a0d1ce95-031e-47f0-95ea-f068ec091630)


## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_easy_select: ^1.0.0
```

Then run:

```bash
$ flutter pub get
```

## Usage

### Basic String Selection

```dart
/// Define a list of items
final List<String> _fruits = [
  'Apple',
  'Banana',
  'Cherry',
  'Date',
  'Elderberry',
  'Fig',
  'Grape'
];

// Single Selection
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
    print('Custom fruit entered: $value');
  },
);
```

### Complex Object Selection

```dart
/// Define a custom class
class Country {
  final String name;
  final String code;
  final int population;

  Country({
    required this.name,
    required this.code,
    required this.population,
  });
}

/// Create a list of complex objects
final List<Country> _countries = [
  Country(name: 'United States', code: 'US', population: 331002651),
  Country(name: 'China', code: 'CN', population: 1439323776),
  Country(name: 'India', code: 'IN', population: 1380004385),
  // ... more countries
];

// Multi Selection with Complex Objects
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
```

## Properties

### Common Properties

| Property | Type | Description |
|----------|------|-------------|
| context | `BuildContext` | Flutter build context |
| items | `List<T>` | List of items to display |
| itemBuilder | `Widget Function(T)` | Builder function for item UI |
| searchProperty | `String Function(T)` | Function to get searchable property |
| title | `String` | Dialog title |
| isSearchEnabled | `bool` | Enable search functionality |

### Single Selection Properties

| Property | Type | Description |
|----------|------|-------------|
| initialSelectedItem | `T?` | Pre-selected item |
| enableFreeText | `bool` | Allow custom text input |
| freeTextSelected | `Function(String)?` | Callback for custom text entry |

### Multi Selection Properties

| Property | Type | Description |
|----------|------|-------------|
| initialSelectedItems | `List<T>?` | Pre-selected items |
| itemIdentifier | `String Function(T)` | Function to get unique identifier |

## Contributing

Contributions are welcome! If you find a bug or want to contribute:

1. Open an issue to discuss proposed changes
2. Fork the repository
3. Create your feature branch (`git checkout -b feature/amazing-feature`)
4. Commit your changes (`git commit -m 'Add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package helpful, please give it a ⭐️ on [GitHub](your-github-repo-link)!

For issues, feature requests, or questions, please [open an issue](your-github-repo-link/issues).
