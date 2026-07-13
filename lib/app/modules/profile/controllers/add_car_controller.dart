
// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:dirve_society/get_storage.dart';
import 'package:dirve_society/urls.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

class AddCarController extends GetxController {
  // Changed to RxBool for reactive state management
  RxBool _inProgress = false.obs;
  bool get inProgress => _inProgress.value; // Updated getter to use .value

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 🔁 Add Car Function
  Future<bool> addCar(
      String brand,
      String model,
      int mileage,
      String fuelType,
      String transmission,
      String description,
      int price,
      String condition,
      String color,
      int year,
      List<File>? images,
      {File? cover}) async {
    if (_inProgress.value) {
      // Prevent multiple calls while in progress
      return false;
    }

    bool isSuccess = false;
    _inProgress.value = true; // Updated to use .value
    update();

    try {
      String? token = StorageUtil.getData(StorageUtil.userAccessToken);
      if (token == null || token.isEmpty) {
        _errorMessage = "User not authenticated";
        _inProgress.value = false; // Updated to use .value
        update();
        return false;
      }

      var uri = Uri.parse(Urls.addCarUrl);
      var request = http.MultipartRequest('POST', uri);

      // ✅ Only Authorization header
      request.headers['Authorization'] = token;

      // ✅ Set 'data' field with JSON-encoded string
      Map<String, dynamic> jsonFields = {
        "brand": brand,
        "model": model,
        "mileage": mileage,
        "fuelType": fuelType,
        "transmission": transmission,
        "description": description,
        "price": price,
        "condition": condition,
        "color": color,
        "year": year
      };

      request.fields['data'] = jsonEncode(jsonFields);

      // ✅ Add multiple images if available
      if (images != null && images.isNotEmpty) {
        print('Images found: $images');
        for (var image in images) {
          String imagePath = image.path;
          String? mimeType = lookupMimeType(imagePath) ?? 'image/jpeg';
          request.files.add(
            await http.MultipartFile.fromPath(
              'images', // Backend should expect this key for multiple images
              imagePath,
              contentType: MediaType.parse(mimeType),
            ),
          );
        }
      }

      // ✅ Add cover image if available
      if (cover != null) {
        print('Cover image found: $cover');
        String coverPath = cover.path;
        String? mimeType = lookupMimeType(coverPath) ?? 'image/jpeg';

        request.files.add(
          await http.MultipartFile.fromPath(
            'banner', // Backend should expect this key
            coverPath,
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
        _errorMessage = decodedResponse['message'] ?? "Failed to add car";
      }
    } catch (e) {
      _errorMessage = "Error adding car: $e";
    } finally {
      _inProgress.value = false; // Updated to use .value
      update();
    }

    return isSuccess;
  }
}
