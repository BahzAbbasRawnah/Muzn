import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/views/screens/circles/circles_list_screen.dart';
import 'package:muzn/views/screens/schools/add_school_bottomSheet.dart';
import 'package:muzn/views/widgets/app_drawer.dart';
import 'package:muzn/views/widgets/empty_data.dart';
import 'package:muzn/views/widgets/screen_header.dart';
import '../../../app_localization.dart';
import '../../../blocs/school/school_bloc.dart';

class SchoolsListScreen extends StatefulWidget {
  const SchoolsListScreen({Key? key}) : super(key: key);

  @override
  State<SchoolsListScreen> createState() => _SchoolsListScreenState();
}

class _SchoolsListScreenState extends State<SchoolsListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SchoolBloc>().add(LoadSchools(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('schools'.tr(context)),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: BlocBuilder<SchoolBloc, SchoolState>(
        builder: (context, state) {
          if (state is SchoolLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SchoolError) {
            return Center(child: Text(state.message.tr(context)));
          }

          if (state is SchoolsLoaded) {
            if (state.schools.isEmpty) {
              return EmptyDataList();
            }

            return Column(
              children: [
               ScreenHeader(),
                Expanded(
                  child: ListView.builder(
                    // padding: const EdgeInsets.all(16),
                    itemCount: state.schools.length,
                    itemBuilder: (context, index) {
                      final school = state.schools[index];
                      return Card(
                        elevation: 4,
                        shadowColor:Colors.black,
                        surfaceTintColor: Colors.white,
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          title: Row(
                            children: [
                              Text(
                                school.name,
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.group, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${school.circleCount ?? 0} ${'circles'.tr(context)}',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, size: 16),
                                const SizedBox(width: 4),
                                Expanded(child: Text(school.address!)),
                              ],
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                // TODO: Implement edit functionality
                              } else if (value == 'delete') {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    alignment: Alignment.center,
                                    title: Text('delete_school'.tr(context)),
                                    content:
                                        Text('delete_school_confirm'.tr(context)),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('cancel'.tr(context)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<SchoolBloc>()
                                              .add(DeleteSchool(context, school.id));
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
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    const Icon(Icons.edit),
                                    const SizedBox(width: 8),
                                    Text('edit'.tr(context)),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    const Icon(Icons.delete, color: Colors.red),
                                    const SizedBox(width: 8),
                                    Text(
                                      'delete'.tr(context),
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CirclesListScreen(schoolId: school.id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: BlocBuilder<SchoolBloc, SchoolState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => const AddSchoolBottomSheet(),
              );
            },
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
