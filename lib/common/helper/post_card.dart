// post_card.dart
// ignore_for_file: unused_local_variable

import 'package:dirve_society/app/modules/profile/others/views/others_profile_screen.dart';
import 'package:dirve_society/common/helper/media_cobtainer.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:readmore/readmore.dart';
import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/app_images/app_images.dart';
import 'package:dirve_society/common/app_text_style/styles.dart';
import 'package:dirve_society/common/size_box/custom_sizebox.dart';

class PostCard extends StatelessWidget {
  final String? id;
  final String profileImage;
  final String clubName;
  final String userName;
  final List<String> contentPaths;
  final String description;
  final String hashtags;
  final String date;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isSaved;
  final VoidCallback onProfileTap;
  final VoidCallback onMenuTap;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onBookmarkTap;

  const PostCard({
    super.key,
    required this.profileImage,
    required this.clubName,
    required this.userName,
    required this.contentPaths,
    required this.description,
    required this.hashtags,
    required this.date,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.isSaved,
    required this.onProfileTap,
    required this.onMenuTap,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onBookmarkTap,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    print('PostCard build: likes=$likes, isLiked=$isLiked, isSaved=$isSaved');
    return GestureDetector(
      onTap: onProfileTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => OthersProfileView(
                        authorId: id!,
                      ));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(profileImage),
                    ),
                    sw8,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clubName,
                          style: h5.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Text(
                        //   'BY $userName'.toUpperCase(),
                        //   style: h7,
                        // ),
                      ],
                    ),
                    // Spacer(),
                    // GestureDetector(
                    //   onTap: onMenuTap,
                    //   child: Container(
                    //     padding: EdgeInsets.all(8),
                    //     decoration: ShapeDecoration(
                    //       shape: CircleBorder(),
                    //       color: AppColors.silver,
                    //     ),
                    //     child: Image.asset(
                    //       AppImages.menu,
                    //       scale: 4,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            // Media Content
            contentPaths.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _PostMediaCarousel(contentPaths: contentPaths),
                  )
                : Container(),
            // Post Actions
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 4.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onLikeTap,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.silver,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                          sw5,
                          Text(
                            likes.toString(),
                            style: h6.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  sw16,
                  GestureDetector(
                    onTap: onCommentTap,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.silver,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            AppImages.chat,
                            scale: 4,
                          ),
                          sw5,
                          Text(
                            comments.toString(),
                            style: h6.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onBookmarkTap,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.silver,
                      ),
                      child: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved ? Colors.blue : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            sh5,
            // Post Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userName,
                        style: h6.copyWith(fontWeight: FontWeight.w600),
                      ),
                      // sw8,
                      // Expanded(
                      //   child: Text(
                      //     hashtags,
                      //     style: h6.copyWith(
                      //       fontWeight: FontWeight.w600,
                      //       color: AppColors.red,
                      //     ),
                      //     maxLines: 1,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // )
                    ],
                  ),
                  sh5,
                  ReadMoreText(
                    description,
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show More',
                    trimExpandedText: ' Show Less',
                    style: h6,
                    moreStyle: h6.copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                    lessStyle: h6.copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 4,
              ),
              child: Text(
                date,
                style: h6,
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

class _PostMediaCarousel extends StatefulWidget {
  const _PostMediaCarousel({required this.contentPaths});

  final List<String> contentPaths;

  @override
  State<_PostMediaCarousel> createState() => _PostMediaCarouselState();
}

class _PostMediaCarouselState extends State<_PostMediaCarousel> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: widget.contentPaths.length,
            onPageChanged: (index) => setState(() => currentPage = index),
            itemBuilder: (context, index) => MediaContainer(
              mediaPath: widget.contentPaths[index],
              height: 280,
              width: MediaQuery.of(context).size.width,
              borderColor: Colors.white,
              borderRadius: 12,
            ),
          ),
          if (widget.contentPaths.length > 1) ...[
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${currentPage + 1}/${widget.contentPaths.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.contentPaths.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: currentPage == index ? 16 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? AppColors.white
                          : AppColors.white.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
