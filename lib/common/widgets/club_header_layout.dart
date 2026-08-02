import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/app_images/app_images.dart';
import 'package:dirve_society/common/app_text_style/styles.dart';
import 'package:flutter/material.dart';

class ClubHeaderLayout extends StatelessWidget {
  const ClubHeaderLayout({
    super.key,
    required this.title,
    this.coverImageUrl,
    this.profileImageUrl,
    this.membersText,
    this.visibilityText,
    this.onBack,
    this.trailing,
    this.inviteAction,
  });

  final String title;
  final String? coverImageUrl;
  final String? profileImageUrl;
  final String? membersText;
  final String? visibilityText;
  final VoidCallback? onBack;
  final Widget? trailing;
  final Widget? inviteAction;

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
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onBack ?? () => Navigator.maybePop(context),
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: const CircleBorder(),
                      color: AppColors.black.withOpacity(0.3),
                    ),
                    child: Image.asset(
                      AppImages.back,
                      scale: 4,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          Positioned(
            left: size.width * 0.04,
            top: coverHeight - avatarSize / 2,
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: avatarSize / 2.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: h1.copyWith(
                            fontSize: 20,
                            color: AppColors.darkRed,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (membersText != null &&
                                membersText!.trim().isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    AppImages.groupLight,
                                    scale: 4,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    membersText!,
                                    style: h6,
                                  ),
                                ],
                              ),
                            if (visibilityText != null &&
                                visibilityText!.trim().isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    AppImages.public,
                                    scale: 4,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    visibilityText!,
                                    style: h6,
                                  ),
                                ],
                              ),
                          ],
                        ),
                        if (inviteAction != null) ...[
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: inviteAction!,
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
