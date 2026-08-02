class MarketPlaceDetailsModel {
    MarketPlaceDetailsModel({
        required this.success,
        required this.statusCode,
        required this.message,
        required this.data,
    });
 
    final bool? success;
    final int? statusCode;
    final String? message;
    final MarketDetailsData? data;

    factory MarketPlaceDetailsModel.fromJson(Map<String, dynamic> json){ 
        return MarketPlaceDetailsModel(
            success: json["success"],
            statusCode: json["statusCode"],
            message: json["message"],
            data: json["data"] == null ? null : MarketDetailsData.fromJson(json["data"]),
        );
    }

}

class MarketDetailsData {
    MarketDetailsData({
        required this.derivative,
        required this.bodyType,
        required this.doors,
        required this.postcode,
        required this.sellerType,
        required this.id,
        required this.brand,
        required this.model,
        required this.condition,
        required this.year,
        required this.color,
        required this.mileage,
        required this.fuelType,
        required this.transmission,
        required this.description,
        required this.banner,
        required this.images,
        required this.price,
        required this.author,
        required this.contentMeta,
        required this.avgRating,
        required this.ratingCount,
        required this.isSale,
        required this.isDeleted,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    final String? derivative;
    final String? bodyType;
    final dynamic doors;
    final String? postcode;
    final String? sellerType;
    final String? id;
    final String? brand;
    final String? model;
    final String? condition;
    final String? year;
    final String? color;
    final dynamic mileage;
    final String? fuelType;
    final String? transmission;
    final String? description;
    final String? banner;
    final List<String> images;
    final dynamic price;
    final Author? author;
    final String? contentMeta;
    final dynamic avgRating;
    final dynamic ratingCount;
    final bool? isSale;
    final bool? isDeleted;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic v;

    factory MarketDetailsData.fromJson(Map<String, dynamic> json){ 
        return MarketDetailsData(
            derivative: json["derivative"],
            bodyType: json["bodyType"],
            doors: json["doors"],
            postcode: json["postcode"],
            sellerType: json["sellerType"],
            id: json["_id"],
            brand: json["brand"],
            model: json["model"],
            condition: json["condition"],
            year: json["year"]?.toString(),
            color: json["color"],
            mileage: json["mileage"],
            fuelType: json["fuelType"],
            transmission: json["transmission"],
            description: json["description"],
            banner: json["banner"],
            images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
            price: json["price"],
            author: json["author"] == null ? null : Author.fromJson(json["author"]),
            contentMeta: json["contentMeta"],
            avgRating: json["avgRating"],
            ratingCount: json["ratingCount"],
            isSale: json["isSale"],
            isDeleted: json["isDeleted"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            v: json["__v"],
        );
    }

}

class Author {
    Author({
        required this.id,
        required this.name,
        required this.email,
        required this.photoUrl,
        required this.avgRating,
        required this.ratingCount,
    });

    final String? id;
    final String? name;
    final String? email;
    final String? photoUrl;
    final dynamic avgRating;
    final dynamic ratingCount;

    factory Author.fromJson(Map<String, dynamic> json){ 
        return Author(
            id: json["_id"],
            name: json["name"],
            email: json["email"],
            photoUrl: json["photoUrl"],
            avgRating: json["avgRating"],
            ratingCount: json["ratingCount"],
        );
    }

}
