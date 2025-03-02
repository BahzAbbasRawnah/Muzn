import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';

class ReportFooter extends StatelessWidget {
  final int rowCount;
  final String teacherName;

  const ReportFooter({super.key,
    required this.rowCount,
    required this.teacherName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 1, thickness: 1, color: Colors.grey),
          SizedBox(height: 10),
          // Row Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text(
            'Total Rows: $rowCount',
                     style: Theme.of(context).textTheme.labelMedium,

          ),
          Text(
            'Teacher:'.trans(context)+teacherName,
            style: Theme.of(context).textTheme.labelMedium,
          
          ),
          ]),
        ],
      ),
    );
  }
}