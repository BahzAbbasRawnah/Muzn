import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/bloc/CircleBloc/circle_repository.dart';
import 'package:muzn/bloc/CircleBloc/circle_event.dart';
import 'package:muzn/bloc/CircleBloc/circle_state.dart';


class CircleBloc extends Bloc<CircleEvent, CircleState> {
  final CircleRepository _repository;

  CircleBloc(this._repository) : super(CircleInitial()) {
    on<LoadCircles>((event, emit) async {
      emit(CircleLoading());
      try {
        if(event.schoolId!=0){
                final circles = await _repository.fetchMosqueCircles(event.schoolId);
        emit(CircleLoaded(circles: circles));
        }
        else{
        final circles = await _repository.fetchCircles(event.teacherId);
        emit(CircleLoaded(circles: circles));
        }
       
      } catch (e) {
        emit(CircleError(message: e.toString()));
      }
    });

    on<AddCircleEvent>((event, emit) async {
      try {
        await _repository.addCircle(event.circle);
        emit(CircleAdded());
      } catch (e) {
        emit(CircleError(message: e.toString()));
      }
    });

    on<EditCircleEvent>((event, emit) async {
      try {
        await _repository.editCircle(event.circleId, event.updatedData);
        emit(CircleEdited());
      } catch (e) {
        emit(CircleError(message: e.toString()));
      }
    });

    on<DeleteCircleEvent>((event, emit) async {
      try {
        await _repository.deleteCircle(event.circleId);
        emit(CircleDeleted());
      } catch (e) {
        emit(CircleError(message: e.toString()));
      }
    });
  }
}
