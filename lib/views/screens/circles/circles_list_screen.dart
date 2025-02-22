import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/blocs/circle/circle_bloc.dart';
import 'package:muzn/models/circle.dart';
import 'package:muzn/models/enums.dart';
import 'package:muzn/views/screens/circles/circle_screen.dart';
import 'package:muzn/views/screens/circles/add_circle_bottomsheet.dart';
import 'package:muzn/views/screens/circles/edit_circle_bottomsheet.dart';
import 'package:muzn/views/widgets/app_drawer.dart';
import 'package:muzn/views/widgets/custom_app_bar.dart';
import 'package:muzn/views/widgets/empty_data.dart';
import 'package:muzn/views/widgets/screen_header.dart';

class CirclesListScreen extends StatefulWidget {
  final int? schoolId;

  const CirclesListScreen({Key? key, this.schoolId}) : super(key: key);

  @override
  _CirclesListScreenState createState() => _CirclesListScreenState();
}

class _CirclesListScreenState extends State<CirclesListScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
@override
void initState() {
  super.initState();

  // Get the current authenticated user from the AuthBloc
  final authState = context.read<AuthBloc>().state;
  if (authState is AuthAuthenticated) {
    final teacherId = authState.user.id;
    // Load circles for the current teacher
    context.read<CircleBloc>().add(LoadCircles(
          schoolId: widget.schoolId,
          teacherId: teacherId,
        ));
  } else {

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
      drawer: widget.schoolId == null ? const AppDrawer() : null,
      body: BlocBuilder<CircleBloc, CircleState>(
        builder: (context, state) {
          if (state is CircleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CircleError) {
            return Center(child: Text(state.message.tr(context)));
          } else if (state is CirclesLoaded) {
            if (state.circles.isEmpty) {
              return EmptyDataList();
            }
            return Column(
              children: [
                const ScreenHeader(),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.circles.length,
                    itemBuilder: (context, index) {
                      return _buildCircleListItem(state.circles[index]);
                    },
                  ),
                ),
              ],
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
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
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
    return Card(
      elevation: 4,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.white,
      child: ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          title: Row(
          children: [
            Text(
              circle.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            const Icon(
              Icons.person_2,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text('${circle.studentCount ?? 0} ${'student'.tr(context)}'),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (circle.categoryName != null)
              Text(
                'circle_category'.tr(context) + "/" +circle.categoryName!.tr(context),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.timer,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  CircleTime.values
                      .firstWhere(
                        (time) =>
                            time.name == circle.circleTime?.split('.').last,
                        orElse: () => CircleTime.morning,
                      )
                      .toLocalizeTimedString(context),
                      style: Theme.of(context).textTheme.displaySmall,
                ),
                const Spacer(),
                const Icon(
                  Icons.location_on,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  CircleType.values
                      .firstWhere(
                        (type) =>
                            type.name == circle.circleType?.split('.').last,
                        orElse: () => CircleType.offline,
                      )
                      .toLocalizedTypeString(context),
                ),
              ],
            ),
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
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => EditCircleBottomSheet(circle: circle),
              );
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
                            .add(DeleteCircle(circle.id!, circle.teacherId!));
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CircleScreen(
                circle: circle,
              ),
            ),
          );
        },
      ),
    );
  }
}
