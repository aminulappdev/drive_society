import 'dart:async';
import 'package:dirve_society/app/modules/home/controllers/specific_user_story_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Instagram-style time formatter: 9h, 2m, 1day, Just now
String timeAgo(DateTime? dateTime) {
  if (dateTime == null) return 'Just now';

  final DateTime date = dateTime.toLocal();
  final DateTime now = DateTime.now();
  final Duration diff = now.difference(date);

  if (diff.inDays >= 7) {
    return '${(diff.inDays / 7).floor()}w';
  } else if (diff.inDays >= 1) {
    return '${diff.inDays}d';
  } else if (diff.inHours >= 1) {
    return '${diff.inHours}h';
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes}m';
  } else {
    return 'Just now';
  }
}

class StoryScreen extends StatefulWidget {
  final String userId;
  const StoryScreen({super.key, required this.userId});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with AutomaticKeepAliveClientMixin {
  final GetStoryController controller = Get.put(GetStoryController());

  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    controller.getSpecificStory(widget.userId);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      final stories = controller.specificStoryModel?.data?.user?.stories;
      if (stories == null || stories.isEmpty) return;

      setState(() {
        _currentPage = (_currentPage + 1) % stories.length;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onTapLeft() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      _startTimer();
    }
  }

  void _onTapRight() {
    final stories = controller.specificStoryModel?.data?.user?.stories;
    if (stories != null && _currentPage < stories.length - 1) {
      setState(() => _currentPage++);
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      _startTimer();
    } else {
      Get.back();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: GetBuilder<GetStoryController>(builder: (ctrl) {
        if (ctrl.inProgress) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
    
        final user = ctrl.specificStoryModel?.data?.user;
        final stories = user?.stories;
    
        if (user == null || stories == null || stories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo, size: 80, color: Colors.white54),
                const SizedBox(height: 16),
                Text(
                  'No stories yet',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                TextButton(
                  onPressed: () => Get.back(),
                  child:
                      Text('Go Back', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }
    
        return Stack(
          children: [
            // Full PageView
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                _startTimer();
              },
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
    
                return GestureDetector(
                  onTapDown: (details) {
                    final width = MediaQuery.of(context).size.width;
                    if (details.globalPosition.dx < width / 2) {
                      _onTapLeft();
                    } else {
                      _onTapRight();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background Image
                        Image.network(
                          story.content ?? '',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) {
                            return const Center(
                              child: Icon(Icons.broken_image,
                                  color: Colors.white70, size: 70),
                            );
                          },
                        ),
    
                        // Top Bar
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.black54, Colors.transparent],
                              ),
                            ),
                            child: Row(
                              children: [
                                // Progress Bars
                                Expanded(
                                  child: Row(
                                    children:
                                        List.generate(stories.length, (i) {
                                      return Expanded(
                                        child: Container(
                                          height: 3,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: LinearProgressIndicator(
                                            value: i < _currentPage
                                                ? 1.0
                                                : (i == _currentPage
                                                    ? 0.99
                                                    : 0.0),
                                            backgroundColor: Colors.white24,
                                            valueColor:
                                                const AlwaysStoppedAnimation(
                                                    Colors.white),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
    
                        // User Info
                        Positioned(
                          top: 20,
                          left: 16,
                          right: 50,
                          child: Container(
                            color: Colors.grey.withValues(alpha: 0.30),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(controller
                                            .specificStoryModel!
                                            .data!
                                            .user
                                            ?.photoUrl ??
                                        ''),
                                    backgroundColor: Colors.grey,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              user.name ?? 'User',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              timeAgo(story.createdAt),
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          story.text!.trim(),
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
          ],
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
