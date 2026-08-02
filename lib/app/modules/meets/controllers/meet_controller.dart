import 'package:dirve_society/app/modules/meets/controllers/all_meet_controller.dart';
import 'package:dirve_society/app/modules/meets/controllers/custom_maker.dart';
import 'package:dirve_society/app/modules/meets/model/all_meets_model.dart';
import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/app_text_style/styles.dart';
import 'package:dirve_society/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class MeetModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String? tag;
  final String? dateTime;
  final LatLng location;
  final String? address;

  MeetModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.tag,
    this.dateTime,
    required this.location,
    this.address,
  });
}

class MeetsController extends GetxController {
  final AllMeetsController allMeetsController = Get.put(AllMeetsController());
  final Rx<Set<Marker>> markers = Rx<Set<Marker>>({});
  final RxBool isLoading = true.obs;
  final Rx<LatLng> currentCenter =
      const LatLng(23.76784914290362, 90.42213245820426).obs;
  GoogleMapController? mapController;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentLocation();
    loadMarkers();
  }

  Future<void> _loadCurrentLocation() async {
    final location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await location.getLocation();
    final latitude = locationData.latitude;
    final longitude = locationData.longitude;

    if (latitude == null || longitude == null) {
      return;
    }

    final target = LatLng(latitude, longitude);
    currentCenter.value = target;

    if (mapController != null) {
      await mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(target, 14),
      );
    }
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    await mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(currentCenter.value, 14),
    );
  }

  Future<void> loadMarkers() async {
    isLoading.value = true;

    // Fetch data from AllMeetsController
    final bool success = await allMeetsController.getMeet();
    if (!success) {
      isLoading.value = false;
      return;
    }

    try {
      final Set<Marker> markersSet = {};
      final meets = _convertToMeetModel(allMeetsController.allMeetsList ?? []);

      for (final meet in meets) {
        final Uint8List markerIcon = await createCustomMarkerFromWidget(meet);

        final marker = Marker(
          markerId: MarkerId(meet.id),
          position: meet.location,
          icon: BitmapDescriptor.bytes(markerIcon),
          onTap: () {
            _showMeetPopup(meet);
          },
        );
        markersSet.add(marker);
      }

      markers.value = markersSet;
    } catch (e) {
      print('Error loading markers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<MeetModel> _convertToMeetModel(List<AllMeetsItemModel> items) {
    return items.map((item) {
      return MeetModel(
        id: item.id ?? '',
        title: item.title ?? 'Untitled Meet',
        description: item.eventDetails ?? 'No description available',
        imageUrl: item.coverPhoto ?? 'assets/images/car image 3.jpg',
        tag: item.entryFee == 0 ? 'Free' : 'Paid',
        dateTime: item.time ?? item.date?.toString(),
        location: LatLng(item.latitude ?? 0.0, item.longitude ?? 0.0),
        address: item.location ?? 'Unknown Location',
      );
    }).toList();
  }

  Future<Uint8List> createCustomMarkerFromWidget(MeetModel meet) async {
    const int markerWidth = 80;
    const int markerHeight = 120;

    ui.Image carImage = await loadImage(meet.imageUrl);

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final CustomMarkerPainter customMarkerPainter = CustomMarkerPainter(
      image: carImage,
      markerColor: Colors.black,
      strokeColor: Colors.white,
    );

    customMarkerPainter.paint(
        canvas, Size(markerWidth.toDouble(), markerHeight.toDouble()));

    final ui.Image markerImage =
        await pictureRecorder.endRecording().toImage(120, 160);
    final ByteData? byteData =
        await markerImage.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  Future<ui.Image> loadImage(String imageUrl) async {
    try {
      if (imageUrl.startsWith('http')) {
        // Handle network image
        return await loadNetworkImage(imageUrl);
      } else {
        // Handle asset image
        return await loadAssetImage(imageUrl);
      }
    } catch (e) {
      // Fallback to default image if loading fails
      print('Error loading image: $e');
      return await loadAssetImage('assets/images/car image 3.jpg');
    }
  }

  Future<ui.Image> loadAssetImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(data.buffer.asUint8List(), (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  Future<ui.Image> loadNetworkImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;
      final Completer<ui.Image> completer = Completer();
      ui.decodeImageFromList(bytes, (ui.Image img) {
        completer.complete(img);
      });
      return completer.future;
    } else {
      throw Exception('Failed to load network image');
    }
  }

  void _showMeetPopup(MeetModel meet) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: Get.width * 0.8,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  meet.imageUrl,
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    meet.tag ?? 'Free',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                meet.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    meet.dateTime ?? 'Unknown Time',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      meet.address ?? 'Unknown Location',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      height: 38,
                      textStyle: h6.copyWith(color: AppColors.white),
                      text: 'Event Details',
                      onPressed: () async {
                        final Uri uri = Uri.parse(meet.description);
                        if (!await launchUrl(uri,
                            mode: LaunchMode.externalApplication)) {
                          throw Exception(
                              "Could not launch ${meet.description}");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
