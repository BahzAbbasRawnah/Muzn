import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/blocs/school/school_bloc.dart';
import 'package:muzn/models/school.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // Add this package

class SchoolsReport extends StatefulWidget {
  @override
  _SchoolsReportState createState() => _SchoolsReportState();
}

class _SchoolsReportState extends State<SchoolsReport> {
  List<School> _schools = [];
  Uint8List? _pdfBytes; // Store the generated PDF bytes
  bool _showPdfPreview = false; // Control PDF preview visibility

  @override
  void initState() {
    super.initState();

    // Use a post-frame callback to ensure the context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        context.read<SchoolBloc>().add(LoadSchools(authState.user.id));
      }
    });
  }

  Future<Uint8List> _generatePdf() async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 3);

    // Load Arabic font
    final Uint8List fontData = (await rootBundle.load("assets/fonts/HacenTunisia.ttf")).buffer.asUint8List();
    final PdfFont arabicFont = PdfTrueTypeFont(fontData, 12);

    // Add headers
    grid.headers.add(1);
    final PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'الاسم';
    header.cells[1].value = 'النوع';
    header.cells[2].value = 'العنوان';
    header.style = PdfGridRowStyle(font: arabicFont, backgroundBrush: PdfBrushes.lightGray);

    // Add school data
    for (var school in _schools) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = school.name;
      row.cells[1].value = school.type;
      row.cells[2].value = school.address;
      row.style = PdfGridRowStyle(font: arabicFont);
    }

    // Draw the table
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(10, 10, page.getClientSize().width - 20, page.getClientSize().height - 20),
    );

    // Save the document to bytes
    final List<int> bytes = await document.save();
    document.dispose();
    return Uint8List.fromList(bytes);
  }

  Future<void> _previewPdf() async {
    // Generate the PDF in memory
    final Uint8List pdfBytes = await _generatePdf();

    // Update the state to show the PDF preview
    setState(() {
      _pdfBytes = pdfBytes;
      _showPdfPreview = true;
    });
  }

  Future<void> _savePdf() async {
    if (_pdfBytes != null) {
      await _saveAndOpenFile(_pdfBytes!, 'Schools_List.pdf');
    }
  }

  Future<void> _saveAndOpenFile(Uint8List bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final File file = File(filePath);
    await file.writeAsBytes(bytes);
    print('PDF saved at: $filePath');

    // Show a snackbar to confirm the save
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved at: $filePath')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
     Scaffold(
      appBar: AppBar(
        title: Text('School List'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: _previewPdf, // Generate and preview the PDF
          ),
        ],
      ),
      body: 
      BlocBuilder<SchoolBloc, SchoolState>(
        builder: (context, state) {
          if (state is SchoolLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SchoolsLoaded) {
            // Update the schools list when the state is SchoolsLoaded
            _schools = state.schools;

            return Column(
              children: [
                // PDF Preview Section
                if (_showPdfPreview && _pdfBytes != null)
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: SfPdfViewer.memory(
                            _pdfBytes!,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _savePdf, // Save the PDF
                          child: Text('Save PDF'),
                        ),
                      ],
                    ),
                  ),
                // School Data Table
                if (!_showPdfPreview)
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('الاسم',style: Theme.of(context).textTheme.titleMedium,)),
                          DataColumn(label: Text('النوع',style: Theme.of(context).textTheme.titleMedium,)),
                          DataColumn(label: Text('العنوان',style: Theme.of(context).textTheme.titleMedium,)),
                        ],
                        rows: _schools.map((school) {
                          return DataRow(cells: [
                            DataCell(Text(school.name,style: Theme.of(context).textTheme.displaySmall,)),
                            DataCell(Text(school.type!,style: Theme.of(context).textTheme.displaySmall,)),
                            DataCell(Text(school.address!,style: Theme.of(context).textTheme.displaySmall,)),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            );
          } else if (state is SchoolError) {
            return Center(child: Text('Error loading schools: ${state.message}'));
          } else {
            return Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}