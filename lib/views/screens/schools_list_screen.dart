import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/bloc/SchoolBloc/schools_bloc.dart';
import 'package:muzn/bloc/SchoolBloc/schools_event.dart';
import 'package:muzn/bloc/SchoolBloc/schools_state.dart';
import 'package:muzn/controllers/user_controller.dart'; // Import UserController
import 'package:muzn/models/school_model.dart'; // Import your School model
import 'package:muzn/repository/user_repository.dart';
import 'package:muzn/views/screens/circles_list_screen.dart';
import 'package:muzn/views/screens/school_bottomsheet.dart';
import 'package:muzn/views/widgets/app_drawer.dart';
import 'package:muzn/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/controllers/user_controller.dart';
import 'package:muzn/models/user_model.dart';
import 'package:muzn/views/widgets/custom_app_bar.dart';
import 'package:muzn/views/widgets/app_drawer.dart'; // Import the AppDrawer

class SchoolsListScreen extends StatefulWidget {
  @override
  _SchoolsListScreenState createState() => _SchoolsListScreenState();
}

class _SchoolsListScreenState extends State<SchoolsListScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int? _teacherId; // Store the current user's ID
  late UserController _userController; // Declare UserController

  @override
  void initState() {
    super.initState();
    _userController = UserController(); 
    _fetchCurrentUser(); 
  }

  // Fetch the current user and set the teacherId
  Future<void> _fetchCurrentUser() async {
    await _userController.init(); // Initialize SharedPreferences
    final currentUser = await _userController.getCurrentUser();
    if (currentUser != null) {
      setState(() {
        _teacherId = currentUser.id; // Set the teacherId
      });
      // Fetch schools for the current teacher
      context.read<SchoolBloc>().add(GetSchoolsByTeacherIdEvent(_teacherId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: 'school'.tr(context),
        scaffoldKey: scaffoldKey,
      ),
      // Pass UserController to AppDrawer
      drawer: AppDrawer(userController: _userController),
      body: BlocBuilder<SchoolBloc, SchoolState>(
        builder: (context, state) {
          if (state is SchoolLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SchoolsLoaded) {
            return ListView.builder(
              itemCount: state.schools.length,
              itemBuilder: (context, index) {
                return _buildSchoolListItem(state.schools[index]);
              },
            );
          } else if (state is SchoolError) {
            return Center(child: Text(state.message));
          } else {
            return Center(
              child: Image.asset(
                "assets/images/empty_box.png",
                width: 200,
                height: 200,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_teacherId != null) {
            bool? isAdded = await showModalBottomSheet<bool>(
              context: context,
              isScrollControlled: true,
              builder: (context) => SchoolBottomSheet(userId: _teacherId!),
            );
            if (isAdded == true) {
              // Refresh the list after adding a new school
              context.read<SchoolBloc>().add(GetSchoolsByTeacherIdEvent(_teacherId!));
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSchoolListItem(School school) {
    return Dismissible(
      key: Key(school.id.toString()), // Unique key for each item
      direction: DismissDirection.endToStart, // Swipe from right to left
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        // Show a confirmation dialog before deleting
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('delete_school'.tr(context)),
            content: Text('are_you_sure_you_want_to_delete_this_school'.tr(context)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Cancel
                child: Text('cancel'.tr(context)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Confirm
                child: Text('delete'.tr(context)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        // Delete the school when dismissed
        context.read<SchoolBloc>().add(DeleteSchoolEvent(school.id!));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black, // Border color
              width: 0.5, // Border width
            ),
          ),
        ),
        child: ListTile(
          leading: const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/images/app_logo.png'),
            backgroundColor: Colors.white,
          ),
          title: Text(school.name ?? school.type.toString()),
          subtitle: Text(school.address ?? ''),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '0',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text('circle'.tr(context)),
            ],
          ),
          onTap: () {
            // Navigate to the circles list screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CirclesListScreen(schoolId: school.id!),
              ),
            );
          },
        ),
      ),
    );
  }
}