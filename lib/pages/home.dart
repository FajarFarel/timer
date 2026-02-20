import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../uttils/colors.dart';
import 'timer.dart';
import '../uttils/card_timer.dart';

class IntervalPage extends StatefulWidget {
  const IntervalPage({super.key});

  @override
  State<IntervalPage> createState() => _IntervalPageState();
}

class _IntervalPageState extends State<IntervalPage> {
  int prepSeconds = 0;
  int workSeconds = 0;
  int rounds = 1;

  int get totalSeconds => (rounds * workSeconds) + prepSeconds;

  void openPicker(int current, void Function(int) onSave) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => TimerPickerCard(
        initialMinute: current ~/ 60,
        initialSecond: current % 60,
        onSave: (m, s) => setState(() => onSave(m * 60 + s)),
      ),
    );
  }

  String format(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  String formatTotalTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;

    return "${h.toString().padLeft(2, '0')}:"
        "${m.toString().padLeft(2, '0')}:"
        "${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appbar,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Fakultas Kedokteran UPN",
          style: GoogleFonts.abrilFatface(
            color: AppColors.title,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// PREP TIME
              GestureDetector(
                onTap: () => openPicker(prepSeconds, (v) => prepSeconds = v),
                child: _buildTimeCard(
                  label: "Waktu persiapan:",
                  value: format(prepSeconds),
                ),
              ),

              const SizedBox(height: 20),

              /// MAIN CARD (TANPA GestureDetector BESAR)
              _buildMainTimerCard(),

              const Spacer(),

              /// START
              InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TimerPage(
                        prepSeconds: prepSeconds,
                        workSeconds: workSeconds,
                        rounds: rounds,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2b2b2b),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Total waktu: ${formatTotalTime(totalSeconds)}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "START",
                          style: GoogleFonts.abrilFatface(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// CARD PREP
  Widget _buildTimeCard({required String label, required String value}) {
    return Container(
      height: 80,
      width: 580,
      decoration: BoxDecoration(
        color: AppColors.card_background,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(label, style: GoogleFonts.abrilFatface(fontSize: 18)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              value,
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// MAIN CARD
  Widget _buildMainTimerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
        color: AppColors.card_background,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          /// WAKTU (INI AJA YANG BISA DI TAP)
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: GestureDetector(
              onTap: () => openPicker(workSeconds, (v) => workSeconds = v),
              child: Container(
                height: 80,
                width: 580,
                decoration: BoxDecoration(
                  color: AppColors.appbar,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Stack(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.music_note),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Waktu 1",
                        style: GoogleFonts.abrilFatface(fontSize: 18),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        format(workSeconds),
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// BUTTON + PUTARAN
          Container(
            height: 80,
            width: 580,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.card_background,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (rounds < 99) rounds++;
                        });
                      },
                      child: _timerButton("+"),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (rounds > 1) rounds--;
                        });
                      },
                      child: _timerButton("-"),
                    ),
                  ],
                ),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6D4336),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Putaran:",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        rounds.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// BUTTON
  Widget _timerButton(String text) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.button_action,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(text == "+" ? 20 : 0),
          topRight: Radius.circular(text == "+" ? 0 : 20),
          bottomLeft: Radius.circular(text == "+" ? 20 : 0),
          bottomRight: Radius.circular(text == "+" ? 0 : 20),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 40, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
                  