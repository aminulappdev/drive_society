import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreviewDialog {
  const ImagePreviewDialog._();

  static Future<void> showFile(
    BuildContext context, {
    required File imageFile,
  }) {
    return _show(
      context,
      child: Image.file(
        imageFile,
        fit: BoxFit.contain,
      ),
    );
  }

  static Future<void> showNetwork(
    BuildContext context, {
    required String imageUrl,
    Widget? fallback,
  }) {
    return _show(
      context,
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            fallback ??
            const Icon(
              Icons.broken_image,
              color: Colors.white70,
              size: 60,
            ),
      ),
    );
  }

  static Future<void> _show(
    BuildContext context, {
    required Widget child,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: child,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
