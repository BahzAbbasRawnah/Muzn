import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app/constant/constant.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/circle_student/circle_student_bloc.dart';
import 'package:muzn/models/circle.dart';
import 'package:muzn/models/circle_student.dart';
import 'package:muzn/models/enums.dart';
import 'package:muzn/views/screens/homework/student_progress_screen.dart';
import 'package:muzn/views/screens/reports/report_body.dart';
import 'package:muzn/views/screens/students/add_student_to_circle_bottomsheet.dart';
import 'package:muzn/views/screens/students/edit_student_bottomsheet.dart';
import 'package:muzn/views/widgets/attendance_status_bottomsheet.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';
import 'package:muzn/views/widgets/empty_data.dart';
import 'package:muzn/views/widgets/screen_header.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/school/school_bloc.dart';
import '../students/add_student_to_circle_bottomsheet2.dart';
import '../students/edit_student_bottomsheet2.dart';

class CircleScreen extends StatefulWidget {
  final Circle circle;

  const CircleScreen({
    super.key,
    required this.circle,
  });

  @override
  _CircleScreenState createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
  final TextEditingController _searchController = TextEditingController();
  AttendanceStatuse? _selectedFilter;
  List<CircleStudent> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() {
    context.read<CircleStudentBloc>().add(
          LoadCircleStudents(
            context,
            circleId: widget.circle.id!,
          ),
        );
  }

