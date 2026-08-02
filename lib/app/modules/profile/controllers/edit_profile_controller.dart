// ignore_for_file: depend_on_referenced_packages, avoid_print, prefer_final_fields

import 'dart:convert';
import 'dart:io';
import 'package:dirve_society/get_storage.dart';
import 'package:dirve_society/urls.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
 
class EditProfileController extends GetxController {
  // Changed to RxBool for reactive state management
  RxBool _inProgress = false.obs;
  bool get inProgress => _inProgress.value; // Updated getter to use .value

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 🔁 Update Profile Function
  Future<bool> updateProfile(
    String name,
    String bio,
    Map<String, dynamic> addressLine1,
    Map<String, dynamic> addressLine2,
    File? image, {
    File? cover,
  }) async {
    if (_inProgress.value) {
      // Prevent multiple calls while in progress
      return false;
    }

    bool isSuccess = false;
    _inProgress.value = true; // Updated to use .value
    update();

    print(
      'Name: $name, Bio: $bio, Address 1: $addressLine1, '
      'Address 2: $addressLine2, Image: $image',
    );

    try {
      String? token = StorageUtil.getData(StorageUtil.userAccessToken);
      if (token == null || token.isEmpty) {
        _errorMessage = "User not authenticated";
        _inProgress.value = false; // Updated to use .value
        update();
        return false;
      }

      var uri = Uri.parse(Urls.editProfileUrl);
      var request = http.MultipartRequest('PUT', uri);

      // ✅ Only Authorization header
      request.headers['Authorization'] = token;

      // ✅ Set 'data' field with JSON-encoded string
      Map<String, dynamic> jsonFields = {
        "name": name,
        "bio": bio,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
      };

      request.fields['data'] = jsonEncode(jsonFields);

      // ✅ Add image if available
      if (image != null) {
        print('Image ache ekhane ................................');
        print(image);
        String imagePath = image.path;
        String? mimeType = lookupMimeType(imagePath) ?? 'image/jpeg';

        request.files.add(
          await http.MultipartFile.fromPath(
            'image', // 🔑 Backend should expect this key
            imagePath,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      // ✅ Add banner if available
      if (cover != null) {
        print('Banner ache ekhane ................................');
        print(cover);
        String bannerPath = cover.path;
        String? mimeType = lookupMimeType(bannerPath) ?? 'image/jpeg';

        request.files.add(
          await http.MultipartFile.fromPath(
            'cover', // 🔑 Backend should expect this key
            bannerPath,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      // 📡 Send request
      var streamedResponse = await request.send();
      var responseBody = await streamedResponse.stream.bytesToString();

      print('📥 Server Response:');
      print(responseBody);

      var decodedResponse = jsonDecode(responseBody);

      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        _errorMessage = null;
        isSuccess = true;
      } else {
        _errorMessage =
            decodedResponse['message'] ?? "Failed to update profile";
      }
    } catch (e) {
      _errorMessage = "Error updating profile: $e";
    } finally {
      _inProgress.value = false; // Updated to use .value
      update();
    }

    return isSuccess;
  }
}
