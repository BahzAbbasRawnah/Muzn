import 'package:flutter/material.dart';
import 'package:muzn/app/constant/app_strings.dart';
import 'package:muzn/app_localization.dart';

class ReportHeader extends StatelessWidget {
  const ReportHeader({super.key});

 
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left Titles
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppStrings.appName.trans(context), style: Theme.of(context).textTheme.titleMedium),
            Text(AppStrings.appTitle.trans(context), style: Theme.of(context).textTheme.titleSmall),

          ],
        ),
        // Center Logo
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Image.asset(AppStrings.appLogo),

        ),
        // Right Titles
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppStrings.organizationName.trans(context), style: Theme.of(context).textTheme.titleMedium),
            Text(AppStrings.appTitle.trans(context), style: Theme.of(context).textTheme.titleSmall),

          ],
        ),
      ],
    );
  }
}