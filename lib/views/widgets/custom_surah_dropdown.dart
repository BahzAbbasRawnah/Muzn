import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/models/quran_model.dart';

class CustomSurahDropdown extends StatelessWidget {
  final String label;
  final Surah? selectedSurah;
  final List<Surah> surahList;
  final ValueChanged<Surah?> onChanged;
  final bool isExpanded;

  const CustomSurahDropdown({
    Key? key,
    required this.label,
    required this.selectedSurah,
    required this.surahList,
    required this.onChanged,
    this.isExpanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label.tr(context),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<Surah>(
                value: selectedSurah,
                isExpanded: isExpanded,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).primaryColor,
                ),
                items: surahList.map((Surah surah) {
                  return DropdownMenuItem<Surah>(
                    value: surah,
                    child: Text('(${surah.number}) ${surah.nameArabic}',
                          style: GoogleFonts.amiriQuran()
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
                style: Theme.of(context).textTheme.bodyMedium,
                padding: const EdgeInsets.symmetric(horizontal: 5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
