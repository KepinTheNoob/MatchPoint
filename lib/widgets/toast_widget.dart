import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:matchpoint/main.dart';

void toastBool(String text, bool status) {
  DelightToastBar(
    builder: (context) {
      return Align(
        alignment: Alignment.topCenter,
        child: FractionallySizedBox(
          widthFactor: 0.85, // 85% dari lebar layar
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: status ? Colors.greenAccent : Colors.redAccent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  status ? Icons.check_circle : Icons.error,
                  color: status ? Colors.greenAccent : Colors.redAccent,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    position: DelightSnackbarPosition.top,
    autoDismiss: true,
    snackbarDuration: const Duration(seconds: 2),
    animationDuration: const Duration(milliseconds: 300),
  ).show(navigatorKey.currentContext!);
}
