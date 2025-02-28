import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muzn/app_localization.dart';

class CustomAyahDropdown extends StatelessWidget {
  final String label;
  final int? selectedAyah;
  final int? maxAyah;
  final ValueChanged<int?>? onChanged;
  final bool isExpanded;

  const CustomAyahDropdown({
    Key? key,
    required this.label,
    required this.selectedAyah,
    required this.maxAyah,
    required this.onChanged,
    this.isExpanded = true,
  }) : super(key: key);

  List<DropdownMenuItem<int>> _buildAyahItems() {
    if (maxAyah == null) return [];
    return List.generate(maxAyah!, (index) {
      final ayahNumber = index + 1;
      return DropdownMenuItem<int>(
        value: ayahNumber,
        child: Text(
          ayahNumber.toString(),style: GoogleFonts.amiriQuran()

        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label.trans(context),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: onChanged != null 
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<int>(
                value: selectedAyah,
                isExpanded: isExpanded,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: onChanged != null 
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor,
                ),
                items: _buildAyahItems(),
                onChanged: onChanged,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: onChanged != null 
                      ? Theme.of(context).textTheme.bodyMedium?.color
                      : Theme.of(context).disabledColor,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                hint: Text('1',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
