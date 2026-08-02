
import 'package:dirve_society/app/modules/meets/controllers/all_meet_controller.dart';
import 'package:dirve_society/app/modules/meets/controllers/meet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MeetsView extends StatelessWidget {
  const MeetsView({super.key});

  @override
  Widget build(BuildContext context) {
    final MeetsController controller = Get.put(MeetsController());
    final AllMeetsController allMeetsController = Get.find<AllMeetsController>();
    final TextEditingController searchController = TextEditingController();

    // Function to search for a location using Nominatim API
    Future<void> searchLocation(String query) async {
      if (query.isEmpty) return;

      final String url =
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1';

      try {
        final response = await http.get(Uri.parse(url), headers: {
          'User-Agent': 'drive_society', // Replace with your app's name
        });
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data.isNotEmpty) {
            final double lat = double.parse(data[0]['lat']);
            final double lng = double.parse(data[0]['lon']);
            controller.mapController?.animateCamera(
              CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14),
            );
            // Add a marker for the searched location
            controller.markers.value = {
              ...controller.markers.value,
              Marker(
                markerId: const MarkerId('searched_location'),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(title: query),
              ),
            };
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location not found')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to fetch location')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          GetBuilder<AllMeetsController>(
            builder: (allMeetsController) {
              if (allMeetsController.inProgress) {
                return const Center(child: CircularProgressIndicator());
              }

              if (allMeetsController.errorMessage != null) {
                return Center(
                  child: Text(
                    allMeetsController.errorMessage ?? 'Failed to load meets',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              }

              return Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(23.76784914290362, 90.42213245820426),
                          zoom: 14,
                        ),
                        markers: controller.markers.value,
                        onMapCreated: (GoogleMapController mapController) {
                          controller.onMapCreated(mapController);
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        compassEnabled: true,
                        zoomControlsEnabled: true,
                      ),
              );
            },
          ),
          // Search bar at the top
          Positioned(
            top: 60, // Adjusted to ensure visibility
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search location',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      searchLocation(searchController.text);
                    },
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  searchLocation(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
