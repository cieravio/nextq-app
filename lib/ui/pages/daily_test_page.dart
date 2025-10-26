import 'package:flutter/material.dart';

// Asumsi: dailyQuizQuestions ada di file ini atau sudah diimport dari path ini

import 'package:nextq_app/model/daily_test.dart';

// Asumsi: Anda memiliki file result_page.dart di root folder, jika tidak, ganti path ini

import 'result_page.dart';

const Color _primaryColor = Color(0xFFF0F4F8); // Background Primer
const Color _accentColor = Color(0xFF10B981);
const Color _cardColor = Colors.white;

class DailyTestPage extends StatefulWidget {
  const DailyTestPage({super.key});

  @override
  State<DailyTestPage> createState() => _DailyTestPageState();
}

class _DailyTestPageState extends State<DailyTestPage> {
  // State untuk melacak indeks soal yang sedang ditampilkan

  int _currentQuestionIndex = 0;

  // State untuk melacak jawaban yang sedang ditampilkan di UI

  String? _selectedAnswer;

  // Map BARU untuk menyimpan jawaban pengguna: {question_id: selected_answer}

  final Map<int, String?> _userAnswers = {};

  // Palet Warna

  // Getter untuk soal saat ini

  Map<String, dynamic> get _currentQuestion {
    // Asumsi: dailyQuizQuestions diakses di sini

    if (_currentQuestionIndex < 0 ||
        _currentQuestionIndex >= dailyQuizQuestions.length) {
      return {
        'id': 0, // Tambahkan 'id' untuk mapping jawaban

        'question': 'Error: Question not found.',

        'options': [],

        'correct_answer': '',

        'explanation': 'Error loading data.'
      };
    }

    return dailyQuizQuestions[_currentQuestionIndex];
  }

  // Logika Navigasi

  bool get _hasNextQuestion =>
      _currentQuestionIndex < dailyQuizQuestions.length - 1;

  bool get _hasPreviousQuestion => _currentQuestionIndex > 0;

  // Fungsi UNTUK MENYIMPAN JAWABAN SAAT DIPILIH

  void _selectAnswer(String value) {
    final questionId = _currentQuestion['id'] as int;

    setState(() {
      _selectedAnswer = value;

      _userAnswers[questionId] = value; // Simpan/perbarui jawaban ke Map
    });
  }

  void _goToNextQuestion() {
    // Hanya proses jika sudah memilih jawaban

    if (_selectedAnswer != null) {
      if (_hasNextQuestion) {
        setState(() {
          _currentQuestionIndex++;

          final nextId = _currentQuestion['id'] as int;

          // Muat jawaban yang tersimpan untuk soal berikutnya

          _selectedAnswer = _userAnswers[nextId];
        });
      } else {
        // Panggil fungsi hasil saat tes berakhir

        _calculateAndShowResults();
      }
    }
  }

  void _goToPreviousQuestion() {
    if (_hasPreviousQuestion) {
      setState(() {
        _currentQuestionIndex--;

        final previousId = _currentQuestion['id'] as int;

        // Muat jawaban yang tersimpan untuk soal sebelumnya

        _selectedAnswer = _userAnswers[previousId];
      });
    }
  }

  // Fungsi BARU untuk menghitung skor dan navigasi ke ResultPage

