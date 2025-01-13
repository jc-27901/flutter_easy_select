part of '../flutter_easy_select.dart';

class BaseBottomSheetHeader extends StatelessWidget {
  const BaseBottomSheetHeader({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16.0,
        ),
        Container(
          height: 4,
          width: 36,
          decoration: BoxDecoration(
            borderRadius: borderAll8,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Padding(
          padding: left16Top10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
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

const BorderRadius borderRadiusTopLeft24 = BorderRadius.only(
  topLeft: Radius.circular(24.0),
  topRight: Radius.circular(24.0),
);

const EdgeInsets all12 = EdgeInsets.all(12);

const BorderRadius borderAll8 = BorderRadius.all(Radius.circular(8));
const EdgeInsets left16Top10 = EdgeInsets.only(left: 16, right: 10);