part of '../flutter_easy_select.dart';

/// A widget that allows users to select multiple items from a list with optional search and free-text functionality.
///
/// The `MultiSelectWidget` supports customizable item display, search capabilities,
/// and free-text input. Selected items can be easily managed and retrieved.
class MultiSelectWidget<T> extends StatefulWidget {
  /// Creates a `MultiSelectWidget` with the specified options and configurations.
  ///
  /// - [items]: The list of items to display for selection.
  /// - [itemBuilder]: A function that returns a widget to display each item.
  /// - [searchProperty]: A function that returns the searchable property of each item as a string.
  /// - [itemIdentifier]: A function that returns a unique identifier for each item.
  /// - [title]: The title of the selection modal or widget.
  /// - [enableFreeText]: Whether free-text input is allowed. Defaults to `false`.
  /// - [isSearchEnable]: Whether the search bar is enabled. Defaults to `true`.
  /// - [freeTextSelected]: A callback that receives the free-text input when selected.
  /// - [initialSelectedItems]: A list of items that are initially selected. Defaults to `null`.
  /// - [fieldDecoration]: Custom decoration for the search input field. Defaults to `null`.
  const MultiSelectWidget({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.searchProperty,
    required this.title,
    required this.itemIdentifier,
    this.enableFreeText = false,
    this.isSearchEnable = true,
    this.freeTextSelected,
    this.initialSelectedItems,
    this.fieldDecoration,
  });

  /// The list of items available for selection.
  final List<T> items;

  /// A builder function that defines how each item should be displayed in the list.
  final Widget Function(T item) itemBuilder;

  /// A function that returns the searchable property of each item.
  final String Function(T item) searchProperty;

  /// A function that provides a unique identifier for each item.
  final String Function(T item) itemIdentifier;

  /// Indicates whether free-text input is enabled. Defaults to `false`.
  final bool enableFreeText;

  /// Indicates whether the search functionality is enabled. Defaults to `true`.
  final bool isSearchEnable;

  /// The title displayed at the top of the selection widget.
  final String title;

  /// A callback function invoked when free-text input is selected.
  final void Function(String)? freeTextSelected;

  /// A list of items that are pre-selected when the widget is initialized.
  final List<T>? initialSelectedItems;

  /// Custom decoration for the search input field.
  final InputDecoration? fieldDecoration;

  @override
  State<MultiSelectWidget<T>> createState() => _MultiSelectWidgetState<T>();
}

class _MultiSelectWidgetState<T> extends State<MultiSelectWidget<T>> {
  /// Stores the identifiers of selected items.
  late Set<String> _selectedItemIds;

  /// The sorted list of items, with initially selected items prioritized.
  late List<T> _sortedItems;

  /// The current search query entered by the user.
  String _searchQuery = '';

  /// The list of items filtered based on the search query.
  late List<T> _filteredItems;

  /// Indicates whether free-text input has been selected.
  bool _freeTextSelected = false;

  /// Indicates whether search functionality is enabled.
  late bool isSearchEnable;

  /// The title of the widget.
  late String title;

  /// Controller for managing the text entered in the search bar.
  final TextEditingController _textController = TextEditingController();

  /// Focus node for managing the focus state of the search bar.
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedItemIds = Set<String>.from(widget.initialSelectedItems
        ?.map((item) => widget.itemIdentifier(item)) ??
        []);
    isSearchEnable = widget.isSearchEnable;
    title = widget.title;
    _sortedItems = _getSortedItems();
    _filteredItems = List<T>.from(_sortedItems);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadiusTopLeft24,
      child: Scaffold(
        body: Column(
          children: [
            BaseBottomSheetHeader(title: title),
            if (isSearchEnable) _buildSearchBar(),
            if (widget.enableFreeText && _searchQuery.isNotEmpty)
              _buildFreeTextOption(),
            Expanded(
              child: _filteredItems.isEmpty
                  ? _buildEmptyState()
                  : _buildCheckboxList(),
            ),
          ],
        ),
        bottomNavigationBar: _buildApplyButton(),
      ),
    );
  }

  /// Builds the search bar for filtering items.
  Widget _buildSearchBar() {
    return Padding(
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
    );
  }

  /// Builds the free-text input option as a selectable checkbox.
  Widget _buildFreeTextOption() {
    return CheckboxListTile(
      value: _freeTextSelected,
      onChanged: (value) {
        setState(() {
          _freeTextSelected = value ?? false;
          if (_freeTextSelected) {
            widget.freeTextSelected?.call(_searchQuery);
          }
        });
      },
      title: Text(_searchQuery),
    );
  }

  /// Builds a widget to display when no items match the search query.
  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No record(s) found',
        style: TextStyle(color: Theme.of(context).hintColor),
      ),
    );
  }

  /// Builds the list of items with checkboxes for selection.
  Widget _buildCheckboxList() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          final itemId = widget.itemIdentifier(item);
          return CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: _selectedItemIds.contains(itemId),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  _selectedItemIds.add(itemId);
                } else {
                  _selectedItemIds.remove(itemId);
                }
              });
            },
            title: widget.itemBuilder(item),
          );
        },
      ),
    );
  }

  /// Returns a sorted list of items with pre-selected items at the top.
  List<T> _getSortedItems() {
    final initialSelectedItems = widget.initialSelectedItems ?? [];
    final initialSelectedIds =
    initialSelectedItems.map(widget.itemIdentifier).toSet();

    return [
      ...initialSelectedItems,
      ...widget.items.where(
              (item) => !initialSelectedIds.contains(widget.itemIdentifier(item)))
    ];
  }

  /// Applies the current selection and returns the selected items or free-text input.
  void _onApply() {
    if (_freeTextSelected) {
      Navigator.pop(context, _searchQuery);
    } else {
      final selectedItems = widget.items
          .where(
              (item) => _selectedItemIds.contains(widget.itemIdentifier(item)))
          .toList();
      Navigator.pop(context, selectedItems);
    }
  }

  /// Filters the list of items based on the current search query.
  void _filterItems() {
    _filteredItems = _sortedItems.where((item) {
      final String searchText = widget.searchProperty(item).toLowerCase();
      return searchText.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  /// Builds the apply button to confirm the selection.
  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.maxFinite, 36.0),
            backgroundColor: Theme.of(context).colorScheme.primary),
        onPressed: _onApply,
        child: Text(
          'Apply',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}