  void _filterAndSearchStudents(List<CircleStudent> Circle_students) {
    setState(() {
      _filteredStudents = Circle_students.where((Circle_student) {
        final matchesSearch = Circle_student.student.user!.fullName
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        final matchesFilter = _selectedFilter == null ||
            Circle_student.todayAttendance == _selectedFilter;
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.circle.name),
        centerTitle: true,
           actions: [
          IconButton(
            icon:  Icon(
              Icons.print,
            ),
            onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Report(
  reportTitle: 'School Report',
  startDateMiladi: '2023-10-01',
  endDateMiladi: '2023-10-31',
  startDateHijri: '1445-03-15',
  endDateHijri: '1445-04-15',
                  headerTitles: ['الجنس', 'الحضور', 'رقم الهاتف', 'الاسم'], // Update headers accordingly
                  tableData: BlocProvider.of<CircleStudentBloc>(context)
                      .studentsList!
                      .map((school) => [
                    school.student.user?.gender.trans(context) ?? 'N/A',
                    '${school.todayAttendance?.name.toString().trans(context) ?? 0}',
                    school.student.user?.phone ?? 'N/A',
                    school.student.user?.fullName ?? "",
                  ])
                      .toList()
                      .reversed // Reverse the entire list
                      .toList(),
                  teacherName: BlocProvider.of<AuthBloc>(context).userModel?.fullName ?? "",

                  // headerTitles: ['الاسم ', 'رقم الهاتف', 'الحضور', 'الجنس'],
  // // tableData: [
  // //   ['Data 1', 'Data rrrrrrrrrrrrrrrrrrrrrrr2', 'Data 3', 'Data 4'],
  // //   ['Data 4', 'Data 5', 'Data 6', 'Data 7'],
  // // ],
  //                 tableData: BlocProvider.of<CircleStudentBloc>(context)
  //                     .studentsList!
  //                     .map((school) => [
  //                   school.student.user?.fullName??"",
  //                   school.student.user?.phone ?? 'N/A',
  //                   '${school.todayAttendance?.name.toString().trans(context) ?? 0}',
  //                   school.student.user?.gender.trans(context) ?? 'N/A'
  //                 ])
  //                     .toList(),
  // teacherName: BlocProvider.of<AuthBloc>(context).userModel?.fullName??"",
)
                )
                );
            },
          ),
        ],
      ),
      body: BlocListener<CircleStudentBloc, CircleStudentState>(
        listener: (context, state) {
          if (state is CircleStudentsLoaded) {
            _filterAndSearchStudents(state.students);
          }
        },
        child: Column(
          children: [
            ScreenHeader(),

            /// Page Header
            BlocBuilder<CircleStudentBloc, CircleStudentState>(
              builder: (context, state) {
                if (state is CircleStudentsLoaded) {
                  final total = _filteredStudents.length;
                  final attended = _filteredStudents
                      .where((student) =>
                          student.todayAttendance != AttendanceStatuse.none)
                      .length;
                  final remaining = total - attended;

                  return Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'total_students'.trans(context),
                            total.toString(),
                            Icons.people,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatCard(
                            'attended'.trans(context),
                            attended.toString(),
                            Icons.check_circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatCard(
                            'remaining'.trans(context),
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

            /// Page Content
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  CustomTextField(
                    controller: _searchController,
                    labelText: 'search_student'.trans(context),
                    hintText: 'search_student_hint'.trans(context),
                    onChanged: (value) {
                      final state = context.read<CircleStudentBloc>().state;
                      if (state is CircleStudentsLoaded) {
                        _filterAndSearchStudents(state.students);
                      }
                    },
                  ),

                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: Text('all'.trans(context)),
                          selected: _selectedFilter == null,
                          backgroundColor:
                              Theme.of(context).primaryColor.withAlpha(100),
                          selectedColor: Theme.of(context).primaryColor,
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedFilter = null;
                            });
                            final state =
                                context.read<CircleStudentBloc>().state;
                            if (state is CircleStudentsLoaded) {
                              _filterAndSearchStudents(state.students);
                            }
                          },
                        ),
                        ...AttendanceStatuse.values.map((status) {
                          if (status == AttendanceStatuse.none) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: FilterChip(
                              label: Text(status.name.trans(context)),
                              backgroundColor: Colors.grey[200],
                              selected: _selectedFilter == status,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedFilter = selected ? status : null;
                                });
                                final state =
                                    context.read<CircleStudentBloc>().state;
                                if (state is CircleStudentsLoaded) {
                                  _filterAndSearchStudents(state.students);
                                }
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
                  print('state is 88888888888888888888');
                  print(state.toString());
                  if (state is CircleStudentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is CircleStudentError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is CircleStudentsLoaded) {
                    if (_filteredStudents.isEmpty) {
                      return EmptyDataList();
                    }
                    return ListView.builder(
                      itemCount: _filteredStudents.length,
                      itemBuilder: (context, index) {
                        final circle_student = _filteredStudents[index];
                        return _buildStudentListItem(circle_student);
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            builder: (context) => AddStudentToCircleBottomSheet2(
              circleId: widget.circle.id!,
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

  Widget _buildStudentListItem(CircleStudent Circle_student) {
    print('Circle_student.todayAttendance');
    print(Circle_student.todayAttendance?.name);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
      child: Card(
        elevation: 4,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor.withAlpha(100),
            child: Icon(
              Icons.person,
              size: 30,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          title:Row(
            children: [
            Expanded(child: Text(Circle_student.student.user?.fullName??"",)),
            // Spacer(),
            IconButton(
              icon:Icon(
                Icons.edit,
                size: 30,
              ),
              onPressed: (){
              Navigator.push(
                context, MaterialPageRoute(
                builder: (context) => 
                EditStudentBottomSheet2(circleStudent: Circle_student,circleId: widget.circle.id!)
                )
                );
              
              },
            ),
              IconButton(
              icon:Icon(
                Icons.delete,
                color: Colors.red,
                size: 30,
                
              ),
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    alignment: Alignment.center,
                    title: Text('delete'.trans(context)),
                    content: Text(
                        'delete_confirm'.trans(context)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('cancel'.trans(context)),
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     BlocProvider.of<CircleStudentBloc>(context).add(DeleteStudentToCircleEvent(studentId: Circle_student.student.id, circleId: widget.circle.id!));
                      //     Navigator.pop(context);
                      //
                      //   },
                      //   child: Text(
                      //     'delete'.tr(context),
                      //     style: const TextStyle(
                      //         color: Colors.red),
                      //   ),
                      // ),
                      BlocListener<CircleStudentBloc, CircleStudentState>(
                        listener: (context, state) {
                          if (state is CircleStudentDeleted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
                              ),
                            );
                          } else if (state is CircleStudentError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
                              ),
                            );
                          }
                        },
                        child: TextButton(
                          onPressed: () {
                            BlocProvider.of<CircleStudentBloc>(context).add(
                              DeleteStudentToCircleEvent(
                                context,
                                studentId: Circle_student.student.id,
                                circleId: widget.circle.id!,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: Text(
                            'delete'.trans(context),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      )

                    ],
                  ),
                );
              },
            )
            ],
          ),
          
          
          trailing: Container(
            decoration: BoxDecoration(
              color: _getStatusColor(Circle_student.todayAttendance),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: GestureDetector(
              child: Text(
                (Circle_student.todayAttendance == null ||
                        Circle_student.todayAttendance!.name == 'none')
                    ? 'attendance'.trans(context)
                    : Circle_student.todayAttendance!.name.trans(context),
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (context) => AttendanceStatusBottomSheet(
                    studentId: Circle_student.student.id,
                    circleId: widget.circle.id!,
                    currentStatus: Circle_student.todayAttendance,
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
                    circleId: widget.circle.id!,
                    student: Circle_student.student),
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
