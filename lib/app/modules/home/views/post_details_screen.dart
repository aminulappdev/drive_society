import 'package:dirve_society/app/modules/home/controllers/feed/post_details_controller.dart';
import 'package:dirve_society/app/modules/home/views/date_formatter.dart';
import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/helper/post_card.dart';
import 'package:dirve_society/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class PostDetailsScreen extends StatefulWidget {
  String? postId;
  PostDetailsScreen({super.key, this.postId});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final FeedDetailsController feedDetailsController =
      Get.put(FeedDetailsController());

  @override
  void initState() {
    feedDetailsController.getMyFeed(widget.postId ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sh16,
            sh16,
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(width: 8,),
                Text(
                  'Post Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            sh16,
            GetBuilder<FeedDetailsController>(builder: (context) {
              if (feedDetailsController.inProgress) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
        
              var feed = feedDetailsController.postDetailsModel?.data;
              final dateFormatter =
                  DateFormatter(feed?.createdAt ?? DateTime.now());
              return PostCard(
                profileImage: feed?.author?.photoUrl ?? '',
                clubName: feed?.author?.name ?? '',
                userName: feed?.author?.name ?? 'Unknown',
                contentPaths: feed!.content,
                description: feed.description ?? '',
                hashtags: feed.tags.isNotEmpty ? feed.tags[0] : '',
                date: dateFormatter.getRelativeTimeFormat(),
                likes: feed.contentMeta?.like ?? 0,
                comments: feed.contentMeta?.comment ?? 0,
                isLiked: feed.isLiked ?? false,
                isSaved: feed.isFavorite ?? false,
                onProfileTap: () {
                  // Navigate to profile (implement as needed)
                },
                onMenuTap: () {
                  // Implement menu/bottom sheet (implement as needed)
                },
                onLikeTap: () {},
                onCommentTap: () {},
                onBookmarkTap: () {},
              );
            }),
          ],
        ),
      ),
    );
  }
}
