import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/app_images/app_images.dart';
import 'package:dirve_society/common/app_text_style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'image_preview_dialog.dart';

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
    this.isBack = true,
  });

  final String title;
  final String? coverImageUrl;
  final String? profileImageUrl;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onBack;
  final String? pointsText;
  final String? ratingText;
  final bool isBack;

  ImageProvider _imageProvider(String? url, String fallbackAsset) {
    if (url == null || url.trim().isEmpty) {
      return AssetImage(fallbackAsset);
    }
    return NetworkImage(url);
  }

  void _showPreview(
    BuildContext context, {
    required String? imageUrl,
    required String fallbackAsset,
  }) {
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return;
    }
    ImagePreviewDialog.showNetwork(
      context,
      imageUrl: imageUrl,
      fallback: Image.asset(
        fallbackAsset,
        fit: BoxFit.contain,
      ),
    );
  }

  void _handleBack(BuildContext context) {
    final navigator = Navigator.maybeOf(context);

    // Pop the navigator that owns this screen first. This avoids GetX trying
    // to close a snackbar overlay before navigating back.
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return;
    }

    // Fallback for a GetX-managed navigator, without closing overlays.
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back(closeOverlays: false);
      return;
    }

    // Keep support for callers that provide their own back action.
    if (onBack != null) {
      onBack!();
      return;
    }

    // If this page was mounted without a parent route, provide a safe fallback.
    Get.offNamed('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // Keep the header proportional to the device width instead of using a
    // percentage of the screen height. This prevents a very tall header on
    // large phones and keeps it usable on smaller screens.
    final coverHeight = (size.width * 0.50).clamp(185.0, 370.0).toDouble();
    final avatarSize = (size.width * 0.29).clamp(96.0, 220.0).toDouble();
    final horizontalPadding = (size.width * 0.04).clamp(14.0, 28.0).toDouble();
    final bottomSpace = avatarSize * 0.72;
    final pointsBottomOffset = avatarSize * 0.12;
    final backButtonSize = (size.width * 0.10).clamp(32.0, 44.0).toDouble();
    final backTapTargetSize =
        (backButtonSize + size.width * 0.035).clamp(48.0, 64.0).toDouble();
    final backButtonTop =
        (MediaQuery.paddingOf(context).top * 0.65).clamp(8.0, 30.0).toDouble();
    final titleFontSize = (size.width * 0.026).clamp(17.0, 20.0).toDouble();
    final ratingFontSize = (size.width * 0.023).clamp(16.0, 18.0).toDouble();

    return SizedBox(
      height: coverHeight + bottomSpace,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () => _showPreview(
              context,
              imageUrl: coverImageUrl,
              fallbackAsset: AppImages.noBanner,
            ),
            child: Container(
              width: double.infinity,
              height: coverHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _imageProvider(coverImageUrl, AppImages.noBanner),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: backButtonTop,
            left: horizontalPadding,
            child: isBack == true
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _handleBack(context),
                    child: SizedBox(
                      width: backTapTargetSize,
                      height: backTapTargetSize,
                      child: Center(
                        child: SizedBox(
                          width: backButtonSize,
                          height: backButtonSize,
                          child: Image.asset(AppImages.back),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          Positioned(
            left: horizontalPadding,
            top: coverHeight - avatarSize / 2,
            right: horizontalPadding,
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
                          GestureDetector(
                            onTap: () => _showPreview(
                              context,
                              imageUrl: profileImageUrl,
                              fallbackAsset: AppImages.noImage,
                            ),
                            child: Container(
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
                SizedBox(width: (size.width * 0.035).clamp(10.0, 18.0)),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: avatarSize / 2.15),
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
                                  fontSize: titleFontSize,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                            if (ratingText != null &&
                                ratingText!.trim().isNotEmpty) ...[
                              SizedBox(
                                width: (size.width * 0.02).clamp(6.0, 10.0),
                              ),
                              Icon(
                                Icons.star,
                                color: AppColors.darkRed,
                                size: (size.width * 0.026)
                                    .clamp(18.0, 20.0)
                                    .toDouble(),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                ratingText!,
                                style: h3.copyWith(
                                  fontSize: ratingFontSize,
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
