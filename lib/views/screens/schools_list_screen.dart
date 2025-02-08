import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/views/screens/circles_list_screen.dart';
import 'package:muzn/views/widgets/app_drawer.dart';
import '../../app_localization.dart';
import '../../blocs/school/school_bloc.dart';
import '../widgets/add_school_bottomSheet.dart';

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
              // padding: const EdgeInsets.all(16),
              itemCount: state.schools.length,
              itemBuilder: (context, index) {
                final school = state.schools[index];
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                    title: Row(
                      children: [
                        Text(
                          school.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Spacer(),
   Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.group, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${school.circleCount ?? 0} ${'circles'.tr(context)}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    subtitle: 
                          Padding(
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
                          builder: (context) => CirclesListScreen(schoolId: school.id),
                          ),
                        
                      );
                    },
                  ),
                );
              },
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
