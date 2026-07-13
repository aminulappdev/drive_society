class ProfileDetailsModel {
    ProfileDetailsModel({
        required this.success,
        required this.statusCode,
        required this.message,
        required this.data,
    });

    final bool? success;
    final int? statusCode;
    final String? message;
    final ProfileData? data;

    factory ProfileDetailsModel.fromJson(Map<String, dynamic> json){ 
        return ProfileDetailsModel(
            success: json["success"],
            statusCode: json["statusCode"],
            message: json["message"],
            data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
        );
    }

}

class ProfileData {
    ProfileData({
        required this.id,
        required this.name,
        required this.email,
        required this.photoUrl,
        required this.bio,
        required this.address,
        required this.addressTwo,
        required this.poBox,
        required this.city,
        required this.postalCode,
        required this.scores,
        required this.status,
        required this.dataId,
        required this.createdAt,
        required this.avgRating,
        required this.coverPhoto,
        required this.isPremiumAccount,
    });

    final String? id;
    final String? name;
    final String? email;
    final String? photoUrl;
    final String? bio;
    final String? address;
    final String? addressTwo;
    final String? poBox;
    final String? city;
    final int? postalCode;
    final dynamic scores;
    final String? status;
    final String? dataId;
    final DateTime? createdAt;
    final dynamic avgRating;
    final String? coverPhoto;
    final bool? isPremiumAccount;

    factory ProfileData.fromJson(Map<String, dynamic> json){ 
        return ProfileData(
            id: json["_id"],
            name: json["name"],
            email: json["email"],
            photoUrl: json["photoUrl"],
            bio: json["bio"],
            address: json["address"],
            addressTwo: json["addressTwo"],
            poBox: json["poBox"],
            city: json["city"],
            postalCode: json["postalCode"] is int
                ? json["postalCode"]
                : int.tryParse(json["postalCode"]?.toString() ?? ""),
            scores: json["scores"],
            status: json["status"],
            dataId: json["id"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            avgRating: json["avgRating"],
            coverPhoto: json["coverPhoto"],
            isPremiumAccount: json["isPremiumAccount"],
        );
    }

}
