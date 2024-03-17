import "package:flutter/material.dart";

showSnackBar(
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    {required BuildContext,
    required String text,
    bool isErro = true,
    required BuildContext context}) {
  SnackBar snackBar = SnackBar(
    content: Text(text),
    backgroundColor: (isErro) ? Colors.red : Colors.green,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    duration: const Duration(seconds: 4),
    action: SnackBarAction(
      label: "Ok",
      textColor: Colors.white,
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
