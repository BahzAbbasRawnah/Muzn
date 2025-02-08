import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/circle/circle_bloc.dart';
import 'package:muzn/models/circle.dart';
import 'package:muzn/models/enums.dart';
import 'package:muzn/views/screens/circle_screen.dart';

import 'package:muzn/views/widgets/add_circle_bottomsheet.dart';
import 'package:muzn/views/widgets/app_drawer.dart';
import 'package:muzn/views/widgets/custom_app_bar.dart';

class CirclesListScreen extends StatefulWidget {
  final int? schoolId;

  const CirclesListScreen({Key? key, this.schoolId}) : super(key: key);

  @override
  _CirclesListScreenState createState() => _CirclesListScreenState();
}

class _CirclesListScreenState extends State<CirclesListScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context
        .read<CircleBloc>()
        .add(LoadCircles(context, schoolId: widget.schoolId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: 'circles'.tr(context),
        scaffoldKey: scaffoldKey,
      ),
      drawer: widget.schoolId == null ? AppDrawer() : null,
      body: BlocBuilder<CircleBloc, CircleState>(
        builder: (context, state) {
          if (state is CircleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CircleError) {
            return Center(child: Text(state.message.tr(context)));
          } else if (state is CirclesLoaded) {
            if (state.circles.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty_box.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'empty_data'.tr(context),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.circles.length,
              itemBuilder: (context, index) {
                return _buildCircleListItem(state.circles[index]);
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddCircleBottomSheet(
              schoolId: widget.schoolId ?? -1,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCircleListItem(Circle circle) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black, // Border color
            width: 0.5, // Border width
          ),
        ),
      ),
      child: ListTile(
        title: Row(
          children: [
            Text(circle.name),
            Spacer(),
            Icon(Icons.person_2),
            Text('${circle.studentCount ?? 0} ${'student'.tr(context)}'),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (circle.categoryName != null)
              Text(circle.categoryName!.tr(context)),
        
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Icon(Icons.timer),
                const SizedBox(width: 4),
                Text(
                  CircleTime.values
                      .firstWhere(
                        (time) => time.name == circle.circleTime?.split('.').last,
                        orElse: () => CircleTime.morning,
                      )
                      .toLocalizeTimedString(context),
                ),
                Spacer(),
                Icon(Icons.location_on),
                const SizedBox(width: 4),
                Text(
                  CircleType.values
                      .firstWhere(
                        (type) => type.name == circle.circleType?.split('.').last,
                        orElse: () => CircleType.offline,
                      )
                      .toLocalizedTypeString(context),
                ),
              ],
            )
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Text('edit'.tr(context)),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text(
                'delete'.tr(context),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              // TODO: Implement edit
            } else if (value == 'delete') {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('delete_circle_confirm'.tr(context)),
                  content: Text('delete_circle_confirmation'.tr(context)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('cancel'.tr(context)),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<CircleBloc>()
                            .add(DeleteCircle(context, circle.id));
                        Navigator.pop(context);
                      },
                      child: Text(
                        'delete'.tr(context),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        onTap: () {
          // TODO: Navigate to circle details screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CircleScreen(circleId: circle.id,circleName: circle.name,)
            ),
          );
        },
      ),
    );
  }
}
