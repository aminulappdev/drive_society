
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
      {String? derivative,
      String? bodyType,
      int? doors,
      String? postcode,
      String? sellerType,
      File? cover,
      int? monthlyPayment,
      int? seats,
      double? engineSize,
      int? powerBhp,
      String? zeroToSixtyBand,
      String? drivetrain,
      int? co2Emissions,
      int? previousOwners,
      String? serviceHistory,
      int? numberOfKeys,
      String? writeOffCategory,
      String? roadTaxBand,
      bool? ulezCompliant,
      int? mpg,
      List<String>? features,
      List<String>? buildStatus,
      String? clubId,
      bool? eventReady}) async {
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

      if (derivative != null && derivative.trim().isNotEmpty) {
        jsonFields["derivative"] = derivative.trim();
      }
      if (bodyType != null && bodyType.trim().isNotEmpty) {
        jsonFields["bodyType"] = bodyType.trim();
      }
      if (doors != null && doors > 0) {
        jsonFields["doors"] = doors;
      }
      if (postcode != null && postcode.trim().isNotEmpty) {
        jsonFields["postcode"] = postcode.trim();
      }
      if (sellerType != null && sellerType.trim().isNotEmpty) {
        jsonFields["sellerType"] = sellerType.trim();
      }
      if (monthlyPayment != null && monthlyPayment > 0) {
        jsonFields["monthlyPayment"] = monthlyPayment;
      }
      if (seats != null && seats > 0) {
        jsonFields["seats"] = seats;
      }
      if (engineSize != null && engineSize > 0) {
        jsonFields["engineSize"] = engineSize;
      }
      if (powerBhp != null && powerBhp > 0) {
        jsonFields["powerBhp"] = powerBhp;
      }
      if (zeroToSixtyBand != null && zeroToSixtyBand.trim().isNotEmpty) {
        jsonFields["zeroToSixtyBand"] = zeroToSixtyBand.trim();
      }
      if (drivetrain != null && drivetrain.trim().isNotEmpty) {
        jsonFields["drivetrain"] = drivetrain.trim();
      }
      if (co2Emissions != null && co2Emissions > 0) {
        jsonFields["co2Emissions"] = co2Emissions;
      }
      if (previousOwners != null && previousOwners > 0) {
        jsonFields["previousOwners"] = previousOwners;
      }
      if (serviceHistory != null && serviceHistory.trim().isNotEmpty) {
        jsonFields["serviceHistory"] = serviceHistory.trim();
      }
      if (numberOfKeys != null && numberOfKeys > 0) {
        jsonFields["numberOfKeys"] = numberOfKeys;
      }
      if (writeOffCategory != null && writeOffCategory.trim().isNotEmpty) {
        jsonFields["writeOffCategory"] = writeOffCategory.trim();
      }
      if (roadTaxBand != null && roadTaxBand.trim().isNotEmpty) {
        jsonFields["roadTaxBand"] = roadTaxBand.trim();
      }
      if (ulezCompliant != null) {
        jsonFields["ulezCompliant"] = ulezCompliant;
      }
      if (mpg != null && mpg > 0) {
        jsonFields["mpg"] = mpg;
      }
      if (features != null && features.isNotEmpty) {
        jsonFields["features"] = features;
      }
      if (buildStatus != null && buildStatus.isNotEmpty) {
        jsonFields["buildStatus"] = buildStatus;
      }
      if (clubId != null && clubId.trim().isNotEmpty) {
        jsonFields["clubId"] = clubId.trim();
      }
      if (eventReady != null) {
        jsonFields["eventReady"] = eventReady;
      }

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
