import 'package:dirve_society/app/data/dummy_data.dart';
import 'package:dirve_society/app/modules/home/views/date_formatter.dart';
import 'package:dirve_society/app/modules/market_place/views/listing_details_view.dart';
import 'package:dirve_society/app/modules/profile/controllers/my_garage_controller.dart';
import 'package:dirve_society/app/modules/profile/others/controller/others_garage_controller.dart';
import 'package:dirve_society/common/helper/market_place_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

 
class OthersProfileMarketPlace extends StatefulWidget {
  final String? id;
  const OthersProfileMarketPlace({super.key, this.id});

  @override
  State<OthersProfileMarketPlace> createState() =>
      _OthersProfileMarketPlaceState();
}

class _OthersProfileMarketPlaceState extends State<OthersProfileMarketPlace> {
  final OthersGarageController othersGarageController =
      Get.put(OthersGarageController());

  @override
  void initState() {
    othersGarageController.getOthersGarage(id: widget.id ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OthersGarageController>(builder: (controller) {
      if (controller.inProgress) {
        return SizedBox(
            height: 300,
            child: const Center(child: CircularProgressIndicator()));
      }
      if (controller.myGarageList == null || controller.myGarageList!.isEmpty) {
        return SizedBox(
            height: 300, child: const Center(child: Text('No Car Found')));
      }
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.myGarageList?.length,
              itemBuilder: (context, index) {
                final dateFormatter = DateFormatter(
                    controller.myGarageList?[index].createdAt ??
                        DateTime.now());
                return Padding(
                  padding: EdgeInsets.only(
                    top: index == 0 ? 12 : 8,
                    bottom: index == DummyData.cars.length - 1 ? 20 : 0,
                  ),
                  child: MarketPlaceWidget(
                    height: 200,
                    name: controller.myGarageList?[index].brand ?? '',
                    price:
                        controller.myGarageList?[index].price.toString() ?? '',
                    date: dateFormatter.getFullDateFormat(),
                    imageUrl: controller.myGarageList?[index].images[0] ?? '',
                    onTap: () {
                      Get.to(() => ListingDetailsView(
                            id: controller.myGarageList?[index].id ?? '',
                          ));
                    },
                  ),
                );
              }),
        ),
      );
    });
  }
}
