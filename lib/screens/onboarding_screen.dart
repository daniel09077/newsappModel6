import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// The key used to store the onboarding status in SharedPreferences.
const String onboardingSeenKey = 'has_seen_onboarding';

/// The new two-page onboarding screen.
///
/// This widget handles the display of a two-page welcome flow and
/// provides a callback function to notify the parent widget (main.dart)
/// when the user has completed the onboarding.
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
            controller: _pageController,
            children: [
              // --- First Onboarding Slide: Welcome Screen ---
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Display the logo at the center.
                    Image.asset(
                      'assets/images/Group 1.png',
                      height: 150,
                    ),
                    const SizedBox(height: 32),
                    // The welcome message.
                    const Text(
                      'Welcome to the Kaduna News Portal',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 91, 168, 117),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // --- Second Onboarding Slide: App Intro and Call to Action ---
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // The image for the app intro.
                    SizedBox(
                      height: 200,
                      child: Image.asset('assets/images/nc2bqqwu.png'),
                    ),
                    const SizedBox(height: 32),
                    // The app intro description.
                    const Text(
                      'Stay informed with the latest news, events, and announcements from Kaduna Polytechnic. Your personalized news feed awaits!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 91, 168, 117),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Read articles, save your favorites offline, and customize your feed to see the topics that matter most to you.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    // The "Get Started" button.
                    ElevatedButton(
                      onPressed: () {
                        widget.onComplete(); // Call the callback to complete onboarding.
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: const Color.fromARGB(255, 91, 168, 117),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Get Started'),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Page indicator to show which slide is active.
          Positioned(
            bottom: 60,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 2,
              effect: const ExpandingDotsEffect(
                activeDotColor: Color.fromARGB(255, 91, 168, 117),
                dotColor: Colors.grey,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
