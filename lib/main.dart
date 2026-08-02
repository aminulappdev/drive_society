import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dirve_society/services/network_caller/network_caller.dart';

import 'app/routes/app_pages.dart';

void main()async {
  await GetStorage.init();
  Get.put(NetworkCaller(), permanent: true);
  runApp(
    GetMaterialApp(
      title: "Drive Society",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ), 
  );
}


//  final dateFormatter = DateFormatter(
//                           controller.myGarageList?[index].createdAt ??
//                               DateTime.now());
