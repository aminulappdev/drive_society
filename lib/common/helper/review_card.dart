import 'package:dirve_society/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_color/app_colors.dart';

// Dynamic Star Rating Widget (from previous response)
class DynamicStarRating extends StatelessWidget {
  final dynamic rating;
  final double starSize;
  final Color filledColor;
  final Color emptyColor;

  const DynamicStarRating({
    super.key,
    required this.rating,
    this.starSize = 20.0,
    this.filledColor = Colors.amber,
    this.emptyColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    const int maxStars = 5;
    List<Widget> stars = [];

    // Ensure rating is non-negative and within bounds
    double clampedRating = rating.clamp(0.0, maxStars.toDouble());

    // Calculate filled stars
    int filledStars = clampedRating.floor();

    // Check for half star
    bool hasHalfStar = (clampedRating - filledStars) >= 0.5;

    // Calculate empty stars
    int emptyStars = maxStars - filledStars - (hasHalfStar ? 1 : 0);

    // Add filled stars
    for (int i = 0; i < filledStars; i++) {
      stars.add(Icon(
        Icons.star,
        color: filledColor,
        size: starSize,
      ));
    }

    // Add half star if applicable
    if (hasHalfStar) {
      stars.add(Icon(
        Icons.star_half,
        color: filledColor,
        size: starSize,
      ));
    }

    // Add empty stars
    for (int i = 0; i < emptyStars; i++) {
      stars.add(Icon(
        Icons.star_border,
        color: emptyColor,
        size: starSize,
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String imagePath;
  final dynamic rating; // Keep as dynamic to accept both int and double
  final String reviewText;
  final String reviewerName;
  final String date;

  const ReviewCard({
    super.key,
    required this.imagePath,
    required this.rating,
    required this.reviewText,
    required this.reviewerName,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    // Convert rating to double
    double convertedRating =
        rating is int ? (rating as int).toDouble() : (rating as double);

    return Container(
      width: Get.width * 0.85,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              DynamicStarRating(
                rating: convertedRating, // Use converted rating
                starSize: 20,
                filledColor: AppColors.darkRed,
                emptyColor: AppColors.grey,
              ),
              sw8,
              Text(
                convertedRating
                    .toStringAsFixed(1), // Display rating (e.g., "4.5")
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reviewText,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(imagePath),
                  ),
                  sw8,
                  Text(
                    reviewerName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
