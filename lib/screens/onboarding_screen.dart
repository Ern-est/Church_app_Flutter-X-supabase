import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_screen.dart';
import 'home_screen.dart';
import 'complete_profile_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onFinished;

  const OnboardingScreen({Key? key, this.onFinished}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 2);
            },
            children: [
              buildPage(
                image: 'assets/onboarding1.jpg',
                title: 'Welcome to Bethsaida',
                subtitle: 'Your digital church companion.',
              ),
              buildPage(
                image: 'assets/onboarding2.webp',
                title: 'Bible & Devotionals',
                subtitle: 'Read the Word offline with ease.',
              ),
              buildPage(
                image: 'assets/onboarding3.jpg',
                title: 'Connect With Groups',
                subtitle: 'Engage in chat with your fellowship groups.',
              ),
            ],
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: WormEffect(
                  activeDotColor: Colors.pinkAccent,
                  dotColor: Colors.grey.shade300,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () async {
                if (isLastPage) {
                  final user = Supabase.instance.client.auth.currentUser;

                  if (user == null) {
                    // Not authenticated → Go to AuthScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => AuthScreen()),
                    );
                  } else {
                    try {
                      final response =
                          await Supabase.instance.client
                              .from('users')
                              .select()
                              .eq('id', user.id)
                              .single();

                      final profile = response;
                      final isProfileComplete =
                          profile['full_name'] != null &&
                          profile['full_name'].toString().trim().isNotEmpty;

                      if (isProfileComplete) {
                        // Profile complete → Go to HomeScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                        );
                      } else {
                        // Incomplete profile → Go to CompleteProfileScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => CompleteProfileScreen(
                                  userId: user.id,
                                  phoneNumber: user.phone ?? '',
                                ),
                          ),
                        );
                      }
                    } catch (e) {
                      // Fallback: Treat as unauthenticated
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => AuthScreen()),
                      );
                    }
                  }
                } else {
                  _controller.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  isLastPage ? 'Get Started' : 'Next',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 300),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
