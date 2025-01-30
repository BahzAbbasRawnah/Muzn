import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/bloc/CircleBloc/circle_bloc.dart';
import 'package:muzn/bloc/CircleBloc/circle_event.dart';
import 'package:muzn/bloc/CircleBloc/circle_state.dart';
import 'package:muzn/controllers/auth_controller.dart';
import 'package:muzn/models/user_model.dart';
import 'package:muzn/views/screens/circle_bottomsheet.dart';
import 'package:muzn/views/screens/circle_screen.dart';
import 'package:muzn/views/widgets/app_drawer.dart';
import 'package:muzn/views/widgets/custom_app_bar.dart';

class CirclesListScreen extends StatefulWidget {
  final int school_id;
  CirclesListScreen({required this.school_id});

  @override
  _CirclesListScreenState createState() => _CirclesListScreenState();
}

class _CirclesListScreenState extends State<CirclesListScreen> {
  late CircleBloc _circleBloc;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int _teacherId = 0;
  @override
  void initState() {
    super.initState();
    _circleBloc = context.read<CircleBloc>();
    _circleBloc
        .add(LoadCircles(teacherId: _teacherId, schoolId: widget.school_id));

    _getUserId();
  }

  Future<void> _getUserId() async {
    User? user = await AuthController.getCurrentUser();
    if (user != null && user.id != 0) {
      setState(() {
        _teacherId = user.id!;
      });
      _circleBloc
          .add(LoadCircles(teacherId: _teacherId, schoolId: widget.school_id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: 'circles'.tr(context),
        scaffoldKey: scaffoldKey,
      ),
      drawer: AppDrawer(),
      body: BlocBuilder<CircleBloc, CircleState>(
        builder: (context, state) {
          if (state is CircleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CircleLoaded) {
            if (state.circles.length > 0) {
              return ListView.builder(
                  itemCount: state.circles.length,
                  itemBuilder: (context, index) {
                    return _buildCircleListItem(state.circles[index]);
                  });
            }
            else{
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/empty_box.png",
                      width: 200,
                      height: 200,
                    ),
                     SizedBox(height: 30),

                    Text('empty_data'.tr(context),style: Theme.of(context).textTheme.displayMedium),
                  ]
                ),
              );
            }
          } else if (state is CircleError) {
            return Center(child: Text(state.message));
          } else {
            return Center(
                child: Image.asset(
              "assets/images/empty_box.png",
              width: 200,
              height: 200,
            ));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? isAdded = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddCircleBottomSheet(),
          );
          if (isAdded == true) {
            _circleBloc.add(LoadCircles(
                teacherId: _teacherId, schoolId: 0)); // Ensure reloading
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCircleListItem(Map<String, dynamic> circle) {
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
        title: Text(circle['name'] ?? 'Unknown'),
        subtitle: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(circle['category_name'] ?? 'No Address'),
            Spacer(),
            SizedBox(
              width: 2,
            ),
            Icon(Icons.timer, color: Color.fromARGB(255, 63, 54, 54)),
            Text(circle['circle_time'] ?? 'No Address'),
          ],
        ),
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
                  circle['student_count'].toString() ?? '?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text('student'.tr(context)),
          ],
        ),
        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CircleScreen(circleId: circle['id']), // Pass the actual ID
    ),
  );
},

      ),
    );
  }
}
