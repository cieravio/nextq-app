import 'package:flutter/material.dart';
import 'package:nextq_app/ui/static/navigation_route.dart';

const Color _primaryColor = Color(0xFFF0F4F8);
const Color _accentColor = Color(0xFF10B981);

class ResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultPage({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  Map<String, dynamic> _getFeedback() {
    final double percentage = (score / totalQuestions) * 100;

    if (percentage >= 80) {
      return {
        'message': 'Excellent Job! Your understanding is very strong.',
        'color': Colors.green.shade700,
        'icon': Icons.star_rate_rounded,
      };
    } else if (percentage >= 50) {
      return {
        'message': 'Good Effort! Keep practicing to improve your score.',
        'color': Colors.orange.shade700,
        'icon': Icons.check_circle_rounded,
      };
    } else {
      return {
        'message': 'Keep Learning! Review the explanations and try again.',
        'color': Colors.red.shade700,
        'icon': Icons.error_rounded,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedback = _getFeedback();
    final double percentage = (score / totalQuestions) * 100;

    return Scaffold(
      backgroundColor: _primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                feedback['icon'],
                size: 80,
                color: feedback['color'],
              ),
              const SizedBox(height: 20),
              Text(
                'Your Daily Test Results',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Final Score:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$score / $totalQuestions',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: feedback['color'],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      feedback['message'],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black87,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, NavigationRoute.home.name);
                  },
                  icon: const Icon(Icons.home_rounded, size: 28),
                  label: const Text(
                    'Return to Home',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
