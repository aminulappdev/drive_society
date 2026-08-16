import 'package:dirve_society/app/modules/club/controllers/all_club_forum_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/dis_react_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/react_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/save_post_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/un_saved_post_controller.dart';
import 'package:dirve_society/app/modules/home/views/comment_screen.dart';
import 'package:dirve_society/app/modules/home/views/date_formatter.dart';
import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/helper/forum_card.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dirve_society/common/app_images/app_images.dart';

class ForumScreen extends StatefulWidget {
  final String clubName;
  final String clubId;
  final String authorId;
  const ForumScreen(
      {super.key,
      required this.clubId,
      required this.authorId,
      required this.clubName});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final AllClubForunController allClubForumController =
      Get.put(AllClubForunController());
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
    allClubForumController.getAllClubForum(widget.clubId);
    scrollController.addListener(_loadMoreData);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void _loadMoreData() {
    if (scrollController.position.extentAfter < 500 &&
        !allClubForumController.inProgress) {
      print('Load more data');
      allClubForumController.getAllClubForum(widget.clubId);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> reactPost(String postId, bool isDisliked, bool isLiked) async {
    if (isDisliked) {
      if (mounted) {
        showSnackBarMessage(
            context, 'Cannot like a post that is already disliked', true);
      }
      return;
    }
    print('Attempting to like/unlike post with ID: $postId');
    if (isLiked) {
      // Unlike the post
      final bool isSuccess = await disReactPostController.disReactPost(postId);
      if (isSuccess) {
        int index = allClubForumController.postList
            .indexWhere((post) => post.contentMeta?.id == postId);
        print('Index found: $index');
        if (index != -1) {
          int currentLikes =
              allClubForumController.postList[index].contentMeta?.like ?? 0;
          print('Current likes: $currentLikes');
          allClubForumController.updatePostLike(
              postId, false, currentLikes > 0 ? currentLikes - 1 : 0);
          if (mounted) {
            showSnackBarMessage(context, 'Like removed successfully');
          }
        } else {
          print('Post not found for ID: $postId');
        }
      } else {
        if (mounted) {
          showSnackBarMessage(
              context,
              disReactPostController.errorMessage ?? 'Failed to remove like',
              true);
        }
      }
    } else {
      // Like the post
      final bool isSuccess = await reactPostController.reactPost(postId);
      if (isSuccess) {
        int index = allClubForumController.postList
            .indexWhere((post) => post.contentMeta?.id == postId);
        print('Index found: $index');
        if (index != -1) {
          int currentLikes =
              allClubForumController.postList[index].contentMeta?.like ?? 0;
          print('Current likes: $currentLikes');
          allClubForumController.updatePostLike(postId, true, currentLikes + 1);
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
  }

  Future<void> disReactPost(
      String postId, bool isLiked, bool isDisliked) async {
    if (isLiked) {
      if (mounted) {
        showSnackBarMessage(
            context, 'Cannot dislike a post that is already liked', true);
      }
      return;
    }
    print('Attempting to dislike/undislike post with ID: $postId');
    if (isDisliked) {
      // Undislike the post
      final bool isSuccess = await disReactPostController.disReactPost(postId);
      if (isSuccess) {
        int index = allClubForumController.postList
            .indexWhere((post) => post.contentMeta?.id == postId);
        print('Index found: $index');
        if (index != -1) {
          int currentDislikes = allClubForumController
                  .postList[index].contentMeta?.disLikeBy?.length ??
              0;
          print('Current dislikes: $currentDislikes');
          allClubForumController.updatePostDislike(
              postId, false, currentDislikes > 0 ? currentDislikes - 1 : 0);
          if (mounted) {
            showSnackBarMessage(context, 'Dislike removed successfully');
          }
        } else {
          print('Post not found for ID: $postId');
        }
      } else {
        if (mounted) {
          showSnackBarMessage(
              context,
              disReactPostController.errorMessage ?? 'Failed to remove dislike',
              true);
        }
      }
    } else {
      // Dislike the post
      final bool isSuccess = await disReactPostController.disReactPost(postId);
      if (isSuccess) {
        int index = allClubForumController.postList
            .indexWhere((post) => post.contentMeta?.id == postId);
        print('Index found: $index');
        if (index != -1) {
          int currentDislikes = allClubForumController
                  .postList[index].contentMeta?.disLikeBy?.length ??
              0;
          print('Current dislikes: $currentDislikes');
          allClubForumController.updatePostDislike(
              postId, true, currentDislikes + 1);
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
  }

  Future<void> savePost(String userId, String contentId) async {
    print('Attempting to save post with ID: $contentId');
    final bool isSuccess =
        await savePostController.savePostF(userId, contentId);
    if (isSuccess) {
      allClubForumController.updatePostSave(contentId, true);
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
      allClubForumController.updatePostUnSave(postId, false);
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
    return Obx(() {
        print(
            'Obx rebuild triggered with postList length: ${allClubForumController.postList.length}');
        if (allClubForumController.inProgress &&
            allClubForumController.page == 1) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (allClubForumController.postList.isEmpty) {
          return const Center(
            child: Text(
              'No forum posts available',
              style: TextStyle(color: AppColors.black),
            ),
          );
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.only(bottom: 30),
            itemCount: allClubForumController.postList.length,
            itemBuilder: (context, index) {
              final forumPost = allClubForumController.postList[index];
              final dateFormatter =
                  DateFormatter(forumPost.createdAt ?? DateTime.now());
              return forumPost.isHide == false
                  ? ForumCard(
                      imagePath:
                          forumPost.author?.photoUrl ?? AppImages.carImage,
                      clubName: widget.clubName,
                      author: forumPost.author?.name ?? 'Unknown',
                      date: dateFormatter.getRelativeTimeFormat(),
                      title: forumPost.title ?? '',
                      description: forumPost.description ?? '',
                      likeData: forumPost.isLiked == true
                          ? Icons.thumb_up
                          : Icons.thumb_up_off_alt,
                      dislikeData: forumPost.isDislike == true
                          ? Icons.thumb_down
                          : Icons.thumb_down_off_alt,
                      commentsImage: AppImages.chat,
                      comments: forumPost.contentMeta?.comment ?? 0,
                      likes: forumPost.contentMeta?.like ?? 0,
                      dislikes: forumPost.contentMeta?.disLikeBy?.length ?? 0,
                      onTap: () {
                        Get.to(CommentScreen(
                          postId: forumPost.id ?? '',
                          postType: 'forum',
                        ));
                      },
                      onLikeTap: () {
                        print(
                            'Like tapped for post ID: ${forumPost.contentMeta?.id}');
                        reactPost(
                          forumPost.contentMeta?.id ?? '',
                          forumPost.isDislike ?? false,
                          forumPost.isLiked ?? false,
                        );
                      },
                      onDislikeTap: () {
                        print(
                            'Dislike tapped for post ID: ${forumPost.contentMeta?.id}');
                        disReactPost(
                          forumPost.contentMeta?.id ?? '',
                          forumPost.isLiked ?? false,
                          forumPost.isDislike ?? false,
                        );
                      },
                      onCommentTap: () {
                        Get.to(CommentScreen(
                          postId: forumPost.id ?? '',
                          postType: 'forum',
                        ));
                      },
                      onBookmarkTap: () {
                        print('Bookmark tapped for post ID: ${forumPost.id}');
                        forumPost.isFavorite == true
                            ? unSavePost(forumPost.id ?? '')
                            : savePost(
                                StorageUtil.getData(StorageUtil.profileId) ??
                                    '',
                                forumPost.id ?? '',
                              );
                      },
                    )
                  : Container();
            },
            );
        }
      });
  }
}
