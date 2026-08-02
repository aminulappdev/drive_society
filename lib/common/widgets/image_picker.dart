// image_picker_helper.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> _cropImage(
    String sourcePath, {
    double? aspectRatioX,
    double? aspectRatioY,
  }) async {
    if (aspectRatioX == null || aspectRatioY == null) {
      return File(sourcePath);
    }

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      aspectRatio: CropAspectRatio(ratioX: aspectRatioX, ratioY: aspectRatioY),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          lockAspectRatio: true,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );

    if (croppedFile == null) {
      return null;
    }

    return File(croppedFile.path);
  }

  // Function to pick an image from the camera
  Future<void> pickImageFromCamera(
    BuildContext context,
    Function(File) onImagePicked,
    {
    double? aspectRatioX,
    double? aspectRatioY,
    }
  ) async {
    try {
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );
      if (pickedImage != null) {
        final croppedImage = await _cropImage(
          pickedImage.path,
          aspectRatioX: aspectRatioX,
          aspectRatioY: aspectRatioY,
        );

        if (croppedImage != null) {
          onImagePicked(croppedImage);
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  // Function to pick an image from the gallery
  Future<void> pickImageFromGallery(
    BuildContext context,
    Function(File) onImagePicked,
    {
    double? aspectRatioX,
    double? aspectRatioY,
    }
  ) async {
    try {
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (pickedImage != null) {
        final croppedImage = await _cropImage(
          pickedImage.path,
          aspectRatioX: aspectRatioX,
          aspectRatioY: aspectRatioY,
        );

        if (croppedImage != null) {
          onImagePicked(croppedImage);
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<List<File>> pickMultiImageFromGallery({
    double? aspectRatioX,
    double? aspectRatioY,
  }) async {
    try {
      final pickedImages = await _imagePicker.pickMultiImage(imageQuality: 90);
      if (pickedImages.isEmpty) {
        return [];
      }

      final List<File> croppedImages = [];
      for (final image in pickedImages) {
        final croppedImage = await _cropImage(
          image.path,
          aspectRatioX: aspectRatioX,
          aspectRatioY: aspectRatioY,
        );

        if (croppedImage != null) {
          croppedImages.add(croppedImage);
        }
      }

      return croppedImages;
    } catch (e) {
      debugPrint("Error picking multiple images: $e");
      return [];
    }
  }

  // Function to show the image picker dialog
  Future<void> showAlertDialog(
    BuildContext context,
    Function(File) onImagePicked,
    {
    double? aspectRatioX,
    double? aspectRatioY,
    }
  ) {
    final parentContext = context;
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SizedBox(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      if (Navigator.canPop(dialogContext)) {
                        Navigator.pop(dialogContext);
                      }
                      pickImageFromCamera(
                        parentContext,
                        onImagePicked,
                        aspectRatioX: aspectRatioX,
                        aspectRatioY: aspectRatioY,
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt, size: 30),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Take a Photo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      if (Navigator.canPop(dialogContext)) {
                        Navigator.pop(dialogContext);
                      }
                      pickImageFromGallery(
                        parentContext,
                        onImagePicked,
                        aspectRatioX: aspectRatioX,
                        aspectRatioY: aspectRatioY,
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image, size: 30),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Choose from Gallery',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: const Color.fromARGB(255, 77, 76, 76),
                  ),
                  SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      if (Navigator.canPop(dialogContext)) {
                        Navigator.pop(dialogContext);
                      }
                    },
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
