import"package:flutter/material.dart";
import "package:top_snackbar_flutter/custom_snack_bar.dart";
import "package:top_snackbar_flutter/top_snack_bar.dart";

showCustomSnackBar(context) => showTopSnackBar(
      Overlay.of(context),
      const CustomSnackBar.error(message: "Something went wrong"),
    );
