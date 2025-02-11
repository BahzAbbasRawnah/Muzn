import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/models/student_progress_history.dart';
import 'package:quran/quran.dart' as quran;
import 'package:intl/intl.dart';
import 'package:jhijri/jHijri.dart';

class HistoryItem extends StatelessWidget {
  final StudentProgressHistory progressHistory;

  const HistoryItem({
    super.key,
    required this.progressHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Add elevation for a shadow effect
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8), // Add margin for spacing
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Add padding inside the card
        child: 
            /// 📌 **Column for Text Content**
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 📝 **Homework Notes (Title)**
                Text(
                  progressHistory.category_name!,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Divider(color: Colors.black),
                Row(
                  children: [
                    _buildItem(
                      context,
                      "from_surah".tr(context) +
                          quran.getSurahNameArabic(progressHistory.homework.startSurahNumber),
                    ),
                    _buildItem(
                      context,
                      "to_surah".tr(context) +
                          quran.getSurahNameArabic(progressHistory.homework.endSurahNumber),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildItem(
                      context,
                      "from_ayah".tr(context) +
                          progressHistory.homework.startAyahNumber.toString(),
                    ),
                    _buildItem(
                      context,
                      "to_ayah".tr(context) +
                          progressHistory.homework.endAyahNumber.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            DateFormat('yyyy-MM-dd')
                                    .format(progressHistory.homework.homeworkDate) +
                                ' مــ',
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            JHijri(fDate: progressHistory.homework.homeworkDate).toString() +
                                ' هــ ',
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                  const SizedBox(height: 10),
                  Divider(),
                Text(
                    'student_score'.tr(context),
                    style: Theme.of(context).textTheme.displayLarge,
                    overflow: TextOverflow.ellipsis,
                  ),

                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                        Text('reading_wrongs'.tr(context),
                        style: Theme.of(context).textTheme.displaySmall,
                        
                        ),
                         Text(progressHistory.studentProgress.readingWrong.toString(),
                        style: Theme.of(context).textTheme.displaySmall
                        )
                          ],
                        ),
                         Column(
                          children: [
                        Text('tajweed_wrongs'.tr(context),
                        style: Theme.of(context).textTheme.displaySmall,
                        
                        ),
                         Text(progressHistory.studentProgress.tajweedWrong.toString(),
                        style: Theme.of(context).textTheme.displaySmall
                        )
                          ],
                        ),
                         Column(
                          children: [
                        Text('tashkeel_wrongs'.tr(context),
                        style: Theme.of(context).textTheme.displaySmall,
                        
                        ),
                         Text(progressHistory.studentProgress.tashqeelWrong.toString(),
                        style: Theme.of(context).textTheme.displaySmall
                        )
                          ],
                        )
                       
                      ],
                    ),
      const SizedBox(height: 10),
                  Divider(),
                Text(
                    'student_rating'.tr(context),
                    style: Theme.of(context).textTheme.displayLarge,
                    overflow: TextOverflow.ellipsis,
                  ),

                    const SizedBox(height: 10),
                                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                        Text('reading_rating'.tr(context),
                        style: Theme.of(context).textTheme.displaySmall,
                        
                        ),
                         Text(progressHistory.studentProgress.readingRating.translate(context),
                        style: Theme.of(context).textTheme.displaySmall
                        )
                          ],
                        ),
                         Column(
                          children: [
                        Text('review_rating'.tr(context),
                        style: Theme.of(context).textTheme.displaySmall,
                        
                        ),
                         Text(progressHistory.studentProgress.reviewRating.translate(context),
                        style: Theme.of(context).textTheme.displaySmall
                        )
                          ],
                        ),
                         Column(
                          children: [
                        Text('telawah_rating'.tr(context),
                        style: Theme.of(context).textTheme.displaySmall,
                        
                        ),
                         Text(progressHistory.studentProgress.telawahRating.translate(context),
                        style: Theme.of(context).textTheme.displaySmall
                        )
                          ],
                        )
                       
                      ],
                    ),
                
              ],
            ),

        
         
      ),
    );
  }

  /// 🔹 **Helper Method to Create Rows with Two Text Widgets**
  Widget _buildItem(BuildContext context, String titleText) {
    return Expanded(
      child: Text(
        titleText,
        style: Theme.of(context).textTheme.displayMedium,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}