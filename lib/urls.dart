class Urls {
  // static const String _baseUrl = 'http://10.10.10.16:5006/api/v1';
  static const String _baseUrl = 'https://api.drivesociety.net/api/v1';
  static const String socketUrl = 'https://socket.drivesociety.net';
  // static const String socketUrl = 'http://192.168.10.144:4001/';
  static const String signUpUrl = '$_baseUrl/profiles/register';
  static const String otpVerifyUrl = '$_baseUrl/otp/verify-otp';
  static const String resendOtpUrl = '$_baseUrl/otp/resend-otp';
  static const String loginUrl = '$_baseUrl/auth/login';
  static const String forgotPasswordUrl = '$_baseUrl/auth/forget-password';
  static const String changePasswordUrl = '$_baseUrl/auth/change-password';
  static const String restePasswordUrl = '$_baseUrl/auth/reset-password';
  static const String profileUrl = '$_baseUrl/profiles/my-profile';
  static const String editProfileUrl = '$_baseUrl/profiles/update-my-profile';
  static const String allfeedUrl = '$_baseUrl/feeds';
  static const String myfeedUrl = '$_baseUrl/feeds/my-feed';
  static const String carRatingUrl = '$_baseUrl/car-ratings';
  static const String myGarageUrl = '$_baseUrl/cars/my-car';
  static const String carUrl = '$_baseUrl/cars';
  static const String myClubUrl = '$_baseUrl/clubs/my-club';
  static const String myFavouriteUrl = '$_baseUrl/favorite/my-favorite';
  static const String createClubUrl = '$_baseUrl/clubs';
  static const String createPostUrl = '$_baseUrl/feeds';
  static const String createMeetUrl = '$_baseUrl/meets';
  static const String addStoryUrl = '$_baseUrl/stories';
  static const String allPendingConnection =
      '$_baseUrl/connect-requests/my-connection';
  static const String allmarketPlaceUrl = '$_baseUrl/cars/marketplace';
  static const String contentUrl = '$_baseUrl/contents';
  static const String addCarUrl = '$_baseUrl/cars';
  static const String reviewUrl = '$_baseUrl/reviews';
  static const String favouriteUrl = '$_baseUrl/favorite';
  static const String allStoryUrl = '$_baseUrl/stories';
  static const String clubDetailsUrl = '$_baseUrl/stories';
  static const String peopleMayKnowUrl = '$_baseUrl/profiles/discover-profile';
  static const String allPeopleUrl = '$_baseUrl/profiles';
  static const String discoverClubUrl = '$_baseUrl/clubs/discover';
  static const String addConnectionRequestUrl = '$_baseUrl/connect-requests';
  static const String allMeetUrl = '$_baseUrl/meets';
  static const String createForumUrl = '$_baseUrl/forums';
  static const String myjoiningClub =
      '$_baseUrl/connect-requests/club-connection';
  static const String addInvitePeopleUrl =
      '$_baseUrl/connect-requests/club-invitation';
  static const String packageUrl = '$_baseUrl/packages';
  static const String subscriptionUrl = '$_baseUrl/subscriptions';
  static const String paymentCheckoutUrl = '$_baseUrl/payments/checkout';
  static const String addChatUrl = '$_baseUrl/chats';
  static const String filterUrl = '$_baseUrl/cars/filters';

  static String getMarketPlaceUrlById(
    String id,
  ) {
    return '$_baseUrl/cars/$id';
  }

  static String getChatIdUrlById(
    String id,
  ) {
    return '$_baseUrl/chats/user/$id';
  }

  static String otherProfileById(
    String id,
  ) {
    return '$_baseUrl/profiles/$id';
  }

  static String otherGarageById(
    String id,
  ) {
    return '$_baseUrl/cars/user/$id';
  }

  static String feedsById(
    String id,
  ) {
    return '$_baseUrl/feeds/$id';
  }

  static String storyById(
    String id,
  ) {
    return '$_baseUrl/stories/user/$id';
  }

  static String allClubFielsById(
    String id,
    String type,
  ) {
    return '$_baseUrl/feeds/$type/$id';
  }

  static String changeConnectionRequestById(
    String id,
  ) {
    return '$_baseUrl/connect-requests/user-connection/$id';
  }

  static String editClubById(
    String id,
  ) {
    return '$_baseUrl/clubs/$id';
  }

  static String deleteClubById(
    String id,
  ) {
    return '$_baseUrl/clubs/$id';
  }

  static String leaveClubById(
    String id,
  ) {
    return '$_baseUrl/clubs/leave-club/$id';
  }

  static String changeAdminById(
    String id,
  ) {
    return '$_baseUrl/clubs/transfer-ownership/$id';
  }

  static String allClubMembersByClubId(
    String id,
  ) {
    return '$_baseUrl/connect-requests/club-members/$id';
  }

  static String allClubForumsById(
    String id,
  ) {
    return '$_baseUrl/forums/club/$id';
  }

  static String clubDetailsUrlById(
    String id,
  ) {
    return '$_baseUrl/clubs/$id';
  }

  static String allInvitePeopleById(
    String id,
  ) {
    return '$_baseUrl/clubs/invite/$id';
  }

  static String getReviewById(
    String id,
  ) {
    return '$_baseUrl/reviews/reference/$id';
  }

  static String sellTaggleById(
    String id,
  ) {
    return '$_baseUrl/cars/sale/$id';
  }

  static String updateUserByUrl(
    String id,
  ) {
    return '$_baseUrl/users/update/$id';
  }

  // old package
  static const String savePostUrl = '$_baseUrl/watch-later';
  static const String feedPostUrl = '$_baseUrl/feeds';
  static const String reelsPostUrl = '$_baseUrl/reels';
  static const String createWishListUrl = '$_baseUrl/wishlists';
  static const String allWishListUrl = '$_baseUrl/wishlists/my-wishlist';
  static const String allFriendsChatnUrl = '$_baseUrl/chats/my-chat-list';
  static const String reportUserUrl = '$_baseUrl/reports';
  static const String sendMessageUrl = '$_baseUrl/messages/send-messages';
  static const String notificationUrl = '$_baseUrl/notification';
  static const String mySavePostUrl = '$_baseUrl/watch-later/my-watch-later';
  static const String allBlockersUrl = '$_baseUrl/profile-block/my-block';
  static const String allUserssUrl = '$_baseUrl/users/public';
  static const String sendCommentUrl = '$_baseUrl/comments';

  static String commentByContentId(
    String id,
  ) {
    return '$_baseUrl/comments/content/$id';
  }

  static String postDetailsById(
    String id,
  ) {
    return '$_baseUrl/feeds/$id';
  }

  static String allFollowersById(
    String id,
  ) {
    return '$_baseUrl/connection/followers/$id';
  }

  static String allFollowingById(
    String id,
  ) {
    return '$_baseUrl/connection/following/$id';
  }

  static String othersWishlistById(
    String id,
  ) {
    return '$_baseUrl/wishlists/user/$id';
  }

  static String allFeedById(
    String id,
  ) {
    return '$_baseUrl/feeds/user/$id';
  }

  static String otherUserByUrl(
    String id,
  ) {
    return '$_baseUrl/users/$id';
  }

  static String confirmedPaymentUrlsById(
    String id,
  ) {
    return '$_baseUrl/payments/reference/$id';
  }

  static String followRequestById(
    String id,
  ) {
    return '$_baseUrl/connection/follow/$id';
  }

  static String unfollowRequestById(
    String id,
  ) {
    return '$_baseUrl/connection/unfollow/$id';
  }

  static String reactById(
    String id,
  ) {
    return '$_baseUrl/content-meta/like/$id';
  }

  static String disReactById(
    String id,
  ) {
    return '$_baseUrl/content-meta/unlike/$id';
  }

  static String wishlistById(
    String id,
  ) {
    return '$_baseUrl/wishlists/$id';
  }

  static String blockUserById(
    String id,
  ) {
    return '$_baseUrl/profile-block/block/$id';
  }

  static String getMessagesUrl(
    String id,
  ) {
    return '$_baseUrl/messages/my-messages/$id';
  }

  static String deleteAccountById(
    String id,
  ) {
    return '$_baseUrl/users/$id';
  }

  static String deleteSavePostById(
    String id,
  ) {
    return '$_baseUrl/watch-later/$id';
  }

  static String deleteChatDataById(
    String id,
  ) {
    return '$_baseUrl/messages/chat/$id';
  }

  static String unSavePostById(
    String id,
  ) {
    return '$_baseUrl/favorite/content/$id';
  }

  static String userUnblockById(
    String id,
  ) {
    return '$_baseUrl/profile-block/unblock/$id';
  }
}
