import 'dart:async';

import 'package:flutter/material.dart';
import 'package:muzn/views/widgets/loading_spinner.dart';

class Utils {
  /// Shows a loading dialog with an optional message.
  /// Returns the dialog's context so it can be dismissed later.
  Future<BuildContext> showLoadingDialog(BuildContext context, {String message = 'Loading...'}) {
    final dialogContextCompleter = Completer<BuildContext>();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from being dismissed by tapping outside
      builder: (BuildContext context) {
        // Complete the completer with the dialog's context
        if (!dialogContextCompleter.isCompleted) {
          dialogContextCompleter.complete(context);
        }
        return CustomLoadingDialog(message: message);
      },
    );

    // Return the dialog's context once it's available
    return dialogContextCompleter.future.then((context) => context).catchError((_) => null);
  }

  /// Dismisses the currently shown loading dialog.
  void dismissLoadingDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}