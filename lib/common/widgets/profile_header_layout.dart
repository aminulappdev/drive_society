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
  });

  final String title;
  final String? coverImageUrl;
  final String? profileImageUrl;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onBack;

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
    final overlap = size.height * 0.06;
    final bottomSpace = overlap > avatarSize / 2 ? overlap : avatarSize / 2;

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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    backgroundImage:
                        _imageProvider(profileImageUrl, AppImages.noImage),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: avatarSize / 2.5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: h1.copyWith(
                                fontSize: 20,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          if (trailing != null) ...[
                            const SizedBox(width: 8),
                            trailing!,
                          ],
                        ],
                      ),
                      if (subtitle != null && subtitle!.trim().isNotEmpty)
                        Text(
                          subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: h1.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.red,
                          ),
                        ),
                    ],
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
