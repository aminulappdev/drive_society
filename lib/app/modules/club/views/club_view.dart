import 'package:dirve_society/app/modules/club/controllers/club_details_controller.dart';
import 'package:dirve_society/app/modules/club/controllers/delete_club_controller.dart';
import 'package:dirve_society/app/modules/club/controllers/leave_club_controller.dart';
import 'package:dirve_society/app/modules/club/views/create_forum_screen.dart';
import 'package:dirve_society/app/modules/club/views/create_post_screen.dart';
import 'package:dirve_society/app/modules/club/views/edit_club_screen.dart';
import 'package:dirve_society/app/modules/club/views/feed_screen.dart';
import 'package:dirve_society/app/modules/club/views/forum_screen.dart';
import 'package:dirve_society/app/modules/club/views/invite_screen.dart';
import 'package:dirve_society/app/modules/club/views/member_screen.dart';
import 'package:dirve_society/app/modules/meets/views/create_meets_screen.dart';
import 'package:dirve_society/app/modules/profile/views/my_clubs_view.dart';
import 'package:dirve_society/app/modules/subscription/views/subscription_screen.dart';
import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/app_images/app_images.dart';
import 'package:dirve_society/common/size_box/custom_sizebox.dart'; 
import 'package:dirve_society/common/widgets/club_header_layout.dart';
import 'package:dirve_society/common/widgets/custom_dialoge.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/app_text_style/styles.dart';

class ClubView extends StatefulWidget {
  final bool isAuthor;
  final String authorId;
  final String id;
  const ClubView(
      {super.key,
      required this.id,
      required this.authorId,
      required this.isAuthor});

  @override
  State<ClubView> createState() => _ClubViewState();
}

