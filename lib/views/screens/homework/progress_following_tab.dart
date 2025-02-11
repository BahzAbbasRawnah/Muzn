import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/blocs/homework/homework_bloc.dart';
import 'package:muzn/views/widgets/empty_data.dart';
import 'package:muzn/views/screens/homework/homework_item.dart';
import 'package:muzn/models/homework.dart';

class ProgressFollowingTab extends StatelessWidget {
  final int studentId;

  const ProgressFollowingTab({
    super.key,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    // Load homework when this tab is built
    BlocProvider.of<HomeworkBloc>(context).add(LoadHomeworkEvent(context, studentId));

    return BlocBuilder<HomeworkBloc, HomeworkState>(
      builder: (context, state) {
        if (state is HomeworkLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is HomeworkLoaded) {
          final homeworkItems = state.homeworkList;
          return homeworkItems.isNotEmpty
              ? ListView.builder(
                  itemCount: homeworkItems.length,
                  itemBuilder: (context, index) {
                    final homework = homeworkItems[index];
                    return HomeworksItem(homework: homework);
                  },
                )
              : EmptyDataList();
        } else if (state is HomeworkError) {
          return Center(child: Text(state.message));
        }
        return Container(); // Default case
      },
    );
  }
}