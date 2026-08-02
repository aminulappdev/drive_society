import 'package:dirve_society/common/app_images/app_images.dart';
import 'package:dirve_society/common/app_text_style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/app_color/app_colors.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final SplashController splashController = Get.put(SplashController()); 
  final double buttonWidth = 48.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.splashBackImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay for better text visibility
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Logo and text at the top
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Image.asset(AppImages.splashLogo, scale: 4),
          ),
          // Swipeable button at the bottom
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate container width dynamically
                    final containerWidth = constraints.maxWidth;
                    // Update maxSwipe whenever the container width changes
                    splashController.setMaxSwipe(containerWidth, buttonWidth);

                    return Obx(
                      () => Container(
                        width: containerWidth, // Use the dynamic width
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background text
                            Center(
                              child: Text(
                                splashController.isSwiped.value
                                    ? "Let's Go!"
                                    : "Swipe to continue",
                                style: h7.copyWith(
                                  fontSize: 20,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            // Swipeable button
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              left: splashController.position.value,
                              child: GestureDetector(
                                onHorizontalDragUpdate: (details) {
                                  splashController
                                      .onDragUpdate(details.delta.dx);
                                },
                                onHorizontalDragEnd: (details) {
                                  splashController.onDragEnd();
                                },
                                child: Container(
                                  width: buttonWidth,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: splashController.isSwiped.value
                                        ? AppColors.green
                                        : AppColors.darkRed,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    splashController.isSwiped.value
                                        ? Icons.check
                                        : Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // const SizedBox(height: 12),
                // Text(
                //   "Swipe right to continue",
                //   style: h7.copyWith(
                //     fontSize: 14,
                //     color: AppColors.white.withOpacity(0.85),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
