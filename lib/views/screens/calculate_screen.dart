import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/views/widgets/app_drawer.dart';
import 'package:muzn/views/widgets/custom_app_bar.dart';
import 'package:muzn/views/widgets/screen_header.dart';
class CalculateScreen extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'calculate'.tr(context),
        scaffoldKey: _scaffoldKey,
      ),
      // drawer:  AppDrawer(),
      body: Column(
              children: [
               ScreenHeader(),
                Expanded(

      child:  Center(child: Text('Calculate')),
                )
              ]
      )
    );
  }
}
