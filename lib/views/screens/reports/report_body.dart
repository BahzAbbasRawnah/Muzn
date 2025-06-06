import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/views/screens/reports/reports_footer.dart';
import 'package:muzn/views/screens/reports/reports_header.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../app/constant/app_strings.dart';

class Report extends StatelessWidget {
  final String startDateMiladi;
  final String startDateHijri;
  final String endDateMiladi;
  final String endDateHijri;
  final String reportTitle;
  final List<String> headerTitles; // Dynamic header titles
  final List<List<String>> tableData; // Dynamic table data
  final String teacherName;
  bool? isShowAppBar=true;

   Report({
    super.key,
    required this.startDateMiladi,
    required this.startDateHijri,
    required this.endDateMiladi,
    required this.endDateHijri,
    required this.reportTitle,
    required this.headerTitles,
    required this.tableData,
    required this.teacherName,
    this.isShowAppBar,
  });

  @override
  Widget build(BuildContext context) {
    print("tableData");
    print(tableData);
    return Scaffold(
      appBar:isShowAppBar==true? AppBar(
        title: Text(reportTitle),
        centerTitle: true,
      ):null,
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
              // Container(
              //   width: double.infinity,
              //   child:
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildReportTable(context),
                ),
              // ),
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
          _printReport(context);
        },
        tooltip: 'Print Report',
        child: const Icon(Icons.print),
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
      textDirection: TextDirection.rtl,
      border: TableBorder.all(color: Colors.black),
      columnWidths: _generateColumnWidths(80, headerTitles.length),
      children: [
        // Table Header
        TableRow(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          children: [
            _buildTableCell('No.'.trans(context), isHeader: true),
            for (var title in headerTitles)
              _buildTableCell(title, isHeader: true),
          ],
        ),
        // Table Rows
        for (var i = 0; i < tableData.length; i++)
          TableRow(
            children: [
              _buildTableCell((i + 1).toString()),
              for (var cell in tableData[i]) _buildTableCell(cell),
            ],
          ),
      ],
    );
  }

  // Generate dynamic column widths
  // Map<int, TableColumnWidth> _generateColumnWidths(int columnCount) {
  //   final columnWidths = <int, TableColumnWidth>{
  //     0: const FixedColumnWidth(50.0), // Fixed width for the "No." column
  //   };
  //   for (var i = 1; i <= columnCount; i++) {
  //     columnWidths[i] =
  //         const IntrinsicColumnWidth(); // Adjust width based on content
  //   }
  //   return columnWidths;
  // }

  // Map<int, TableColumnWidth> _generateColumnWidths(BuildContext context, int columnCount) {
  //   final screenWidth = MediaQuery.of(context).size.width;
  //
  //   final columnWidths = <int, TableColumnWidth>{
  //     0: const FixedColumnWidth(50.0), // Fixed width for "No." column
  //   };
  //
  //   for (var i = 1; i <= columnCount; i++) {
  //     columnWidths[i] = FractionColumnWidth(1 / (columnCount + 1)); // Responsive width
  //   }
  //
  //   return columnWidths;
  // }
  Map<int, TableColumnWidth>? _generateColumnWidths(double screenWidth, int columnCount) {
    final columnWidths = <int, TableColumnWidth>{
      0: const FixedColumnWidth(50.0), // Fixed width for "No." column
    };

    final remainingWidth = screenWidth - 50.0; // Subtract "No." column width
    final dynamicColumnWidth = remainingWidth / columnCount; // Distribute remaining space

    for (var i = 1; i <= columnCount; i++) {
      columnWidths[i] = FixedColumnWidth(dynamicColumnWidth.clamp(70.0, 200.0)); // Clamp to avoid too small/large
    }

    return columnWidths;
  }
  // Build a table cell with consistent styling
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Container(
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
  void _printReport(BuildContext context) async {
    // final font = await PdfGoogleFonts.loadFont('assets/fonts/Amiri-Regular.ttf');
    // final ByteData fontData = await rootBundle.load('assets/fonts/Amiri-Regular.ttf');
    // final List<int> fontBytes = fontData.buffer.asUint8List();

    // final pw.Font font = pw.Font.ttf(Uint8List.fromList(fontBytes));
    final pdf = pw.Document();
    // var arabicFont = pw.Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));
    var arabicFont =
        pw.Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));
    // final image = MemoryImage(
    //     (await rootBundle.load("assets/images/app_logo.png"))
    //         .buffer
    //         .asUint8List());

    final Uint8List imageBytes =
        (await rootBundle.load("assets/images/app_logo.png"))
            .buffer
            .asUint8List();

