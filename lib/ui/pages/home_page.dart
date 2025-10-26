import 'package:flutter/material.dart';
import 'package:nextq_app/providers/firebase_auth_provider.dart';
import 'package:nextq_app/providers/shared_preference_provider.dart';
import 'package:nextq_app/ui/static/navigation_route.dart';
import 'package:provider/provider.dart';

const Color _primaryBackgroundColor = Color(0xFFF0F4F8);
const Color _accentColor = Color(0xFF10B981);
const Color _secondaryBackgroundColor = Color(0xFFE9EEF3);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 24 * 3, left: 24, right: 24, bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Consumer<FirebaseAuthProvider>(
                      builder: (context, value, child) {
                        final displayName = value.profile?.name ?? 'User';
                        return Text.rich(
                          TextSpan(
                            text: 'Halo, ',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                            children: [
                              TextSpan(
                                text: '$displayName!',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: _accentColor,
                                    ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () => _tapToSignOut(context),
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Colors.black54,
                      size: 30,
                    ),
                    tooltip: 'Sign Out',
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: const BoxDecoration(
                color: _secondaryBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildLargeButton(
                    context,
                    icon: Icons.school_rounded,
                    text: 'Take Starter Test',
                    description: 'Assess your current knowledge baseline.',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.starterTest.name,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildLargeButton(
                    context,
                    icon: Icons.calendar_today_rounded,
                    text: 'Daily Test',
                    description: 'New set of questions every day!',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.dailyTest.name,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildLargeButton(
                    context,
                    icon: Icons.military_tech_rounded,
                    text: 'Test Your Might!',
                    description:
                        'Challenge your limits with expert-level tests.',
                    onPressed: () {},
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Tools & History',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildSmallCardButton(
                        context,
                        icon: Icons.book_rounded,
                        text: 'Guides',
                        onPressed: () {},
                      ),
                      _buildSmallCardButton(
                        context,
                        icon: Icons.history_toggle_off_rounded,
                        text: 'History',
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  const Center(
                    child: Text(
                      '© 2025 NextQ. All rights reserved.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeButton(BuildContext context,
      {required IconData icon,
      required String text,
      required String description,
      required VoidCallback onPressed}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 6,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                icon,
                size: 36,
                color: _accentColor,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallCardButton(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onPressed}) {
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 24.0;
    const spaceBetween = 15.0;
    final buttonWidth =
        (screenWidth - (horizontalPadding * 2) - spaceBetween) / 2;

    return SizedBox(
      width: buttonWidth,
      height: 120,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 6,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: _accentColor,
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _tapToSignOut(BuildContext context) async {
  final sharedPreferenceProvider = context.read<SharedPreferenceProvider>();
  final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
  final navigator = Navigator.of(context, rootNavigator: true);
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  try {
    await firebaseAuthProvider.signOutUser();
    await sharedPreferenceProvider.logout();
    navigator.pushNamedAndRemoveUntil(
      NavigationRoute.login.name,
      (route) => false,
    );
  } catch (e) {
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text("Logout Failed: ${e.toString()}")),
    );
  }
}
