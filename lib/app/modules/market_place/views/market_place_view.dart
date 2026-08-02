import 'package:dirve_society/app/modules/home/views/date_formatter.dart';
import 'package:dirve_society/app/modules/market_place/controllers/market_place_controller.dart';
import 'package:dirve_society/app/modules/market_place/views/filter_view.dart';
import 'package:dirve_society/app/modules/market_place/views/listing_details_view.dart';
import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/app_images/app_images.dart';
import 'package:dirve_society/common/app_text_style/styles.dart';
import 'package:dirve_society/common/helper/market_place_widget.dart';
import 'package:dirve_society/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarketPlaceView extends StatefulWidget {
  const MarketPlaceView({super.key});

  @override
  State<MarketPlaceView> createState() => _MarketPlaceViewState();
}

class _MarketPlaceViewState extends State<MarketPlaceView> {
  final AllMarketplaceController allMarketplaceController =
      Get.put(AllMarketplaceController());
  
  String search = '';
  Map<String, dynamic> appliedFilters = {};

  @override
  void initState() {
    allMarketplaceController.getAllMarketPlace();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.mainColor,
        title: Text(
          'Marketplace',
          style: appBarStyle.copyWith(color: AppColors.darkRed),
        ),
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard on tap
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: AppColors.borderColor),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.grey,
                          ),
                        ),
                        onChanged: (value) { 
                          setState(() {
                            search = value; // Update search query
                          });
                        },
                      ),
                    ),
                  ),
                  sw8,
                  GestureDetector(
                    onTap: () async {
                      final result = await Get.to<Map<String, dynamic>>(
                        () => const FilterView(),
                      );
                      if (result != null) {
                        appliedFilters = result;
                        allMarketplaceController.getAllMarketPlace(
                          queryParamsData: result,
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: AppColors.borderColor,
                        ),
                      ),
                      child: Image.asset(
                        AppImages.filter,
                        scale: 4,
                      ),
                    ),
                  ),
                ],
              ),
              sh16,
              Expanded(
                child:
                    GetBuilder<AllMarketplaceController>(builder: (controller) {
                  if (controller.inProgress) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Keep local search for quick brand search on top of backend filters.
                  final filteredItems =
                      controller.allMarketPlaceList?.where((item) {
                            final brand = item.brand?.toLowerCase() ?? '';
                            return search.isEmpty ||
                                brand.contains(search.toLowerCase());
                          }).toList() ??
                          [];

                  if (filteredItems.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.search,
                            height: 80,
                            width: 95,
                          ),
                          Text(
                            'No results for "${search.isEmpty ? 'Item' : search}"',
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'We couldn’t find any matching results. Please refine your search or check back later.',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.only(bottom: 20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 250,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final dateFormatter = DateFormatter(
                          filteredItems[index].createdAt ?? DateTime.now());
                      return MarketPlaceWidget(
                        name: filteredItems[index].brand ?? '',
                        price: filteredItems[index].price.toString(),
                        date: dateFormatter.getRelativeTimeFormat(),
                        imageUrl: filteredItems[index].banner ??
                            '', // Fallback to placeholder
                        onTap: () {
                          Get.to(() => ListingDetailsView(
                                id: filteredItems[index].id ?? '',
                              ));
                        },
                        
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
}
