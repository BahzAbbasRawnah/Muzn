import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/blocs/statistics/statistics_bloc.dart';
import 'package:muzn/views/widgets/app_drawer.dart';
import 'package:muzn/views/widgets/screen_header.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final ScrollController _controller = ScrollController(); // Added controller

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      if (mounted) {
        context.read<StatisticsBloc>().add(FetchStatistics(teacherId: authState.user.id));
      }else{

      }
      // }
    }
    else{
      if(BlocProvider.of<AuthBloc>(context).userModel!=null) {
        context.read<StatisticsBloc>().add(FetchStatistics(teacherId: BlocProvider
            .of<AuthBloc>(context)
            .userModel
        !.id));


      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('statistics'.trans(context)),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          const ScreenHeader(),
          Expanded(
            child: BlocBuilder<StatisticsBloc, StatisticsState>(
              builder: (context, state) {
                if (state is StatisticsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is StatisticsError) {
                  return Center(child: Text(state.message));
                } else if (state is StatisticsLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatisticCard(
                              context,
                              title: 'schools_count'.trans(context),
                              value: state.schoolCount.toString(),
                              color: Colors.blue,
                            ),
                            _buildStatisticCard(
                              context,
                              title: 'circles_count'.trans(context),
                              value: state.circleCount.toString(),
                              color: Colors.blue,
                            ),
                            _buildStatisticCard(
                              context,
                              title: 'students_count'.trans(context),
                              value: state.studentCount.toString(),
                              color: Colors.green,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16), // Added spacing
                        Text("top_present_students".trans(context), style: Theme.of(context).textTheme.titleMedium),
                        Divider(color: Colors.black,),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _controller,
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.topPresentStudents.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final student = state.topPresentStudents[index];
                                    return ListTile(
                                     
                                      title: Text(student.fullName),
                                      trailing: CircleAvatar(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        child: Text(student.attendanceCount.toString()),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16), // Added spacing
                                Text("top_absent_students".trans(context), style: Theme.of(context).textTheme.titleMedium),
                                                        Divider(color: Colors.black,),

                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.topAbsentStudents.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final student = state.topAbsentStudents[index]; 
                                    return ListTile(
                                     
                                      title: Text(student.fullName),
                                      trailing: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        child: Text(student.attendanceCount.toString()),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text("No data available"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticCard(BuildContext context,
      {required String title, required String value, required Color color}) {
    return Expanded(
      child: Card(
        elevation: 4,
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 8),
              Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