// Convert to pw.MemoryImage for PDF
    final pw.MemoryImage pdfImage = pw.MemoryImage(imageBytes);

    final PdfColor pdfColor = PdfColor.fromInt(0xFF1F1F1F);

    pdf.theme?.copyWith(
      defaultTextStyle: pw.TextStyle(font: arabicFont),
    );
    // =pw.TextStyle(font: arabicFont);
    pdf.addPage(

      pw.Page(
        orientation:tableData.length>6? pw.PageOrientation.landscape:pw.PageOrientation.portrait,
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('جمعية مزن للإتقان',
                          style: pw.TextStyle(
                            fontSize: 20.0,
                            fontWeight: pw.FontWeight.normal,
                            color: pdfColor,
                            font: arabicFont,
                          )),
                      pw.Text('مزن لتعليم القرآن الكريم',
                          style: pw.TextStyle(
                            fontSize: 18.0,
                            fontWeight: pw.FontWeight.normal,
                            color: pdfColor,
                            font: arabicFont,
                          )),
                    ],
                  ),

                  pw.Image(pdfImage, width: 120, height: 120),
// pw.Ima
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      // AppStrings.appName
                      pw.Text('جمعية مزن للإتقان',
                          style: pw.TextStyle(
                            fontSize: 20.0,
                            fontWeight: pw.FontWeight.normal,
                            color: pdfColor,
                            font: arabicFont,
                          )),
                      pw.Text('مزن لتعليم القرآن الكريم',
                          style: pw.TextStyle(
                            fontSize: 18.0,
                            fontWeight: pw.FontWeight.normal,
                            color: pdfColor,
                            font: arabicFont,
                          )),
                    ],
                  ),
                  // Center Logo
                  // pw.CircleAvatar(
                  //   radius: 30,
                  //   child: Image.asset(AppStrings.appLogo),
                  //   backgroundColor: Colors.white,
                  //
                  // ),
                  // Right Titles
                ],
              ),
              // ReportHeader(),
              // const Divider(height: 20),
              // Date and Title Row
              // _buildDateAndTitleRow(context),
              // const SizedBox(height: 20),
              pw.Text(reportTitle,
                  style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      font: arabicFont)),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(children: [
                    pw.Text(' $startDateMiladi ',style: pw.TextStyle(font: arabicFont,fontSize: 16)),
                    pw.Text(' $endDateMiladi ',style: pw.TextStyle(font: arabicFont,fontSize: 16)),
                  ]),
          pw.Column(children: [
                  pw.Text(startDateHijri,style: pw.TextStyle(font: arabicFont,fontSize: 16)),
                  pw.Text(endDateHijri,style: pw.TextStyle(font: arabicFont,fontSize: 16)),
          ]),
                ],
              ),
              pw.SizedBox(height: 20),
              // Create a table
              // pw.Table(
              //   border: pw.TableBorder.all(color: PdfColors.black),
              //   children: [
              //     // Table Header
              //     pw.TableRow(
              //       children: [
              //         // headerTitles.reversed.toList();
              //         for (var title in headerTitles)
              //           _buildPdfTableCell(title, isHeader: true,font: arabicFont),
              //         _buildPdfTableCell('No', isHeader: true,font: arabicFont),
              //       ],
              //     ),
              //     // Table Rows
              //     for (var i = 0; i < tableData.length; i++)
              //       pw.TableRow(
              //         children: [
              //
              //           for (var cell in tableData[i])
              //             _buildPdfTableCell(cell,font: arabicFont),
              //           _buildPdfTableCell((i + 1).toString(), font: arabicFont),
              //         ],
              //       ),
              //   ],
              // ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                columnWidths: {
                  // Adjust the width of the "No." column
                  headerTitles.length: const pw.FixedColumnWidth(50), // Fixed width for "No." column
                  for (var i = 0; i < headerTitles.length; i++)
                    i: const pw.FlexColumnWidth(), // Flexible width for other columns
                },
                children: [
                  // Table Header (Reversed for RTL)
                  pw.TableRow(
                    children: [
                      for (var title
                          in headerTitles.reversed) // Reverse header order
                        _buildPdfTableCell(title,
                            isHeader: true, font: arabicFont),
                      _buildPdfTableCell('الرقم',
                          isHeader: true, font: arabicFont),
                      // "No" at the end for RTL
                    ],
                  ),
                  // Table Rows (Reversed for RTL)
                  for (var i = 0; i < tableData.length; i++)
                    pw.TableRow(
                      children: [
                        for (var cell
                            in tableData[i].reversed) // Reverse row data order
                          _buildPdfTableCell(cell, font: arabicFont),
                        _buildPdfTableCell((i + 1).toString(),
                            font: arabicFont),
                        // Serial number at the end for RTL
                      ],
                    ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text('الأستاذ :',style: pw.TextStyle(font: arabicFont)),
                  pw.Text(teacherName,style: pw.TextStyle(font: arabicFont)),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Print or share the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Printing report...')),
    );
  }

  // Build a table cell for PDF with consistent styling
  pw.Widget _buildPdfTableCell(String text,
      {bool isHeader = false, required pw.Font font}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: pw.Center(
        child: pw.Text(
          text,
          style: pw.TextStyle(
            font: font,
            fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
