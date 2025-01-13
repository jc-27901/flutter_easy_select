part of '../flutter_easy_select.dart';

class MultiSelectWidget<T> extends StatefulWidget {
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

  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final String Function(T item) searchProperty;
  final String Function(T item) itemIdentifier;
  final bool enableFreeText;
  final bool isSearchEnable;
  final String title;
  final void Function(String)? freeTextSelected;
  final List<T>? initialSelectedItems;
  final InputDecoration? fieldDecoration;

  @override
  State<MultiSelectWidget<T>> createState() => _MultiSelectWidgetState<T>();
}

class _MultiSelectWidgetState<T> extends State<MultiSelectWidget<T>> {
  late Set<String> _selectedItemIds;
  late List<T> _sortedItems;
  String _searchQuery = '';
  late List<T> _filteredItems;
  bool _freeTextSelected = false;
  late bool isSearchEnable;
  late String title;
  final TextEditingController _textController = TextEditingController();
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

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No record(s) found',
        style: TextStyle(color: Theme.of(context).hintColor),
      ),
    );
  }

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

  void _filterItems() {
    _filteredItems = _sortedItems.where((item) {
      final String searchText = widget.searchProperty(item).toLowerCase();
      return searchText.contains(_searchQuery.toLowerCase());
    }).toList();
  }

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