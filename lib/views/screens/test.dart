// import 'dart:io';

// import 'package:flutter/foundation.dart'
//     show kIsWeb; // for checking whether running on Web or not
// import 'package:flutter/material.dart';
// import 'package:pdf_render_scroll/pdf_render.dart';
// import 'package:pdf_render_scroll/pdf_render_widgets.dart';

// void main(List<String> args) => runApp(const Test());

// class Test extends StatefulWidget {
//   const Test({Key? key}) : super(key: key);

//   @override
//   _TestState createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   final controller = PdfViewerController();
//   TapDownDetails? _doubleTapDetails;

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: ValueListenableBuilder<Matrix4>(
//               // The controller is compatible with ValueListenable<Matrix4> and you can receive notifications on scrolling and zooming of the view.
//               valueListenable: controller,
//               builder: (context, _, child) => Text(controller.isReady
//                   ? 'Page #${controller.currentPageNumber}'
//                   : 'Page -')),
//         ),
//         backgroundColor: Colors.grey,
//         body: GestureDetector(
//           // Supporting double-tap gesture on the viewer.
//           onDoubleTapDown: (details) => _doubleTapDetails = details,
//           onDoubleTap: () => controller.ready?.setZoomRatio(
//             zoomRatio: controller.zoomRatio * 1.5,
//             center: _doubleTapDetails!.localPosition,
//           ),
//           child: PdfViewer.openAsset(
//                   'assets/static/quran.pdf',
//                   viewerController: controller,
//                   onError: (err) => print(err),
//                   params: const PdfViewerParams(
//                     padding: 10,
//                     minScale: 1.0,
//                     // scrollDirection: Axis.horizontal,
//                   ),
//                 ),
//         ),
//         floatingActionButton: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             FloatingActionButton(
//               child: const Icon(Icons.first_page),
//               onPressed: () => controller.ready?.goToPage(pageNumber: 1),
//             ),
//             FloatingActionButton(
//               child: const Icon(Icons.last_page),
//               onPressed: () =>
//                   controller.ready?.goToPage(pageNumber: controller.pageCount),
//             ),
//             FloatingActionButton(
//               child: const Icon(Icons.bug_report),
//               onPressed: () => rendererTest(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Just testing internal rendering logic
//   Future<void> rendererTest() async {
//     final PdfDocument doc;
  
//       doc = await PdfDocument.openAsset('assets/static/quran.pdf');
    

//     try {
//       final page = await doc.getPage(1);
//       final image = await page.render();
//       print(
//           '${image.width}x${image.height}: ${image.pixels.lengthInBytes} bytes.');
//     } finally {
//       doc.dispose();
//     }
//   }
// }