import 'package:flutter/material.dart';

class CommonDialog extends StatefulWidget {
  String dialogName;
    String dialogTitle;
  String message;
  CommonDialog({Key? key, required this.dialogName, required this.dialogTitle, required this.message})
      : super(key: key);

  @override
  State<CommonDialog> createState() => _CommonDialogState();
}

class _CommonDialogState extends State<CommonDialog> {
  String defaultMessage = 'Something went wrong!';
  Widget CommonMessage(String message) {
    return AlertDialog(
      title: Text(widget.dialogTitle),
      content: IntrinsicHeight(
        child: Column(
          children: [
            Text(message),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('close'),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // setViewMode(widget.dialogName);
  }

  Widget setViewMode(String mode) {
    print('view product mode: $mode');
    switch (mode) {
      case 'productAgeRestriction':
        {
          return CommonMessage(widget.message);
        }
      default:
        {
          return CommonMessage(defaultMessage);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return setViewMode(widget.dialogName);
  }
}
