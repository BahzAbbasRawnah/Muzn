import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/controllers/circle_controller.dart';
import 'package:muzn/controllers/user_controller.dart';
import 'package:muzn/models/circle_model.dart';
import 'package:muzn/repository/circle_repository.dart';
import 'package:muzn/repository/user_repository.dart';
import 'package:muzn/views/screens/circle_bottomsheet.dart';
import 'package:muzn/views/widgets/app_drawer.dart';
import 'package:muzn/views/widgets/custom_app_bar.dart';

class CirclesListScreen extends StatefulWidget {
  final int schoolId;

  const CirclesListScreen({Key? key, required this.schoolId}) : super(key: key);

  @override
  _CirclesListScreenState createState() => _CirclesListScreenState();
}

class _CirclesListScreenState extends State<CirclesListScreen> {
  late CircleController _circleController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late UserController _userController;
  List<Circle> _circles = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _circleController = CircleController();
    _userController = UserController();
    _fetchCircles();
  }

  Future<void> _fetchCircles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final circles =
          await _circleController.getCirclesBySchoolId(widget.schoolId);
      setState(() {
        _circles = circles;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
      drawer: AppDrawer(userController: _userController),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _circles.isNotEmpty
                  ? ListView.builder(
                      itemCount: _circles.length,
                      itemBuilder: (context, index) {
                        return _buildCircleListItem(_circles[index]);
                      },
                    )
                  : _buildEmptyState(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? isAdded = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddCircleBottomSheet(),
          );
          if (isAdded == true) {
            _fetchCircles();
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCircleListItem(Circle circle) {
    return Dismissible(
      key: Key(circle.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      onDismissed: (_) async {
        await _circleController.deleteCircle(circle.id ?? 0);
        _fetchCircles();
      },
      child: ListTile(
        leading: const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/app_logo.png'),
          backgroundColor: Colors.white,
        ),
        title: Text(circle.name ?? 'Unknown'),
        subtitle: Row(
          children: [
            // Text(circle.category.name ?? circle.category.name= ''),
            const Spacer(),
            const Icon(Icons.timer, color: Color.fromARGB(255, 63, 54, 54)),
            Text(circle.circleTime.name ?? 'No Time'),
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
                  "",
                  // circle.studentCount.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text('student'.tr(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/empty_box.png",
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 30),
          Text(
            'empty_data'.tr(context),
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ],
      ),
    );
  }
}