  void _calculateAndShowResults() {
    int score = 0;

    // Iterasi melalui data kuis dan membandingkan dengan jawaban pengguna

    for (final question in dailyQuizQuestions) {
      final questionId = question['id'] as int;

      final correctAnswer = question['correct_answer'] as String;

      final userAnswer = _userAnswers[questionId];

      if (userAnswer != null && userAnswer == correctAnswer) {
        score++;
      }
    }

    // Navigasi ke ResultPage

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ResultPage(score: score, totalQuestions: dailyQuizQuestions.length),
      ),
    );
  }

  // Fungsi BARU untuk mereset kuis (dipanggil dari ResultPage)

  // void _restartQuiz() {

  //   setState(() {

  //     _currentQuestionIndex = 0;

  //     _selectedAnswer = null;

  //     _userAnswers.clear();

  //   });

  // }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final int totalQuestions = dailyQuizQuestions.length;

    // Pastikan _selectedAnswer dimuat dari _userAnswers setiap kali build

    final currentId = _currentQuestion['id'] as int;

    _selectedAnswer = _userAnswers[currentId];

    return Scaffold(
      backgroundColor: _primaryColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // --- QUESTION SECTION ---

            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: screenSize.height * 0.05,
                  left: screenSize.width * 0.08,
                  right: screenSize.width * 0.08,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Test (${_currentQuestionIndex + 1}/$totalQuestions)',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 14,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _currentQuestion['question'] ?? 'Loading Question...',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                            color: Colors.black,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                          ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),

            // --- ANSWERS & NAVIGATION SECTION ---

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 35),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x1A000000),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Dynamic Answer Buttons

                  ...(_currentQuestion['options'] as List<String>)
                      .map((optionText) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),

                      child: _buildAnswerButton(context,
                          text: optionText,
                          value: optionText,
                          onTap: _selectAnswer), // Menggunakan _selectAnswer
                    );
                  }).toList(),

                  const SizedBox(height: 25),

                  // Explanation Card

                  if (_selectedAnswer != null)
                    _buildExplanationCard(
                        context,
                        _currentQuestion['explanation'] ??
                            'No explanation provided.'),

                  const SizedBox(height: 15),

                  // Navigation Buttons (Previous & Next/Finish)

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: _buildNavigationButton(
                          context,
                          icon: Icons.arrow_back_rounded,
                          label: 'Previous',
                          onPressed: _goToPreviousQuestion,
                          accentColor: Colors.blueGrey,
                          isDisabled: !_hasPreviousQuestion,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildNavigationButton(
                          context,

                          icon: Icons.arrow_forward_rounded,

                          label: _hasNextQuestion
                              ? 'Next Question'
                              : 'Finish Test', // Label 'Finish Test'

                          onPressed: _goToNextQuestion,

                          accentColor: _accentColor,

                          // Hanya diaktifkan jika sudah dijawab

                          isDisabled: _selectedAnswer == null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Explanation (Teks 'Explanation:' sudah Bahasa Inggris)

  Widget _buildExplanationCard(BuildContext context, String explanation) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x801D4ED8), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explanation:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: _accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            explanation,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black87,
                  fontSize: 14,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }

  // Widget Tombol Jawaban (Diperbarui untuk mengecek jawaban dari _userAnswers)

  Widget _buildAnswerButton(BuildContext context,
      {required String text,
      required String value,
      required Function(String) onTap}) {
    // Cek apakah jawaban untuk soal ini sudah tersimpan di map

    final bool isAnswered =
        _userAnswers.containsKey(_currentQuestion['id'] as int) &&
            _userAnswers[_currentQuestion['id'] as int] != null;

    final bool isSelected = _selectedAnswer == value;

    final bool isCorrect = _currentQuestion['correct_answer'] == value;

    Color borderColor = Colors.grey.shade300;

    Color textColor = Colors.black87;

    Color bgColor = Colors.white;

    // Logic warna feedback

    if (isAnswered) {
      if (isSelected && isCorrect) {
        borderColor = Colors.green.shade700;

        bgColor = Colors.green.shade50;

        textColor = Colors.green.shade700;
      } else if (isSelected && !isCorrect) {
        borderColor = Colors.red.shade700;

        bgColor = Colors.red.shade50;

        textColor = Colors.red.shade700;
      } else if (isCorrect && !isSelected) {
        borderColor = Colors.green.shade400;
      }
    } else if (isSelected) {
      borderColor = _accentColor;

      textColor = _accentColor;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),

        // Disable tap jika sudah dijawab

        onTap: isAnswered ? null : () => onTap(value),

        child: Container(
          height: 64,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x1A000000),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: textColor,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget Tombol Navigasi (Teks 'Previous', 'Next Question', 'Finish Test' sudah Bahasa Inggris)

  Widget _buildNavigationButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed,
      required Color accentColor,
      required bool isDisabled}) {
    final Color buttonBg = isDisabled ? Colors.grey.shade300 : accentColor;

    final Color iconColor = isDisabled ? Colors.grey.shade600 : Colors.white;

    final Color textColor = isDisabled ? Colors.grey.shade600 : Colors.white;

    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBg,
          elevation: 8,
          shadowColor: const Color(0x33000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon == Icons.arrow_back_rounded)
              Icon(icon, size: 24, color: iconColor),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (icon == Icons.arrow_forward_rounded)
              Icon(icon, size: 24, color: iconColor),
          ],
        ),
      ),
    );
  }
}
