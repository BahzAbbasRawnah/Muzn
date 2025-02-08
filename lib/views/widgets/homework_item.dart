import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';
import 'package:quran/quran.dart' as quran;

class HomeworksItem extends StatelessWidget {
  final String title;
  final int start_surah_number;
  final int start_ayah_number;
  final int end_surah_number;
 final int end_ayah_number;


  const HomeworksItem({
    super.key,
    required this.title,
    required this.start_surah_number,
    required this.start_ayah_number,
    required this.end_surah_number,
    required this.end_ayah_number
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Add elevation for a shadow effect
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 2), // Add margin for spacing
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Add padding inside the card
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Column: Homework Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium
                ),
                const SizedBox(height: 8), // Spacing between texts
                Text(
                  "from_surah".tr(context)+' : ' +quran.getSurahNameArabic(start_surah_number) ,
                  style: Theme.of(context).textTheme.displaySmall
                ),
                const SizedBox(height: 4), // Spacing between texts
                Text(
                  "from_ayah".tr(context)+' : ' +start_ayah_number.toString(),
                 style: Theme.of(context).textTheme.displaySmall

                ),

        ],
            ),

            // Right Column: Edit Button and Additional Info
   Stack(
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50), // Add space for the icon at the top
        Text(
          "to_surah".tr(context) + ' : ' + quran.getSurahNameArabic(end_surah_number),
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 4), // Spacing between texts
        Text(
          "to_ayah".tr(context) + ' : ' + end_ayah_number.toString(),
          style: Theme.of(context).textTheme.displaySmall,
        ),
      
      ],
    ),
    // Icon positioned in the top-left corner
    Positioned(
      left: -5,
      top: 0,
      child: IconButton(
        onPressed: () {
          // TODO: Navigate to the next page or perform an action
          print("Edit button clicked for $title");
        },
        icon: Icon(
          Icons.edit_note,size: 28,
        ),
      ),
    ),
  ],
)
          ],
        ),
      ),
    );
  }
}