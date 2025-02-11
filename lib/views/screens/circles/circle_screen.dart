import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/circle_student/circle_student_bloc.dart';
import 'package:muzn/models/circle_student.dart';
import 'package:muzn/models/enums.dart';
import 'package:muzn/views/screens/homework/student_progress_screen.dart';
import 'package:muzn/views/screens/students/add_student_to_circle_bottomsheet.dart';
import 'package:muzn/views/widgets/attendance_status_bottomsheet.dart';
import 'package:muzn/views/widgets/custom_leaf_container.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';
import 'package:muzn/views/widgets/empty_data.dart';
import 'package:muzn/views/widgets/screen_header.dart';

class CircleScreen extends StatefulWidget {
  final int circleId;
  final String circleName;

  const CircleScreen({
    Key? key,
    required this.circleId,
    required this.circleName,
  }) : super(key: key);

  @override
  _CircleScreenState createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
  final TextEditingController _searchController = TextEditingController();
  AttendanceStatuse? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() {
    context.read<CircleStudentBloc>().add(
          LoadCircleStudents(
            context,
            circleId: widget.circleId,
            searchQuery:
                _searchController.text.isEmpty ? null : _searchController.text,
            filterStatus: _selectedFilter,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.circleName),
        centerTitle: true,
      ),
      body: Column(
        children: [
               ScreenHeader(),


          ///Page Header
          BlocBuilder<CircleStudentBloc, CircleStudentState>(
            builder: (context, state) {
              if (state is CircleStudentsLoaded) {
                final total = state.students.length;
                final attended = state.attendanceSummary.entries
                    .where((e) => e.key != AttendanceStatuse.none)
                    .fold(0, (sum, entry) => sum + entry.value);
                final remaining = total - attended;

                return 
                
                Container(
                  
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'total_students'.tr(context),
                          total.toString(),
                          Icons.people,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          'attended'.tr(context),
                          attended.toString(),
                          Icons.check_circle
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          'remaining'.tr(context),
                          remaining.toString(),
                          Icons.pending,
                        ),
                      ),
                        
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),


          ///Page Content
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                CustomTextField(
                  controller: _searchController,
                  labelText: 'search_student'.tr(context),
                  hintText: 'search_student_hint'.tr(context),
                  onChanged: (value) => _loadStudents(),
                ),
             
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: Text('all'.tr(context)),
                        selected: _selectedFilter == null,
                        backgroundColor:Theme.of(context).primaryColor.withAlpha(100),
                        selectedColor: Theme.of(context).primaryColor,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedFilter = null;
                          });
                          _loadStudents();
                        },
                      ),
                      ...AttendanceStatuse.values.map((status) {
                        if (status == AttendanceStatuse.none)
                          return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: FilterChip(
                            label: Text(status.name.tr(context)),
                             backgroundColor:Colors.grey[200],
                            selected: _selectedFilter == status,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedFilter = selected ? status : null;
                              });
                              _loadStudents();
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Students list
          Expanded(
            child: BlocBuilder<CircleStudentBloc, CircleStudentState>(
              builder: (context, state) {
                if (state is CircleStudentLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CircleStudentError) {
                  return Center(child: Text(state.message));
                }
                if (state is CircleStudentsLoaded) {
                  if (state.students.isEmpty) {
                    return EmptyDataList();
                  }
                  return ListView.builder(
                    itemCount: state.students.length,
                    itemBuilder: (context, index) {
                      final student = state.students[index];
                      return _buildStudentListItem(student);
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
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
            builder: (context) => AddStudentToCircleBottomSheet(
              circleId: widget.circleId,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentListItem(CircleStudent student) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 5),
      child: Card(
        elevation: 4,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        child: ListTile(
          key: Key(student.id.toString()),
          leading: CircleAvatar(
            child: Icon(
              Icons.person,
              size: 30,
              color: Theme.of(context).iconTheme.color,
            ),
            backgroundColor: Theme.of(context).primaryColor.withAlpha(100),
          ),
          title: Text(student.name),
          // subtitle: student. != null ? Text(student.phoneNumber!) : null,
          trailing: Container(
            decoration: BoxDecoration(
              color: _getStatusColor(student.todayAttendance),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: GestureDetector(
              child: Text(
                student.todayAttendance?.name.tr(context) ??
                    'attendance'.tr(context),
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => AttendanceStatusBottomSheet(
                    studentId: student.id,
                    circleId: widget.circleId,
                    currentStatus: student.todayAttendance,
                  ),
                );
              },
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentProgressScreen(
                    circleId: widget.circleId, studentId: student.id),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getStatusColor(AttendanceStatuse? status) {
    switch (status) {
      case AttendanceStatuse.present:
        return Colors.green;
      case AttendanceStatuse.absent:
        return Colors.red;
      case AttendanceStatuse.absent_with_excuse:
        return Colors.orange;
      case AttendanceStatuse.early_departure:
        return Colors.amber;
      case AttendanceStatuse.not_listened:
        return Colors.grey;
      case AttendanceStatuse.late:
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}
