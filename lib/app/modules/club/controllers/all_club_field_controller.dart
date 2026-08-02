// ignore_for_file: avoid_print
import 'package:dirve_society/app/modules/home/model/all_feed_model.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:dirve_society/services/network_caller/network_caller.dart';
import 'package:dirve_society/services/network_caller/network_response.dart';
import 'package:dirve_society/urls.dart';
import 'package:get/get.dart';

class AllClubFeedController extends GetxController {
  final NetworkCaller networkCaller = Get.find<NetworkCaller>();

  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  var postList = <AllFeedItemModel>[].obs;
  List<AllFeedItemModel> get allPostList => postList;

  String? _otpToken;
  String? get otpToken => _otpToken;

  final int _limit = 5;
  int page = 0;

  int? lastPage;

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> getAllClubFeed(String id) async {
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
      Urls.allClubFielsById(id, 'club'),
      queryParams: queryParams,
      accesToken: StorageUtil.getData(StorageUtil.userAccessToken),
    );

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;

      AllFeedModel allFeedModel = AllFeedModel.fromJson(response.responseData);
      postList.addAll(allFeedModel.data);

      if (allFeedModel.meta?.totalPage != null) {
        lastPage = allFeedModel.meta!.totalPage;
      }
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }

  Future<bool> refreshClubFeed(String id) async {
    if (_inProgress) return false;

    page = 0;
    lastPage = null;
    postList.clear();
    update();

    return getAllClubFeed(id);
  }

  void updatePostLike(String postId, bool isLiked, int likeCount) {
    print(
        'Updating post like for postId: $postId, isLiked: $isLiked, likeCount: $likeCount');
    int index = postList.indexWhere((post) => post.contentMeta?.id == postId);
    if (index != -1) {
      print('Post found at index: $index');
      final post = postList[index];
      postList[index] = AllFeedItemModel(
        location: post.location,
        hideBy: post.hideBy,
        id: post.id,
        author: post.author,
        club: post.club,
        content: post.content,
        description: post.description,
        tags: post.tags,
        contentMeta: ContentMeta(
          id: post.contentMeta?.id,
          like: likeCount,
          likeBy: post.contentMeta?.likeBy ?? [],
          comment: post.contentMeta?.comment,
        ),
        isDeleted: post.isDeleted,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        isLiked: isLiked,
        isVisible: post.isVisible,
        isFavorite: post.isFavorite,
        isHide: post.isHide,
      );
      postList.refresh(); // UI আপডেটের জন্য
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
      postList[index] = AllFeedItemModel(
        location: post.location,
        hideBy: post.hideBy,
        id: post.id,
        author: post.author,
        club: post.club,
        content: post.content,
        description: post.description,
        tags: post.tags,
        contentMeta: post.contentMeta,
        isDeleted: post.isDeleted,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        isLiked: post.isLiked,
        isVisible: post.isVisible,
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
      postList[index] = AllFeedItemModel(
        location: post.location,
        hideBy: post.hideBy,
        id: post.id,
        author: post.author,
        club: post.club,
        content: post.content,
        description: post.description,
        tags: post.tags,
        contentMeta: post.contentMeta,
        isDeleted: post.isDeleted,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        isLiked: post.isLiked,
        isVisible: post.isVisible,
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
      postList[index] = AllFeedItemModel(
        location: post.location,
        hideBy: post.hideBy,
        id: post.id,
        author: post.author,
        club: post.club,
        content: post.content,
        description: post.description,
        tags: post.tags,
        contentMeta: ContentMeta(
          id: post.contentMeta?.id,
          like: post.contentMeta?.like,
          likeBy: post.contentMeta?.likeBy ?? [],
          comment: commentCount,
        ),
        isDeleted: post.isDeleted,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        isLiked: post.isLiked,
        isVisible: post.isVisible,
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
