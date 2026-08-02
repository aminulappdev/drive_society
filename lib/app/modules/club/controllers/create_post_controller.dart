// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:dirve_society/get_storage.dart';
import 'package:dirve_society/urls.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart'; 
import 'package:http/http.dart' as http;

class CreatePostController extends GetxController {
  // ignore: prefer_final_fields
  RxBool _inProgress = false.obs; // NEW CHANGE: Changed to RxBool 
  bool get inProgress =>
      _inProgress.value; // NEW CHANGE: Updated getter to use .value

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 🔁 Update Profile Function
  Future<bool> createPost({
    required String description,
    required List<File> images,
    String? privacy,
    String? singleTag, 
    List<String> tags = const [],
    Map<String, dynamic>? location,
    File? cover,
    String? clubId,
  }) async {
    if (_inProgress.value) {
      // NEW CHANGE: Added check to prevent multiple calls
      return false;
    }

    bool isSuccess = false;
    _inProgress.value = true; // NEW CHANGE: Updated to use .value
    update();

    try {
      String? token = StorageUtil.getData(StorageUtil.userAccessToken);
      if (token == null || token.isEmpty) {
        _errorMessage = "User not authenticated";
        _inProgress.value = false; // NEW CHANGE: Updated to use .value
        update();
        return false;
      }

      var uri = Uri.parse(Urls.createPostUrl);
      var request = http.MultipartRequest('POST', uri);

      // ✅ Only Authorization header
      request.headers['Authorization'] = token;

      // ✅ Set 'data' field with JSON-encoded string
      final List<String> resolvedTags = tags.isNotEmpty
          ? tags
          : singleTag != null && singleTag.trim().isNotEmpty
              ? [singleTag.trim()]
              : [];

      final Map<String, dynamic> jsonFields = {
        "author": StorageUtil.getData(StorageUtil.profileId),
        "description": description,
        "tags": resolvedTags,
      };

      if (clubId != null) {
        jsonFields["club"] = clubId;
      }

      if (location != null) {
        jsonFields["location"] = location;
      }

      request.fields['data'] = jsonEncode(jsonFields);

      // ✅ Add image if available
      for (final image in images) {
        String imagePath = image.path;
        String? mimeType = lookupMimeType(imagePath) ?? 'image/jpeg';

        request.files.add(
          await http.MultipartFile.fromPath(
            'content', // 🔑 Backend should expect this key
            imagePath,
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
      _inProgress.value = false; // NEW CHANGE: Updated to use .value
      update();
    }

    return isSuccess;
  }
}
