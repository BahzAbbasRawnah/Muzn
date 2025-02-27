import 'package:flutter/material.dart';
import 'package:muzn/app/constant/app_strings.dart';
import 'package:muzn/app_localization.dart';
class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("about".tr(context)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(AppStrings.appLogo),
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 16),

            // App Name
            Text(
              AppStrings.appName.tr(context),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),

            // Short Description
         Text(
  "about_description".tr(context),
  textAlign: TextAlign.center,
  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
),
const SizedBox(height: 20),

// Features Section
_buildFeatureItem(Icons.groups, "manage_circles".tr(context)),
_buildFeatureItem(Icons.book, "full_quran".tr(context)),
_buildFeatureItem(Icons.headphones, "listen_quran".tr(context)),
_buildFeatureItem(Icons.search, "search_quran".tr(context)),
_buildFeatureItem(Icons.language, "arabic_and_english".tr(context)),
_buildFeatureItem(Icons.adjust, "dark_light_mode".tr(context)),
          ]         
        ),
      ),
    );
  }

  // Helper method to build feature rows
  Widget _buildFeatureItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
