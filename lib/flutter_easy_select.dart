/// A Flutter library that provides customizable and easy-to-use single and multi-select widgets.
///
/// The `flutter_easy_select` package includes widgets for single and multiple
/// selections, customizable bottom sheets, and reusable common components.
library flutter_easy_select;

import 'package:flutter/material.dart';

/// Contains the core logic and base widgets for the `flutter_easy_select` package.
part 'src/flutter_easy_select.dart';

/// Provides the implementation for single-select widgets.
///
/// These widgets allow users to select one option from a list.
part 'src/single_select_widget.dart';

/// Provides the implementation for multi-select widgets.
///
/// These widgets allow users to select multiple options from a list.
part 'src/multi_select_widget.dart';

/// Contains shared, reusable components for the package.
///
/// Common widgets like headers and utility methods are defined here.
part 'src/common_widgets.dart';
