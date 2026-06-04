import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../uttils/colors.dart';
import 'timer.dart';
import '../uttils/card_timer.dart';

class IntervalPage extends StatefulWidget {
  final String name;

  const IntervalPage({super.key, required this.name});

  @override
  State<IntervalPage> createState() => _IntervalPageState();
}

class _IntervalPageState extends State<IntervalPage> {
  int prepSeconds = 0;
  int workSeconds = 0;
  int rounds = 1;

// 🔥 menambahkan sound list
  final Map<String, String> soundMap = {
    "Bell 1": "beep_fast.mp3",
    "Bell 2": "kringg.mp3",
    "Bell 3": "explosion.mp3",
  };

  String selectedSound = "beep_fast.mp3";

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
        centerTitle: true,
        title: Text(
          "Fakultas Kedokteran UPN",
          style: GoogleFonts.abrilFatface(color: AppColors.title, fontSize: 28),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isDesktop
                ? _buildDesktopLayout(key: const ValueKey("desktop"))
                : _buildMobileLayout(key: const ValueKey("mobile")),
          );
        },
      ),
    );
  }

  /// ================= DESKTOP =================
  Widget _buildDesktopLayout({required Key key}) {
    return Stack(
      key: key,
      children: [
        /// 🔥 BACKGROUND LOGO
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: 0.5,
                child: Image.asset("assets/logo_upn.png", width: 260),
              ),
              Opacity(
                opacity: 0.5,
                child: Image.asset("assets/logofk.png", width: 260),
              ),
            ],
          ),
        ),

        /// 🔥 CONTENT
        Column(
          children: [
            const SizedBox(height: 20),
            Text(widget.name, style: GoogleFonts.abrilFatface(fontSize: 30)),
            const SizedBox(height: 20),

            /// 🔥 ATAS (CARD AREA)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => openPicker(
                      prepSeconds,
                      (v) => setState(() => prepSeconds = v),
                    ),
                    child: _buildTimeCard(
                      label: "Waktu persiapan:",
                      value: format(prepSeconds),
                      width: 500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(width: 400, child: _buildMainTimerCard()),
                ],
              ),
            ),

            /// 🔥 BAWAH (BUTTON SENDIRI)
            Padding(
              padding: const EdgeInsets.all(20),
              child: _buildStartButton(),
            ),
          ],
        ),
      ],
    );
  }

  /// ================= MOBILE =================
  Widget _buildMobileLayout({required Key key}) {
    return Stack(
      key: key,
      children: [
        /// BACKGROUND
        Positioned.fill(
          child: Center(
            child: Opacity(
              opacity: 0.06,
              child: Image.asset("assets/logo_upn.png", width: 250),
            ),
          ),
        ),

        /// SCROLL CONTENT
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.name,
                    style: GoogleFonts.abrilFatface(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () => openPicker(
                      prepSeconds,
                      (v) => setState(() => prepSeconds = v),
                    ),
                    child: _buildTimeCard(
                      label: "Waktu persiapan:",
                      value: format(prepSeconds),
                      width: double.infinity,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildMainTimerCard(),
                ],
              ),
            ),
          ),
        ),

        /// BUTTON FIXED
        Positioned(left: 16, right: 16, bottom: 16, child: _buildStartButton()),
      ],
    );
  }

  /// ================= START BUTTON =================
  Widget _buildStartButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TimerPage(
              prepSeconds: prepSeconds,
              workSeconds: workSeconds,
              rounds: rounds,
              name: widget.name,
              sound: selectedSound,
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
    );
  }

  /// ================= TIME CARD =================
  Widget _buildTimeCard({
    required String label,
    required String value,
    required double width,
  }) {
    return Container(
      height: 80,
      width: width,
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

  /// ================= MAIN TIMER =================
  Widget _buildMainTimerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
        color: AppColors.card_background,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () => openPicker(workSeconds, (v) => workSeconds = v),
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.appbar,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedSound,
                            icon: const Icon(Icons.music_note),
                            dropdownColor: AppColors.appbar,
                            onChanged: (value) {
                              setState(() {
                                selectedSound = value!;
                              });
                            },
                            items: soundMap.entries.map((entry) {
                              return DropdownMenuItem<String>(
                                value: entry.value,
                                child: Text(entry.key),
                              );
                            }).toList(),
                          ),
                        ),
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
          _buildRoundsSection(),
        ],
      ),
    );
  }

  /// ================= ROUNDS =================
  Widget _buildRoundsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.card_background,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
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
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                width: 90,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _timerButton(String text) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.button_action,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 40, color: Colors.white),
        ),
      ),
    );
  }
}
