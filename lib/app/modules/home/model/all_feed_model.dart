class AllFeedModel {
    AllFeedModel({
        required this.success,
        required this.statusCode,
        required this.message,
        required this.meta,
        required this.data,
    }); 

    final bool? success;
    final int? statusCode;
    final String? message;
    final Meta? meta;
    final List<AllFeedItemModel> data;

    factory AllFeedModel.fromJson(Map<String, dynamic> json){ 
        return AllFeedModel(
            success: json["success"],
            statusCode: json["statusCode"],
            message: json["message"],
            meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
            data: json["data"] == null ? [] : List<AllFeedItemModel>.from(json["data"]!.map((x) => AllFeedItemModel.fromJson(x))),
        );
    }

}
 
class AllFeedItemModel {
    AllFeedItemModel({
        required this.location,
        required this.hideBy,
        required this.id,
        required this.author,
        required this.club,
        required this.content,
        required this.description,
        required this.tags,
        required this.contentMeta,
        required this.isDeleted,
        required this.createdAt,
        required this.updatedAt,
        required this.isLiked,
        required this.isVisible,
        required this.isFavorite,
        required this.isHide,
    });

    final FeedLocation? location;
    final List<dynamic> hideBy;
    final String? id;
    final Author? author;
    final dynamic club;
    final List<String> content;
    final String? description;
    final List<String> tags;
    final ContentMeta? contentMeta;
    final bool? isDeleted;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final bool? isLiked;
    final bool? isVisible;
    final bool? isFavorite;
    final bool? isHide;

    factory AllFeedItemModel.fromJson(Map<String, dynamic> json){ 
        return AllFeedItemModel(
            location: json["location"] == null ? null : FeedLocation.fromJson(json["location"]),
            hideBy: json["hideBy"] == null ? [] : List<dynamic>.from(json["hideBy"]!.map((x) => x)),
            id: json["_id"],
            author: json["author"] == null ? null : Author.fromJson(json["author"]),
            club: json["club"],
            content: json["content"] == null ? [] : List<String>.from(json["content"]!.map((x) => x)),
            description: json["description"],
            tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
            contentMeta: json["contentMeta"] == null ? null : ContentMeta.fromJson(json["contentMeta"]),
            isDeleted: json["isDeleted"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            isLiked: json["isLiked"],
            isVisible: json["isVisible"],
            isFavorite: json["isFavorite"],
            isHide: json["isHide"],
        );
    }

}

class FeedLocation {
    FeedLocation({
        required this.address,
        required this.type,
        required this.coordinates,
    });

    final String? address;
    final String? type;
    final List<num> coordinates;

    factory FeedLocation.fromJson(Map<String, dynamic> json){ 
        return FeedLocation(
            address: json["address"],
            type: json["type"],
            coordinates: json["coordinates"] == null
                ? []
                : List<num>.from(json["coordinates"]!.map((x) => x ?? 0)),
        );
    }

}

class Author {
    Author({
        required this.id,
        required this.name,
        required this.email,
        required this.photoUrl,
    });

    final String? id;
    final String? name;
    final String? email;
    final String? photoUrl;

    factory Author.fromJson(Map<String, dynamic> json){ 
        return Author(
            id: json["_id"],
            name: json["name"],
            email: json["email"],
            photoUrl: json["photoUrl"],
        );
    }

}

class ContentMeta {
    ContentMeta({
        required this.id,
        required this.like,
        required this.likeBy,
        required this.comment,
    });

    final String? id;
    final int? like;
    final List<String> likeBy;
    final int? comment;

    factory ContentMeta.fromJson(Map<String, dynamic> json){ 
        return ContentMeta(
            id: json["_id"],
            like: json["like"],
            likeBy: json["likeBy"] == null ? [] : List<String>.from(json["likeBy"]!.map((x) => x)),
            comment: json["comment"],
        );
    }

}

class Meta {
    Meta({
        required this.page,
        required this.limit,
        required this.total,
        required this.totalPage,
    });

    final int? page;
    final int? limit;
    final int? total;
    final int? totalPage;

    factory Meta.fromJson(Map<String, dynamic> json){ 
        return Meta(
            page: json["page"],
            limit: json["limit"],
            total: json["total"],
            totalPage: json["totalPage"],
        );
    }

}
