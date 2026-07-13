import 'package:dirve_society/app/modules/profile/others/controller/others_feed_controller.dart';
import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OthersFeedScreen extends StatefulWidget {
  final String authorId;

  const OthersFeedScreen({super.key, required this.authorId});

  @override
  State<OthersFeedScreen> createState() => _OthersFeedScreenState();
}

class _OthersFeedScreenState extends State<OthersFeedScreen> {
  final OthersClubFeedController othersClubFeedController =
      Get.put(OthersClubFeedController());

  @override
  void initState() {
    super.initState();
    print('Author ID: ${widget.authorId}');
    othersClubFeedController.getOthersAllClubFeed(widget.authorId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Expanded(
            child: GetBuilder<OthersClubFeedController>(
              builder: (controller) {
                if (controller.inProgress) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (controller.allPostList == null ||
                    controller.allPostList!.isEmpty) {
                  return const SizedBox(
                    height: 300,
                    child: Center(
                      child: Text('No Post Found'),
                    ),
                  );
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: controller.allPostList?.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                              controller.allPostList![index].content.first,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
