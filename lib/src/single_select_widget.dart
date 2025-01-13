part of '../flutter_easy_select.dart';

/// A widget that provides a single-selection functionality from a list of items.
///
/// This widget allows searching, free-text entry, and selecting one item at a time.
class SingleSelectWidget<T> extends StatefulWidget {
  /// Constructs a [SingleSelectWidget].
  ///
  /// - [items]: The list of items to display.
  /// - [itemBuilder]: A builder to define how each item should be displayed.
  /// - [searchProperty]: A function that returns a searchable property of the item.
  /// - [title]: The title displayed at the top of the widget.
  /// - [enableFreeText]: Allows the user to enter custom text if true. Defaults to false.
  /// - [isSearchEnable]: Enables the search bar if true. Defaults to true.
  /// - [freeTextSelected]: Callback invoked when free text is selected.
  /// - [initialSelectedItem]: The item initially selected when the widget is loaded.
  /// - [fieldDecoration]: Custom decoration for the search text field.
  const SingleSelectWidget({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.searchProperty,
    required this.title,
    this.enableFreeText = false,
    this.isSearchEnable = true,
    this.freeTextSelected,
    this.initialSelectedItem,
    this.fieldDecoration,
  });

  /// The list of items available for selection.
  final List<T> items;

  /// A function to build the widget representation of each item.
  final Widget Function(T item) itemBuilder;

  /// A function to return the searchable property of an item.
  final String Function(T item) searchProperty;

  /// Whether free-text entry is allowed.
  final bool enableFreeText;

  /// Whether search functionality is enabled.
  final bool isSearchEnable;

  /// The title displayed at the top of the widget.
  final String title;

  /// A callback invoked when the user selects free text.
  final void Function(String)? freeTextSelected;

  /// The item initially selected.
  final T? initialSelectedItem;

  /// Custom decoration for the search text field.
  final InputDecoration? fieldDecoration;

  @override
  State<SingleSelectWidget<T>> createState() => _SingleSelectWidgetState<T>();
}

class _SingleSelectWidgetState<T> extends State<SingleSelectWidget<T>> {
  /// The currently selected item.
  T? _selectedItem;

  /// The current search query entered by the user.
  String _searchQuery = '';

  /// The filtered list of items matching the search query.
  late List<T> _filteredItems;

  /// Whether free-text entry is currently selected.
  bool _freeTextSelected = false;

  /// Whether search functionality is enabled.
  late bool isSearchEnable;

  /// The title displayed at the top of the widget.
  late String title;

  /// Controller for the search text field.
  final TextEditingController _textController = TextEditingController();

  /// Focus node for the search text field.
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _selectedItem = widget.initialSelectedItem;
    isSearchEnable = widget.isSearchEnable;
    title = widget.title;
    _filteredItems = _getOrderedItems();
  }

  /// Orders the items to display the selected item at the top.
  List<T> _getOrderedItems() {
    if (_selectedItem != null) {
      final itemIndex = widget.items.indexWhere((item) =>
      widget.searchProperty(item) == widget.searchProperty(_selectedItem as T));
      if (itemIndex != -1) {
        final orderedList = List<T>.from(widget.items);
        orderedList.removeAt(itemIndex);
        return [_selectedItem as T, ...orderedList];
      }
    }
    return List<T>.from(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadiusTopLeft24,
      child: Scaffold(
        body: Column(
          children: [
            /// Displays the header with the provided title.
            BaseBottomSheetHeader(title: title),

            /// Displays the search bar if search is enabled.
            if (isSearchEnable)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  decoration: widget.fieldDecoration ??
                      const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Search'),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _filterItems();
                    });
                  },
                ),
              ),

            /// Displays the free-text entry option if enabled and a query is entered.
            if (widget.enableFreeText && _searchQuery.isNotEmpty) ...[
              RadioListTile<bool>(
                  value: true,
                  groupValue: _freeTextSelected,
                  onChanged: (_) {
                    setState(() {
                      _selectedItem = null;
                      _freeTextSelected = true;
                      widget.freeTextSelected?.call(_searchQuery);
                    });
                  },
                  title: Text(_searchQuery)),
            ],

            /// Displays the list of filtered items or an empty state if none match.
            (_filteredItems.isEmpty)
                ? const Flexible(
              child: Center(
                child: Text('No record(s) found.'),
              ),
            )
                : Expanded(
              child: ListView.builder(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return RadioListTile<T>(
                    value: item,
                    groupValue: _selectedItem,
                    title: widget.itemBuilder(item),
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value;
                        _freeTextSelected = false;
                      });
                      _onApply();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Applies the selection and returns the selected item or free text.
  void _onApply() {
    if (_freeTextSelected) {
      Navigator.pop(context, _searchQuery);
    } else if (_selectedItem != null) {
      Navigator.pop(context, _selectedItem);
    }
  }

  /// Filters the items based on the current search query.
  void _filterItems() {
    _filteredItems = _getOrderedItems().where((item) {
      final String searchText = widget.searchProperty(item).toLowerCase();
      return searchText.contains(_searchQuery.toLowerCase());
    }).toList();
  }
}
