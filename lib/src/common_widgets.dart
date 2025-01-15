part of '../flutter_easy_select.dart';

/// A widget that represents the header for a bottom sheet.
///
/// This widget displays a draggable indicator, a title, and a close button.
class BaseBottomSheetHeader extends StatelessWidget {
  /// Creates a [BaseBottomSheetHeader].
  ///
  /// - [title]: The title displayed in the header.
  const BaseBottomSheetHeader({super.key, required this.title});

  /// The title displayed at the top of the bottom sheet.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Adds spacing above the draggable indicator.
        const SizedBox(
          height: 16.0,
        ),

        /// Displays a draggable indicator at the top center of the header.
        Container(
          height: 4,
          width: 36,
          decoration: BoxDecoration(
            borderRadius: borderAll8,
            color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: 0.7,
                ),
          ),
        ),

        /// Adds spacing between the draggable indicator and the title row.
        const SizedBox(
          height: 4.0,
        ),

        /// Displays the title and close button.
        Padding(
          padding: left16Top10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Displays the title of the bottom sheet.
              Text(title),

              /// Displays a close button that dismisses the bottom sheet when pressed.
              TextButton(
                child: const CloseButton(),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A border radius with 24px rounding applied to the top-left and top-right corners.
const BorderRadius borderRadiusTopLeft24 = BorderRadius.only(
  topLeft: Radius.circular(24.0),
  topRight: Radius.circular(24.0),
);

/// A constant padding with 12px applied to all sides.
const EdgeInsets all12 = EdgeInsets.all(12);

/// A border radius with 8px rounding applied to all corners.
const BorderRadius borderAll8 = BorderRadius.all(Radius.circular(8));

/// A constant padding with 16px on the left and 10px on the top.
const EdgeInsets left16Top10 = EdgeInsets.only(left: 16, right: 10);
