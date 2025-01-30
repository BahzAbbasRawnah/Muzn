import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';

class LessonsItem extends StatelessWidget {
  final String title;
  final String surah;
  final String ayah;
  final String readingWrongs;
    final String tajweedWrongs;


  const LessonsItem({
    super.key,
    required this.title,
    required this.surah,
    required this.ayah,
    required this.readingWrongs,
    required this.tajweedWrongs
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
                  "from_surah".tr(context)+' : ' +surah,
                  style: Theme.of(context).textTheme.displaySmall
                ),
                const SizedBox(height: 4), // Spacing between texts
                Text(
                  "from_ayah".tr(context)+' : ' +ayah,
                 style: Theme.of(context).textTheme.displaySmall

                ),
Container(
  height: 1, // Line thickness
  margin: const EdgeInsets.symmetric(vertical: 16), // Add vertical spacing
  color: Colors.red, // Line color
)   ,
  Text(
                  "reading_wrongs".tr(context)+' : ' +readingWrongs,
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
          "to_surah".tr(context) + ' : ' + surah,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 4), // Spacing between texts
        Text(
          "to_ayah".tr(context) + ' : ' + ayah,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        Container(
          height: 1, // Line thickness
          margin: const EdgeInsets.symmetric(vertical: 16), // Add vertical spacing
          color: Colors.red, // Line color
        ),
        Text(
          "tajweed_wrongs".tr(context) + ' : ' + tajweedWrongs,
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