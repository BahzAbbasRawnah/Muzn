
import 'package:flutter/material.dart';
import 'package:muzn/views/widgets/homework_item.dart';

class ProgressFollowingTab extends StatelessWidget {
  const ProgressFollowingTab({
    super.key,
    required this.homeworkItems,
  });

  final List<Map<String, dynamic>> homeworkItems;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          // Screen header
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage(
                            'assets/images/avatar_placeholder.png'), // Safe asset path
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "ندى المطرفي",
                        style:
                            Theme.of(context).textTheme.displayMedium,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          size: 28,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
    
          // Homework List
          Expanded(
            child: ListView.builder(
              itemCount: homeworkItems.length,
              itemBuilder: (context, index) {
                final Homework = homeworkItems[index];
                return HomeworksItem(
                  title: Homework['title']!,
                  start_surah_number: Homework['start_surah_number']!,
                  start_ayah_number: Homework['start_ayah_number']!,
                  end_surah_number: Homework['end_surah_number']!,
                  end_ayah_number: Homework['end_ayah_number']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
