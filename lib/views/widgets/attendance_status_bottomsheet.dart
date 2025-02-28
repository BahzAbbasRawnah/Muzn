import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/circle_student/circle_student_bloc.dart';
import 'package:muzn/models/enums.dart';
import 'package:muzn/views/widgets/custom_button.dart';

class AttendanceStatusBottomSheet extends StatefulWidget {
  final int studentId;
  final int circleId;
  final AttendanceStatuse? currentStatus;

  const AttendanceStatusBottomSheet({
    Key? key,
    required this.studentId,
    required this.circleId,
    this.currentStatus,
  }) : super(key: key);

  @override
  State<AttendanceStatusBottomSheet> createState() =>
      _AttendanceStatusBottomSheetState();
}

class _AttendanceStatusBottomSheetState
    extends State<AttendanceStatusBottomSheet> {
  AttendanceStatuse? _selectedStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  void _saveAttendance() {
    if (_selectedStatus == null) {
    
      return;
    }

    setState(() => _isLoading = true);
 
    context.read<CircleStudentBloc>().add(
          UpdateStudentAttendance(
            // context,
            studentId: widget.studentId,
            circleId: widget.circleId,
            status: _selectedStatus!,
          ),
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'student_attendance'.trans(context),
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Status options in a grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: AttendanceStatuse.values.map((status) {
              if (status == AttendanceStatuse.none) return const SizedBox();

              final isSelected = _selectedStatus == status;
              return ChoiceChip(
                label: Text(
                  status.name.trans(context),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                selected: isSelected,
                onSelected: (bool selected) {
                  setState(() {
                    _selectedStatus = selected ? status : null;
                  });
                
                },
                selectedColor: _getStatusColor(status),
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
              );
            }).toList(),
          ),

          SizedBox(height: deviceHeight * 0.03),

          // Save button
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            CustomButton(
              text: 'save'.trans(context),
              onPressed: _saveAttendance,
              icon: Icons.save,
            ),

          SizedBox(height: deviceHeight * 0.02),
        ],
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
        return Colors.grey;
    }
  }
}
