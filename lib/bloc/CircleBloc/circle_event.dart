import 'package:equatable/equatable.dart';

abstract class CircleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCircles extends CircleEvent {
  final int teacherId;
  final int schoolId;
  LoadCircles({required this.teacherId,required this.schoolId});
}

class AddCircleEvent extends CircleEvent {
  final Map<String, dynamic> circle;
  AddCircleEvent({required this.circle});
}

class EditCircleEvent extends CircleEvent {
  final int circleId;
  final Map<String, dynamic> updatedData;
  EditCircleEvent({required this.circleId, required this.updatedData});
}

class DeleteCircleEvent extends CircleEvent {
  final int circleId;
  DeleteCircleEvent({required this.circleId});
}
