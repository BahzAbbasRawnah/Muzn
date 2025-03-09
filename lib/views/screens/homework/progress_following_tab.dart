import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/blocs/homework/homework_bloc.dart';
import 'package:muzn/models/circle_student.dart';
import 'package:muzn/models/student.dart';
import 'package:muzn/views/widgets/empty_data.dart';
import 'package:muzn/views/screens/homework/homework_item.dart';
import 'package:muzn/models/homework.dart';

import '../../../models/circle.dart';

class ProgressFollowingTab extends StatelessWidget {
  final Student student;
Circle circle;
   ProgressFollowingTab({
    super.key,
    required this.student,
    required this.circle,
  });

  @override
  Widget build(BuildContext context) {
    // Load homework when this tab is built
    // BlocProvider.of<HomeworkBloc>(context)
    //     .add(LoadHomeworkEvent(student.id));

    return BlocConsumer<HomeworkBloc, HomeworkState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return BlocBuilder<HomeworkBloc, HomeworkState>(
      builder: (context, state) {
        print('home work state');
        print(state.toString());
        if (state is HomeworkLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if(BlocProvider.of<HomeworkBloc>(context).listHomeWork?.isNotEmpty??false){
          return ListView.builder(
            itemCount: BlocProvider.of<HomeworkBloc>(context).listHomeWork?.length,
            itemBuilder: (context, index) {
              final homework = BlocProvider.of<HomeworkBloc>(context).listHomeWork![index];
              return HomeworksItem(homework: homework, student: student, circle: circle,);
            },
          );
        }
        else if (state is HomeworkLoaded) {
          final homeworkItems = state.homeworkList;
          if (homeworkItems.isEmpty) {
            return EmptyDataList();
          }
          return ListView.builder(
            itemCount: homeworkItems.length,
            itemBuilder: (context, index) {
              final homework = homeworkItems[index];
              return HomeworksItem(homework: homework, student: student, circle: circle,);
            },
          );
        }
        else if (state is HomeworkError) {
          return Center(child: Text(state.message));
        }
        return Container(); // Default case
      },
    );
  },
);
  }
}