class _ClubViewState extends State<ClubView> {
  final LeaveClubController leaveClubController =
      Get.put(LeaveClubController());
  final DeleteClubController deleteClubController =
      Get.put(DeleteClubController());
  final ClubDetailsController clubDetailsController =
      Get.put(ClubDetailsController());
  int selectedIndex = 0;
  OverlayEntry? _overlayEntry;
  bool _isMenuOpen = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Club ID: ${widget.id}');
      print('Author ID: ${widget.authorId}');
      clubDetailsController.getClubDetails(widget.id);
    });

    super.initState();
  }

  // Function to show the dropdown menu to the left
  void _showMenu(BuildContext context, Offset buttonPosition) {
    const menuWidth = 150.0; // Width of the menu

    // Calculate the left position to place the menu to the left of the button
    double leftPosition = buttonPosition.dx - menuWidth - 10; // 10 for padding
    // Ensure the menu doesn't go off-screen
    if (leftPosition < 10) {
      leftPosition = 10; // Keep some padding from the left edge
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // GestureDetector to detect taps outside the menu
          GestureDetector(
            onTap: () {
              _closeMenu();
            },
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Menu container
          Positioned(
            top: buttonPosition.dy, // Align vertically with the button
            left: leftPosition, // Position to the left of the button
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: menuWidth,
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: widget.authorId ==
                        StorageUtil.getData(StorageUtil.profileId)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _menuItem("Edit Club Info", () {
                            Get.to(() => EditClubView(clubId: widget.id));
                            _closeMenu();
                          }),
                          _menuItem("Manage Members", () {
                            Get.to(() => MemberScreen(
                                  authorId: widget.authorId,
                                  id: widget.id,
                                ));
                            _closeMenu();
                          }),
                          _menuItem("Create Meets", () {
                            Get.to(() => CreateMeetsView(
                                  clubId: widget.id,
                                ));
                            _closeMenu();
                          }),
                          _menuItem("Subscribtion", () {
                            Get.to(() => SubscriptionScreen());
                            _closeMenu();
                          }),
                          _menuItem("Delete Club", color: Colors.red, () {
                            _showDeleteClubDialog(context);

                            _closeMenu();
                          }),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _menuItem("View Members", () {
                            Get.to(() => MemberScreen(
                                  authorId: widget.authorId,
                                  id: widget.id,
                                ));
                            _closeMenu();
                          }),
                          _menuItem("Leave Club", color: Colors.red, () {
                            _showLeaveClubDialog(context);
                            _closeMenu();
                          }),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isMenuOpen = true;
    });
  }

  // Function to close the dropdown menu
  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isMenuOpen = false;
    });
  }

  // Helper function to create menu items
  Widget _menuItem(String title, VoidCallback onTap, {Color? color}) {
    color ??= AppColors.black;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          title,
          style: h6.copyWith(color: color),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _closeMenu(); // Ensure the overlay is removed when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height;
    final GlobalKey menuButtonKey = GlobalKey(); // Key to get button position

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: GestureDetector(
        // Detect taps outside the menu to close it
        onTap: () {
          if (_isMenuOpen) {
            _closeMenu();
          }
        },
        child: GetBuilder<ClubDetailsController>(builder: (controller) {
          if (controller.inProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final club = controller.clubDetails;
          if (club == null) {
            return const Center(
              child: Text(
                'Club details not available',
                style: TextStyle(color: AppColors.white),
              ),
            );
          }
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  ClubHeaderLayout(
                    title: club.name ?? '',
                    coverImageUrl: club.coverPhoto,
                    profileImageUrl: club.profilePhoto,
                    membersText: '${club.member ?? 0} Members',
                    visibilityText: club.type ?? '',
                    onBack: Get.back,
                    trailing: GestureDetector(
                      key: menuButtonKey,
                      onTap: () {
                        final RenderBox renderBox =
                            menuButtonKey.currentContext!.findRenderObject()
                                as RenderBox;
                        final buttonPosition =
                            renderBox.localToGlobal(Offset.zero);

                        if (_isMenuOpen) {
                          _closeMenu();
                        } else {
                          _showMenu(context, buttonPosition);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          color: AppColors.black.withOpacity(0.3),
                        ),
                        child: Image.asset(
                          AppImages.menu,
                          scale: 4,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    inviteAction: GestureDetector(
                      onTap: () {
                        Get.to(() => InviteScreen(
                              authorId: widget.authorId,
                              id: widget.id,
                            ));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppImages.invite,
                            scale: 4,
                          ),
                          sw8,
                          Text(
                            'Invite',
                            style: h5.copyWith(
                              color: AppColors.darkRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  sh20,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.silver,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = 0;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: selectedIndex == 0
                                        ? AppColors.darkRed
                                        : AppColors.transparent),
                                child: Center(
                                  child: Text(
                                    'Feed',
                                    style: TextStyle(
                                        fontWeight: selectedIndex == 0
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: selectedIndex == 0
                                            ? AppColors.white
                                            : AppColors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          sw8,
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = 1;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: selectedIndex == 1
                                        ? AppColors.darkRed
                                        : AppColors.transparent),
                                child: Center(
                                  child: Text(
                                    'Forum',
                                    style: TextStyle(
                                        fontWeight: selectedIndex == 1
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: selectedIndex == 1
                                            ? AppColors.white
                                            : AppColors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: selectedIndex == 0
                        ? FeedScreen(
                            clubId: widget.id,
                            authorId: widget.authorId,
                          )
                        : ForumScreen(
                            clubId: widget.id,
                            authorId: widget.authorId,
                          ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
      floatingActionButton: widget.isAuthor
          ? ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: FloatingActionButton(
                onPressed: () {
                  selectedIndex == 0
                      ? Get.to(CreatePostView(
                          authorId: widget.authorId, 
                          clubId: widget.id,
                        ))
                      : Get.to(CreateForumView(
                          authorId: widget.authorId,
                          clubId: widget.id,
                        ));
                }, 
                backgroundColor: AppColors.darkRed,
                child: Icon(
                  Icons.add,
                  size: 32,
                  color: AppColors.white,
                ),
              ),
            )
          : Container(),
    );
  }

  Future<void> deleteClub() async {
    final bool isSuccess = await deleteClubController.deleteClub(
      widget.id,
    );

    if (isSuccess) {
      if (mounted) {
        Get.to(MyClubsView());
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
            context,
            deleteClubController.errorMessage ?? 'Failed to update profile',
            true);
      }
    }
  }

  Future<void> leaveClub() async {
    final bool isSuccess = await leaveClubController.leaveClub(
      widget.id,
      StorageUtil.getData(StorageUtil.profileId),
    );

    if (isSuccess) {
      if (mounted) {
        Get.to(MyClubsView());
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
            context,
            deleteClubController.errorMessage ?? 'Failed to update profile',
            true);
      }
    }
  }

  void _showLeaveClubDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          yesText: 'Yes',
          noText: 'No',
          noOntap: () {
            Navigator.pop(context);
          },
          yesOntap: () {
            leaveClub();
          },
          iconData: Icons.logout,
          subtitle: '',
          title: 'Do you want to leave this club?',
        );
      },
    );
  }

  void _showDeleteClubDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          yesText: 'Yes',
          noText: 'No',
          noOntap: () {
            Navigator.pop(context);
          },
          yesOntap: () {
            deleteClub();
          },
          iconData: Icons.delete,
          subtitle: '',
          title: 'Do you want to delete this club?',
        );
      },
    );
  }
}
