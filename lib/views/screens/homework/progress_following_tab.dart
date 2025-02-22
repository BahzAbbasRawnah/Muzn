import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/blocs/homework/homework_bloc.dart';
import 'package:muzn/models/circle_student.dart';
import 'package:muzn/models/student.dart';
import 'package:muzn/views/widgets/empty_data.dart';
import 'package:muzn/views/screens/homework/homework_item.dart';
import 'package:muzn/models/homework.dart';

class ProgressFollowingTab extends StatelessWidget {
  final Student student;

  const ProgressFollowingTab({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    // Load homework when this tab is built
    BlocProvider.of<HomeworkBloc>(context)
        .add(LoadHomeworkEvent(context, student.id));

    return BlocBuilder<HomeworkBloc, HomeworkState>(
      builder: (context, state) {
        if (state is HomeworkLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is HomeworkLoaded) {
          final homeworkItems = state.homeworkList;
          if (homeworkItems.isEmpty) {
            return EmptyDataList();
          }
          return ListView.builder(
            itemCount: homeworkItems.length,
            itemBuilder: (context, index) {
              final homework = homeworkItems[index];
              return HomeworksItem(homework: homework, student: student);
            },
          );
        } else if (state is HomeworkError) {
          return Center(child: Text(state.message));
        }
        return Container(); // Default case
      },
    );
  }
}
