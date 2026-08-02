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
        required this.addressLine1,
        required this.addressLine2,
        required this.address,
        required this.addressTwo,
        required this.poBox,
        required this.city,
        required this.postalCode,
        required this.country,
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
    final ProfileAddressLine? addressLine1;
    final ProfileAddressLine? addressLine2;
    final String? address;
    final String? addressTwo;
    final String? poBox;
    final String? city;
    final int? postalCode;
    final String? country;
    final dynamic scores;
    final String? status;
    final String? dataId;
    final DateTime? createdAt;
    final dynamic avgRating;
    final String? coverPhoto;
    final bool? isPremiumAccount;

    factory ProfileData.fromJson(Map<String, dynamic> json){ 
        final addressLine1 = json["addressLine1"] == null
            ? null
            : ProfileAddressLine.fromJson(json["addressLine1"]);
        final addressLine2 = json["addressLine2"] == null
            ? null
            : ProfileAddressLine.fromJson(json["addressLine2"]);
        return ProfileData(
            id: json["_id"],
            name: json["name"],
            email: json["email"],
            photoUrl: json["photoUrl"],
            bio: json["bio"],
            addressLine1: addressLine1,
            addressLine2: addressLine2,
            address: addressLine1?.address ?? json["address"],
            addressTwo: addressLine2?.address ?? json["addressTwo"],
            poBox: addressLine1?.poBox ?? json["poBox"],
            city: addressLine1?.city ?? json["city"],
            postalCode: addressLine1?.postalCode ?? (json["postalCode"] is int
                ? json["postalCode"]
                : int.tryParse(json["postalCode"]?.toString() ?? "")),
            country: addressLine1?.country ?? json["country"],
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

class ProfileAddressLine {
    ProfileAddressLine({
        required this.address,
        required this.poBox,
        required this.city,
        required this.postalCode,
        required this.country,
        required this.latitude,
        required this.longitude,
    });

    final String? address;
    final String? poBox;
    final String? city;
    final int? postalCode;
    final String? country;
    final double? latitude;
    final double? longitude;

    factory ProfileAddressLine.fromJson(Map<String, dynamic> json){ 
        return ProfileAddressLine(
            address: json["address"],
            poBox: json["poBox"]?.toString(),
            city: json["city"],
            postalCode: json["postalCode"] is int
                ? json["postalCode"]
                : int.tryParse(json["postalCode"]?.toString() ?? ""),
            country: json["country"],
            latitude: (json["latitude"] as num?)?.toDouble(),
            longitude: (json["longitude"] as num?)?.toDouble(),
        );
    }

}
