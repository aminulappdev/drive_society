import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/app_images/app_images.dart';
import 'package:dirve_society/common/app_text_style/styles.dart';
import 'package:flutter/material.dart';

class ProfileHeaderLayout extends StatelessWidget {
  const ProfileHeaderLayout({
    super.key,
    required this.title,
    this.coverImageUrl,
    this.profileImageUrl,
    this.subtitle,
    this.trailing,
    this.onBack,
    this.pointsText,
    this.ratingText,
  });

  final String title;
  final String? coverImageUrl;
  final String? profileImageUrl;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onBack;
  final String? pointsText;
  final String? ratingText;

  ImageProvider _imageProvider(String? url, String fallbackAsset) {
    if (url == null || url.trim().isEmpty) {
      return AssetImage(fallbackAsset);
    }
    return NetworkImage(url);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final coverHeight = size.height * 0.26;
    final avatarSize = size.width * 0.30;
    final bottomSpace = avatarSize * 0.78;
    final pointsBottomOffset = avatarSize * 0.17;

    return SizedBox(
      height: coverHeight + bottomSpace,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: coverHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _imageProvider(coverImageUrl, AppImages.noBanner),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 12,
            left: 20,
            child: GestureDetector(
              onTap: onBack ?? () => Navigator.maybePop(context),
              child: SizedBox(
                width: 36,
                height: 36,
                child: Image.asset(AppImages.back),
              ),
            ),
          ),
          Positioned(
            left: size.width * 0.04,
            top: coverHeight - avatarSize / 2,
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: avatarSize,
                      height: avatarSize + 26,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: avatarSize,
                            height: avatarSize,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white,
                              border: Border.all(color: AppColors.white),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: AppColors.silver,
                              backgroundImage: _imageProvider(
                                profileImageUrl,
                                AppImages.noImage,
                              ),
                            ),
                          ),
                          if (pointsText != null &&
                              pointsText!.trim().isNotEmpty)
                            Positioned(
                              left: 18,
                              right: 18,
                              bottom: pointsBottomOffset,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: const Color(0xFFFF9F1C),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.14),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  pointsText!,
                                  textAlign: TextAlign.center,
                                  style: h5.copyWith(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: avatarSize / 2.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: h1.copyWith(
                                  fontSize: 20,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                            if (ratingText != null &&
                                ratingText!.trim().isNotEmpty) ...[
                              const SizedBox(width: 10),
                              Icon(
                                Icons.star,
                                color: AppColors.darkRed,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                ratingText!,
                                style: h3.copyWith(
                                  fontSize: 18,
                                  color: AppColors.darkRed,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ] else if (trailing != null) ...[
                              const SizedBox(width: 8),
                              trailing!,
                            ],
                          ],
                        ),
                        if (subtitle != null &&
                            subtitle!.trim().isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: h6.copyWith(
                              color: AppColors.black,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
