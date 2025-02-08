
import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';

class ProgressHistoryTab extends StatelessWidget {
  const ProgressHistoryTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          // Screen header (same as the first tab)
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
          const SizedBox(height: 16),
    
          // Additional content for the second tab
          Expanded(
            child: Center(
              child: Text(
                'second_tab_content'.tr(context),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
