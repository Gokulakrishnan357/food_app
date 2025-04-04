import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:zeroq/const/app_colors.dart';
import 'package:zeroq/uttility/routing/routes.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  Future<void> _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    // Navigate to Auth Page after Onboarding
    Get.offNamed(AmdRoutesClass.authPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                OnboardingPage(
                  imagePath: 'assets/onboarding1.png',
                  title: 'Discover Amazing Services',
                  description: 'Taste the World, Delivered to Your Doorstep.',
                  buttonText: 'Next',
                  onPressed: () {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  skipText: 'Skip',
                  onSkip: _completeOnboarding,
                  showBackButton: false, // No back button on the first page
                ),
                OnboardingPage(
                  imagePath: 'assets/onboarding2.png',
                  title: 'Fast & Reliable',
                  description: "Hungry? We’re on our way...!",
                  buttonText: 'Next',
                  onPressed: () {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  showBackButton: true, // Show back button on top left
                  onBack: () {
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                OnboardingPage(
                  imagePath: 'assets/onboarding3.png',
                  title: 'Get Started Now!',
                  description: 'Sign up and explore all features.',
                  buttonText: 'Get Started',
                  onPressed: _completeOnboarding,
                  showBackButton: true, // Show back button on top left
                  onBack: () {
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;
  final String? skipText;
  final VoidCallback? onSkip;
  final VoidCallback? onBack;
  final bool showBackButton;

  OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
    this.skipText,
    this.onSkip,
    this.onBack,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Back button on the top left for screens 2 & 3
          if (showBackButton)
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
                  onPressed: onBack,
                ),
              ),
            ),
          if (skipText != null)
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: onSkip,
                child: Text(skipText!,
                    style: const TextStyle(color: Colors.green)),
              ),
            ),

          const SizedBox(height: 20),

          // Centered Image
          Expanded(
            flex: 3,
            child: Center(
              child: Image.asset(imagePath, height: 250, fit: BoxFit.contain),
            ),
          ),

          // Text Section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 106, 107, 109)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Buttons Section (Centered)
          Expanded(
            flex: 1,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 14),
                  ),
                  child: Text(buttonText,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
