// ignore_for_file: avoid_print
import 'package:dirve_society/app/modules/club/model/club_forum_model.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:dirve_society/services/network_caller/network_caller.dart';
import 'package:dirve_society/services/network_caller/network_response.dart';
import 'package:dirve_society/urls.dart';
import 'package:get/get.dart';

class AllClubForunController extends GetxController {
  final NetworkCaller networkCaller = Get.find<NetworkCaller>();

  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  var postList = <ClubForumItemModel>[].obs;
  List<ClubForumItemModel> get allPostList => postList;

  String? _otpToken;
  String? get otpToken => _otpToken;

  final int _limit = 5;
  int page = 0;

  int? lastPage;

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> getAllClubForum(String id) async {
    if (_inProgress) {
      return false;
    }
    page++;

    if (lastPage != null && page > lastPage!) return false;

    bool isSuccess = false;

    _inProgress = true;
    update();

    Map<String, dynamic> queryParams = {'limit': _limit, 'page': page};
    final NetworkResponse response = await networkCaller.getRequest(
      Urls.allClubForumsById(id),
      queryParams: queryParams,
      accesToken: StorageUtil.getData(StorageUtil.userAccessToken),
    );

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;

      ClubForumModel clubForumModel =
          ClubForumModel.fromJson(response.responseData);
      postList.addAll(clubForumModel.data);

      if (clubForumModel.meta?.totalPage != null) {
        lastPage = clubForumModel.meta!.totalPage;
      }
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }

  Future<bool> refreshClubForum(String id) async {
    if (_inProgress) return false;

    page = 0;
    lastPage = null;
    postList.clear();
    update();

    return getAllClubForum(id);
  }

  void updatePostLike(String postId, bool isLiked, int likeCount) {
    print(
        'Updating post like for postId: $postId, isLiked: $isLiked, likeCount: $likeCount');
    int index = postList.indexWhere((post) => post.contentMeta?.id == postId);
    if (index != -1) {
      print('Post found at index: $index');
      final post = postList[index];
      postList[index] = ClubForumItemModel(
        id: post.id,
        author: post.author,
        club: post.club,
        title: post.title,
        description: post.description,
        tags: post.tags,
        hideBy: post.hideBy,
        contentMeta: ContentMeta(
          id: post.contentMeta?.id,
          like: likeCount,
          likeBy: post.contentMeta?.likeBy ?? [],
          comment: post.contentMeta?.comment,
          disLikeBy: post.contentMeta?.disLikeBy ?? [],
        ),
        isDeleted: post.isDeleted,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        isLiked: isLiked,
        isDislike: post.isDislike,
        isFavorite: post.isFavorite,
        isHide: post.isHide,
      );
      postList.refresh(); // Refresh UI
      print('Post updated and list refreshed');
    } else {
      print('Post not found for postId: $postId');
    }
  }

  void updatePostDislike(String postId, bool isDisliked, int dislikeCount) {
    print(
        'Updating post dislike for postId: $postId, isDisliked: $isDisliked, dislikeCount: $dislikeCount');
    int index = postList.indexWhere((post) => post.contentMeta?.id == postId);
    if (index != -1) {
      print('Post found at index: $index');
      final post = postList[index];
      postList[index] = ClubForumItemModel(
        id: post.id,
        author: post.author,
        club: post.club,
        title: post.title,
        description: post.description,
        tags: post.tags,
        hideBy: post.hideBy,
        contentMeta: ContentMeta(
          id: post.contentMeta?.id,
          like: post.contentMeta?.like,
          likeBy: post.contentMeta?.likeBy ?? [],
          comment: post.contentMeta?.comment,
          disLikeBy: post.contentMeta?.disLikeBy ?? [],
        ),
        isDeleted: post.isDeleted,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        isLiked: post.isLiked,
        isDislike: isDisliked,
        isFavorite: post.isFavorite,
        isHide: post.isHide,
      );
      postList.refresh(); // Refresh UI
      print('Post updated and list refreshed');
    } else {
      print('Post not found for postId: $postId');
    }
  }

  void updatePostSave(String postId, bool isSaved) {
    print('Updating post save for postId: $postId, isSaved: $isSaved');
    int index = postList.indexWhere((post) => post.id == postId);
    if (index != -1) {
      print('Post found at index: $index');
      final post = postList[index];
      postList[index] = ClubForumItemModel(
        id: post.id,
        author: post.author,
        club: post.club,
        title: post.title,
        description: post.description,
        tags: post.tags,
        hideBy: post.hideBy,
        contentMeta: post.contentMeta,
        isDeleted: post.isDeleted,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        isLiked: post.isLiked,
        isDislike: post.isDislike,
        isFavorite: isSaved,
        isHide: post.isHide,
      );
      postList.refresh();
      print('Post updated and list refreshed');
    } else {
      print('Post not found for postId: $postId');
    }
  }

  void updatePostUnSave(String postId, bool isSaved) {
    updatePostSave(postId, isSaved);
  }

  void updatePostHide(String postId, bool isHidden) {
    print('Updating post hide for postId: $postId, isHidden: $isHidden');
    int index = postList.indexWhere((post) => post.id == postId);
    if (index != -1) {
      print('Post found at index: $index');
      final post = postList[index];
      postList[index] = ClubForumItemModel(
        id: post.id,
        author: post.author,
        club: post.club,
        title: post.title,
        description: post.description,
        tags: post.tags,
        hideBy: post.hideBy,
        contentMeta: post.contentMeta,
        isDeleted: post.isDeleted,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        isLiked: post.isLiked,
        isDislike: post.isDislike,
        isFavorite: post.isFavorite,
        isHide: isHidden,
      );
      postList.refresh();
      print('Post updated and list refreshed');
    } else {
      print('Post not found for postId: $postId');
    }
  }

  void updatePostComment(String postId, int commentCount) {
    print(
        'Updating post comment for postId: $postId, commentCount: $commentCount');
    int index = postList.indexWhere((post) => post.id == postId);
    if (index != -1) {
      print('Post found at index: $index');
      final post = postList[index];
      postList[index] = ClubForumItemModel(
        id: post.id,
        author: post.author,
        club: post.club,
        title: post.title,
        description: post.description,
        tags: post.tags,
        hideBy: post.hideBy,
        contentMeta: ContentMeta(
          id: post.contentMeta?.id,
          like: post.contentMeta?.like,
          likeBy: post.contentMeta?.likeBy ?? [],
          comment: commentCount,
          disLikeBy: post.contentMeta?.disLikeBy ?? [],
        ),
        isDeleted: post.isDeleted,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        isLiked: post.isLiked,
        isDislike: post.isDislike,
        isFavorite: post.isFavorite,
        isHide: post.isHide,
      );
      postList.refresh();
      print('Post updated and list refreshed');
    } else {
      print('Post not found for postId: $postId');
    }
  }
}
