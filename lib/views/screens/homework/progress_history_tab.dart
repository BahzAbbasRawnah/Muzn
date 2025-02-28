import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/blocs/homework/homework_bloc.dart';
import 'package:muzn/models/homework.dart';
import 'package:muzn/views/widgets/empty_data.dart';
import 'package:muzn/views/screens/homework/history_item.dart';
import 'package:muzn/views/screens/homework/homework_item.dart';

class ProgressHistoryTab extends StatelessWidget {
  final int studentId;

  const ProgressHistoryTab({
    super.key,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    // Load history when this tab is built
    // BlocProvider.of<HomeworkBloc>(context)
    //     .add(LoadHistoryEvent(context, studentId));

    return BlocBuilder<HomeworkBloc, HomeworkState>(
      builder: (context, state) {
        if (state is HomeworkLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProgressHistoryLoaded) {
          final ProgressHistoryItem = state.ProgressHistoryList.toList();
          if (ProgressHistoryItem.isEmpty) {
            return EmptyDataList();
          } else {
            return ListView.builder(
              itemCount: ProgressHistoryItem.length,
              itemBuilder: (context, index) {
                final ProgressHistory = ProgressHistoryItem[index];
                return HistoryItem(progressHistory: ProgressHistory);
              },
            );
          }
        } else if (state is HomeworkError) {
          return Center(child: Text(state.message));
        }
        if(BlocProvider.of<HomeworkBloc>(context).listStudentProgressHistory?.isNotEmpty??false){
          return ListView.builder(
            itemCount: BlocProvider.of<HomeworkBloc>(context).listStudentProgressHistory?.length,
            itemBuilder: (context, index) {
              final ProgressHistory = BlocProvider.of<HomeworkBloc>(context).listStudentProgressHistory![index];
              return HistoryItem(progressHistory: ProgressHistory);
            },
          );
        }
        return Container(); // Default case
      },
    );
  }
}
