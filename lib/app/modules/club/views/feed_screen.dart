import 'package:dirve_society/app/modules/club/controllers/all_club_field_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/dis_react_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/react_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/save_post_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/un_saved_post_controller.dart';
import 'package:dirve_society/app/modules/home/views/comment_screen.dart';
import 'package:dirve_society/app/modules/home/views/date_formatter.dart';
import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/helper/post_card.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedScreen extends StatefulWidget {
  final String clubId;
  final String authorId;

  const FeedScreen({super.key, required this.clubId, required this.authorId});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final AllClubFeedController allClubFeedController =
      Get.put(AllClubFeedController());

  final ReactPostController reactPostController =
      Get.put(ReactPostController());
  final DisReactPostController disReactPostController =
      Get.put(DisReactPostController());
  final SavePostController savePostController = Get.put(SavePostController());
  final UnSavedPostController unSavedPostController =
      Get.put(UnSavedPostController());

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    allClubFeedController.getAllClubFeed(widget.clubId);
    scrollController.addListener(_loadMoreData);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void _loadMoreData() {
    if (scrollController.position.extentAfter < 500 &&
        !allClubFeedController.inProgress) {
      print('Load more data');
      allClubFeedController.getAllClubFeed(widget.clubId);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> reactPost(String postId) async {
    print('Attempting to like post with ID: $postId');
    final bool isSuccess = await reactPostController.reactPost(postId);
    if (isSuccess) {
      int index = allClubFeedController.postList
          .indexWhere((post) => post.contentMeta?.id == postId);
      print('Index found: $index');
      if (index != -1) {
        int currentLikes =
            allClubFeedController.postList[index].contentMeta?.like ?? 0;
        print('Current likes: $currentLikes');

        allClubFeedController.updatePostLike(postId, true, currentLikes + 1);
        if (mounted) {
          // showSnackBarMessage(context, 'Like successfully completed');
        }
      } else {
        print('Post not found for ID: $postId');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            reactPostController.errorMessage ?? 'Failed to like', true);
      }
    }
  }

  Future<void> disReactPost(String postId) async {
    print('Attempting to dislike post with ID: $postId');
    final bool isSuccess = await disReactPostController.disReactPost(postId);
    if (isSuccess) {
      int index = allClubFeedController.postList
          .indexWhere((post) => post.contentMeta?.id == postId);
      print('Index found: $index');
      if (index != -1) {
        int currentLikes =
            allClubFeedController.postList[index].contentMeta?.like ?? 0;
        print('Current likes: $currentLikes');
        allClubFeedController.updatePostLike(
            postId, false, currentLikes > 0 ? currentLikes - 1 : 0);
        if (mounted) {
          // showSnackBarMessage(context, 'Dislike successfully completed');
        }
      } else {
        print('Post not found for ID: $postId');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            disReactPostController.errorMessage ?? 'Failed to dislike', true);
      }
    }
  }

  Future<void> savePost(String userId, String contentId) async {
    print('Attempting to save post with ID: $contentId');
    final bool isSuccess =
        await savePostController.savePostF(userId, contentId);
    if (isSuccess) {
      allClubFeedController.updatePostSave(contentId, true);
      if (mounted) {
        showSnackBarMessage(context, 'Post saved successfully');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            savePostController.errorMessage ?? 'Failed to save post', true);
      }
    }
  }

  Future<void> unSavePost(String postId) async {
    print('Attempting to unsave post with ID: $postId');
    final bool isSuccess =
        await unSavedPostController.unSavePost(postId: postId);
    if (isSuccess) {
      allClubFeedController.updatePostUnSave(postId, false);
      if (mounted) {
        showSnackBarMessage(context, 'Post unsaved successfully');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
            context,
            unSavedPostController.errorMessage ?? 'Failed to unsave post',
            true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        print(
            'Obx rebuild triggered with postList length: ${allClubFeedController.postList.length}');
        if (allClubFeedController.inProgress &&
            allClubFeedController.page == 1) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (allClubFeedController.postList.isEmpty) {
          return const Center(
            child: Text(
              'No posts available',
              style: TextStyle(color: AppColors.black),
            ),
          );
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.only(bottom: 30),
            itemCount: allClubFeedController.postList.length,
            itemBuilder: (context, index) {
              final feed = allClubFeedController.postList[index];
              final dateFormatter =
                  DateFormatter(feed.createdAt ?? DateTime.now());
              return feed.isHide == false
                  ? PostCard(
                      profileImage: feed.author?.photoUrl ?? '',
                      clubName: feed.author?.name ?? '',
                      userName: feed.author?.name ?? 'Unknown',
                      contentPath:
                          feed.content.isNotEmpty ? feed.content[0] : '',
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
                      onLikeTap: () {
                        print(
                            'Like tapped for post ID: ${feed.contentMeta?.id}');
                        feed.isLiked == true
                            ? disReactPost(feed.contentMeta?.id ?? '')
                            : reactPost(feed.contentMeta?.id ?? '');
                      },
                      onCommentTap: () {
                        Get.to(CommentScreen(
                          postId: feed.id ?? '',
                          postType: 'feed',
                          // onCommentPosted: (newCommentCount) {
                          //   allFeedController.updatePostComment(feed.id ?? '', newCommentCount);
                          // },
                        ));
                      },
                      onBookmarkTap: () {
                        print('Bookmark tapped for post ID: ${feed.id}');
                        feed.isFavorite == true
                            ? unSavePost(feed.id ?? '')
                            : savePost(
                                StorageUtil.getData(StorageUtil.profileId) ??
                                    '',
                                feed.id ?? '',
                              );
                      },
                    )
                  : Container();
            },
          );
        }
      }),
    );
  }
}
