import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/views/screens/reports/reports_footer.dart';
import 'package:muzn/views/screens/reports/reports_header.dart';

class Report extends StatelessWidget {
  final String startDateMiladi;
  final String startDateHijri;
  final String endDateMiladi;
  final String endDateHijri;
  final String reportTitle;
  final List<String> headerTitles; // Dynamic header titles
  final List<List<String>> tableData; // Dynamic table data
  final String teacherName;

  const Report({
    required this.startDateMiladi,
    required this.startDateHijri,
    required this.endDateMiladi,
    required this.endDateHijri,
    required this.reportTitle,
    required this.headerTitles,
    required this.tableData,
    required this.teacherName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reportTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Header
              ReportHeader(),
              const Divider(height: 20),
              // Date and Title Row
              _buildDateAndTitleRow(context),
              const SizedBox(height: 20),
              // Table with horizontal scrolling
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildReportTable(context),
              ),
              // Footer
              ReportFooter(
                rowCount: tableData.length,
                teacherName: teacherName,
              ),
            ],
          ),
        ),
      ),
      // Floating Action Button for Printing
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your print or export logic here
          _printReport(context);
        },
        child: const Icon(Icons.print),
        tooltip: 'Print Report',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Build the date and title row
  Widget _buildDateAndTitleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Start Date
        _buildDateRow(
          icon: Icons.calendar_today,
          miladiDate: startDateMiladi,
          hijriDate: startDateHijri,
        ),
        // Report Title
        Text(
          reportTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // End Date
        _buildDateRow(
          icon: Icons.calendar_today,
          miladiDate: endDateMiladi,
          hijriDate: endDateHijri,
        ),
      ],
    );
  }

  // Build a date row with icon and dates
  Widget _buildDateRow({
    required IconData icon,
    required String miladiDate,
    required String hijriDate,
  }) {
    return Row(
      children: [
        Icon(icon, size: 25),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(miladiDate, style: const TextStyle(fontSize: 14)),
            Text(hijriDate, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }

  // Build the report table
  Widget _buildReportTable(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      columnWidths: _generateColumnWidths(headerTitles.length),
      children: [
        // Table Header
        TableRow(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          children: [
            _buildTableCell('No.', isHeader: true),
            for (var title in headerTitles)
              _buildTableCell(title, isHeader: true),
          ],
        ),
        // Table Rows
        for (var i = 0; i < tableData.length; i++)
          TableRow(
            children: [
              _buildTableCell((i + 1).toString()),
              for (var cell in tableData[i])
                _buildTableCell(cell),
            ],
          ),
      ],
    );
  }

  // Generate dynamic column widths
  Map<int, TableColumnWidth> _generateColumnWidths(int columnCount) {
    final columnWidths = <int, TableColumnWidth>{
      0: const FixedColumnWidth(50.0), // Fixed width for the "No." column
    };
    for (var i = 1; i <= columnCount; i++) {
      columnWidths[i] = const IntrinsicColumnWidth(); // Adjust width based on content
    }
    return columnWidths;
  }

  // Build a table cell with consistent styling
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return  Container(
     padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
       
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      
    );
  }

  // Print or export the report
  void _printReport(BuildContext context) {
    // Add your print or export logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Printing report...')),
    );
  }
}
