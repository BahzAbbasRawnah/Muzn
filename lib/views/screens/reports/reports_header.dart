import 'package:flutter/material.dart';
import 'package:muzn/app/constant/app_strings.dart';
import 'package:muzn/app_localization.dart';

class ReportHeader extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left Titles
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppStrings.appName.tr(context), style: Theme.of(context).textTheme.titleMedium),
            Text(AppStrings.appTitle.tr(context), style: Theme.of(context).textTheme.titleSmall),

          ],
        ),
        // Center Logo
        CircleAvatar(
          radius: 30,
          child: Image.asset(AppStrings.appLogo),
          backgroundColor: Colors.white,

        ),
        // Right Titles
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppStrings.organizationName.tr(context), style: Theme.of(context).textTheme.titleMedium),
            Text(AppStrings.appTitle.tr(context), style: Theme.of(context).textTheme.titleSmall),

          ],
        ),
      ],
    );
  }
}