import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../uttils/colors.dart';

class TimerPage extends StatefulWidget {
  final int prepSeconds;
  final int workSeconds;
  final int rounds;

  const TimerPage({
    super.key,
    required this.prepSeconds,
    required this.workSeconds,
    required this.rounds,
  });
  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {  
    super.initState();
    final totalSeconds =
        (widget.rounds * widget.workSeconds) + widget.prepSeconds;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: totalSeconds),
    );

    _controller.reverse(from: 1.0); // mulai dari penuh → kosong
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get timeLeft {
    final total = _controller.duration!.inSeconds;
    final elapsed = _controller.lastElapsedDuration?.inSeconds ?? 0;
    final remaining = (total - elapsed).clamp(0, total);

    final m = remaining ~/ 60;
    final s = remaining % 60;

    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Timer",
          style: GoogleFonts.abrilFatface(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: AppColors.background,
      body:
      LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxWidth * 0.75;

          return Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return SizedBox(
                  width: size,
                  height: size,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // RING LUAR
                      CircularProgressIndicator(
                        value: _controller.value,
                        color: Color(0xFF6C5337),
                        strokeWidth: size * 0.50,
                        backgroundColor: Colors.white,
                      ),

                      // 🔥 MASK TENGAH (INI KUNCINYA)
                      Container(
                        width: size * 0.50,
                        height: size * 0.50,
                        decoration: const BoxDecoration(
                          color: AppColors.background, // samain sama background
                          shape: BoxShape.circle,
                        ),
                      ),

                      // TEXT
                      Text(
                        timeLeft,
                        style: TextStyle(
                          fontSize: size * 0.12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
