import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/bloc/SchoolBloc/schools_bloc.dart';
import 'package:muzn/bloc/SchoolBloc/schools_event.dart';
import 'package:muzn/bloc/SchoolBloc/schools_state.dart';
import 'package:muzn/controllers/auth_controller.dart';
import 'package:muzn/models/user_model.dart';
import 'package:muzn/views/screens/circles_list_screen.dart';
import 'package:muzn/views/screens/school_bottomsheet.dart';
import 'package:muzn/views/widgets/app_drawer.dart';
import 'package:muzn/views/widgets/custom_app_bar.dart';

class SchoolsListScreen extends StatefulWidget {
  @override
  _SchoolsListScreenState createState() => _SchoolsListScreenState();
}

class _SchoolsListScreenState extends State<SchoolsListScreen> {
  late SchoolBloc _schoolBloc;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int _teacherId = 0;
  @override
  void initState() {
    super.initState();
    _schoolBloc = context.read<SchoolBloc>();
  // _schoolBloc.add(LoadSchools(teacherId: _teacherId));

    _getUserId();
  }

Future<void> _getUserId() async {
  User? user = await AuthController.getCurrentUser();
  if (user != null && user.id != 0) {
    setState(() {
      _teacherId = user.id!;
    });
    _schoolBloc.add(LoadSchools(teacherId: _teacherId));
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
      drawer: AppDrawer(),
      body: BlocBuilder<SchoolBloc, SchoolState>(
        builder: (context, state) {
          if (state is SchoolLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SchoolLoaded) {
            return ListView.builder(
              itemCount: state.schools.length,
              itemBuilder: (context, index) {
                return _buildSchoolListItem(state.schools[index]);
              },
            );
          } else if (state is SchoolError) {
            return Center(child: Text(state.message));
          } else {
            return  Center(child: Image.asset("assets/images/empty_box.png",width: 200, height: 200,));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () async {
    bool? isAdded = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SchoolBottomSheet(userId: _teacherId),
    );
    if (isAdded == true) {
      _schoolBloc.add(LoadSchools(teacherId: _teacherId)); // Ensure reloading
    }
  },
  child: const Icon(Icons.add),
),

    );
  }

  Widget _buildSchoolListItem(Map<String, dynamic> school) {
    return Container(
       decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  color: Colors.black, // Border color
                  width: 0.5, // Border width
                ),
              )),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/app_logo.png'),
          backgroundColor: Colors.white,
        ),
        title: Text(school['name'] ?? 'Unknown'),
        subtitle: Text(school['address'] ?? 'No Address'),
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
                  school['circles_count'].toString() ?? '0',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text('circle'.tr(context)),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CirclesListScreen(school_id:school['id'] ,),
            ),
          );
        },
      ),
    );
  }
}
