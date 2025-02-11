import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';

class EmptyDataList extends StatelessWidget {
  const EmptyDataList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty_box.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'empty_data'.tr(context),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
              );
  }
}