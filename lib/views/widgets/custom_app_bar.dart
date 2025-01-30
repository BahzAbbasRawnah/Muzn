import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/views/screens/quraan_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title.tr(context)),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer(); // Open the drawer
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
                
            child: Image.asset(
              'assets/images/quran.png', // Replace with your own icon file
              fit: BoxFit.contain,
              width: 40,
              height: 40,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuranScreen(),
                  ));
            },
          ),
        ),
     
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Default app bar height
}
