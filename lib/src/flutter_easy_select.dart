part of '../flutter_easy_select.dart';

/// A utility class for creating selection dialogs in Flutter applications.
///
/// This class provides static methods for displaying modal bottom sheets
/// that allow users to select single or multiple items from a list.
class FlutterEasySelect {

  /// Displays a modal bottom sheet for selecting a single item from a list.
  ///
  /// The [context] parameter is the build context from which the modal
  /// will be displayed.
  ///
  /// The [items] parameter is a list of items of type [T] that the user can select from.
  ///
  /// The [itemBuilder] parameter is a function that defines how each item will be rendered.
  ///
  /// The [searchProperty] parameter is a function that extracts a searchable property
  /// from each item, allowing users to filter the list.
  ///
  /// The [title] parameter specifies the title displayed at the top of the modal.
  ///
  /// The [heightFactor] determines the height of the modal as a percentage of
  /// the screen height (default is 0.8).
  ///
  /// The [enableFreeText] parameter, if set to true, allows users to input
  /// custom text not in the list of items.
  ///
  /// The [isSearchEnabled] parameter, if set to true, enables a search field
  /// for filtering items in the list (default is true).
  ///
  /// The [freeTextSelected] callback is triggered when a user selects free text input.
  ///
  /// The [initialSelectedItem] parameter allows an optional item to be pre-selected.
  ///
  /// The [fieldDecoration] parameter provides optional decoration for the input field.
  ///
  /// Returns a [Future] that resolves to the selected item of type [T].
  static Future<T?> single<T>({
    required BuildContext context,
    required List<T> items,
    required Widget Function(T item) itemBuilder,
    required String Function(T item) searchProperty,
    required String title,
    double heightFactor = 0.8,
    bool enableFreeText = false,
    bool isSearchEnabled = true,
    void Function(String)? freeTextSelected,
    T? initialSelectedItem,
    InputDecoration? fieldDecoration,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * (heightFactor),
      ),
      builder: (BuildContext context) {
        return SingleSelectWidget<T>(
          items: items,
          itemBuilder: itemBuilder,
          searchProperty: searchProperty,
          title: title,
          enableFreeText: enableFreeText,
          isSearchEnable: isSearchEnabled,
          freeTextSelected: freeTextSelected,
          initialSelectedItem: initialSelectedItem,
          fieldDecoration: fieldDecoration,
        );
      },
    );
  }

  /// Displays a modal bottom sheet for selecting multiple items from a list.
  ///
  /// The [context] parameter is the build context from which the modal
  /// will be displayed.
  ///
  /// The [items] parameter is a list of items of type [T] that the user can select from.
  ///
  /// The [itemBuilder] parameter is a function that defines how each item will be rendered.
  ///
  /// The [searchProperty] parameter is a function that extracts a searchable property
  /// from each item, allowing users to filter the list.
  ///
  /// The [itemIdentifier] parameter is a function that provides a unique identifier
  /// for each item, useful for distinguishing between selections.
  ///
  /// The [title] parameter specifies the title displayed at the top of the modal.
  ///
  /// The [heightFactor] determines the height of the modal as a percentage of
  /// the screen height (default is 0.8).
  ///
  /// The [enableFreeText] parameter, if set to true, allows users to input
  /// custom text not in the list of items.
  ///
  /// The [isSearchEnabled] parameter, if set to true, enables a search field
  /// for filtering items in the list (default is true).
  ///
  /// The [freeTextSelected] callback is triggered when a user selects free text input.
  ///
  /// The [initialSelectedItems] parameter allows a list of items to be pre-selected.
  ///
  /// The [fieldDecoration] parameter provides optional decoration for the input field.
  ///
  /// Returns a [Future] that resolves to a list of selected items of type [T].
  static Future<List<T>?> multi<T>({
    required BuildContext context,
    required List<T> items,
    required Widget Function(T item) itemBuilder,
    required String Function(T item) searchProperty,
    required String Function(T item) itemIdentifier,
    required String title,
    double heightFactor = 0.8,
    bool enableFreeText = false,
    bool isSearchEnabled = true,
    void Function(String)? freeTextSelected,
    List<T>? initialSelectedItems,
    InputDecoration? fieldDecoration,
  }) {
    return showModalBottomSheet<List<T>>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * (heightFactor),
      ),
      builder: (BuildContext context) {
        return MultiSelectWidget<T>(
          items: items,
          itemBuilder: itemBuilder,
          searchProperty: searchProperty,
          itemIdentifier: itemIdentifier,
          title: title,
          enableFreeText: enableFreeText,
          isSearchEnable: isSearchEnabled,
          freeTextSelected: freeTextSelected,
          initialSelectedItems: initialSelectedItems,
          fieldDecoration: fieldDecoration,
        );
      },
    );
  }
}