part of '../flutter_easy_select.dart';

class SingleSelectWidget<T> extends StatefulWidget {
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

  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final String Function(T item) searchProperty;
  final bool enableFreeText;
  final bool isSearchEnable;
  final String title;
  final void Function(String)? freeTextSelected;
  final T? initialSelectedItem;
  final InputDecoration? fieldDecoration;

  @override
  State<SingleSelectWidget<T>> createState() => _SingleSelectWidgetState<T>();
}

class _SingleSelectWidgetState<T> extends State<SingleSelectWidget<T>> {
  T? _selectedItem;
  String _searchQuery = '';
  late List<T> _filteredItems;
  bool _freeTextSelected = false;
  late bool isSearchEnable;
  late String title;
  final TextEditingController _textController = TextEditingController();
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

  /// inorder to show selected item at top.
  List<T> _getOrderedItems() {
    if (_selectedItem != null) {
      final itemIndex = widget.items.indexWhere((item) =>
      widget.searchProperty(item) ==
          widget.searchProperty(_selectedItem as T));
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
            BaseBottomSheetHeader(title: title),
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
            (_filteredItems.isEmpty)
                ? const Flexible(
                child: Center(
                  child: Text('No record(s) found.'),
                ))
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

  void _onApply() {
    if (_freeTextSelected) {
      Navigator.pop(context, _searchQuery);
    } else if (_selectedItem != null) {
      Navigator.pop(context, _selectedItem);
    }
  }

  void _filterItems() {
    _filteredItems = _getOrderedItems().where((item) {
      final String searchText = widget.searchProperty(item).toLowerCase();
      return searchText.contains(_searchQuery.toLowerCase());
    }).toList();
  }
}