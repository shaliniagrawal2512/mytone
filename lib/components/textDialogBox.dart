import 'package:flutter/material.dart';
import 'package:mytone/constants.dart';

class TextInputDialog {
  Future<void> showTextInputDialog({
    required BuildContext context,
    required String title,
    String? initialText,
    required Function(String) onSubmitted,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext ctxt) {
        final _controller = TextEditingController(text: initialText);
        return AlertDialog(
          backgroundColor: kBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Color(0xFFF9287B))),
              TextField(
                autofocus: true,
                controller: _controller,
                onSubmitted: (value) {
                  onSubmitted(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF7E1CEA),
              ),
              onPressed: () {
                onSubmitted(_controller.text.trim());
              },
              child: Text(
                "OK",
              ),
            ),
          ],
        );
      },
    );
  }
}
