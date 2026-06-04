import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import '../uttils/colors.dart';
import 'preptime.dart';

class TimerPage extends StatefulWidget {
  final int prepSeconds;
  final int workSeconds;
  final int rounds;
  final String name;
  final String sound;

  const TimerPage({
    super.key,
    required this.prepSeconds,
    required this.workSeconds,
    required this.rounds,
    required this.name,
    required this.sound,
  });

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage>
    with SingleTickerProviderStateMixin {
  final AudioPlayer finalSoundPlayer = AudioPlayer();
  bool _playedFinalSound = false;

  late AnimationController _controller;

  bool isPrep = true;
  int currentRound = 1;

  bool showCountdown = false;
  bool alreadyTriggered = false;

  @override
  void initState() {
    super.initState();

    _initFinalSound();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.prepSeconds),
    );

    /// DETEKSI 10 DETIK TERAKHIR (visual only)
    _controller.addListener(() {
      if (!_controller.isAnimating) return;

      final total = _controller.duration!.inSeconds;
      final elapsed = _controller.lastElapsedDuration?.inSeconds ?? 0;
      final remaining = total - elapsed;

      if (!isPrep && remaining == 10 && !alreadyTriggered) {
        alreadyTriggered = true;

        setState(() {
          showCountdown = true;
        });

        Future.delayed(const Duration(seconds: 10), () {
          if (mounted) {
            setState(() {
              showCountdown = false;
              alreadyTriggered = false;
            });
          }
        });
      }
    });

    /// LOGIC PERPINDAHAN FASE - SOUND + DELAY HERE
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.dismissed) {
        // Play final sound from home selection
        await _playFinalSound();

        // Delay 5s before next phase
        await Future.delayed(const Duration(seconds: 5));

        _playedFinalSound = false; // Reset

        if (isPrep) {
          setState(() {
            isPrep = false;
            currentRound = 1;
          });

          _controller.duration = Duration(seconds: widget.workSeconds);
          _controller.reverse(from: 1.0);
        } else {
          if (currentRound < widget.rounds) {
            setState(() {
              currentRound++;
              alreadyTriggered = false;
            });

            _controller.duration = Duration(seconds: widget.workSeconds);
            _controller.reverse(from: 1.0);
          } else {
            print("Semua ronde selesai 🔥");
          }
        }
      }
    });

    /// MULAI TIMER
    _controller.reverse(from: 1.0);
  }

  Future<void> _initFinalSound() async {
    try {
      await finalSoundPlayer.setReleaseMode(ReleaseMode.stop);
      await finalSoundPlayer.setSource(AssetSource('sounds/${widget.sound}'));
    } catch (e) {
      debugPrint("Final sound init error: $e");
    }
  }

  Future<void> _playFinalSound() async {
    try {
      await finalSoundPlayer.stop();
      await finalSoundPlayer.resume();
      debugPrint("Final sound played: ${widget.sound}");
    } catch (e) {
      debugPrint("Final sound play error: $e");
    }
  }

  @override
  void dispose() {
    finalSoundPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// FORMAT TIMER
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
      backgroundColor: AppColors.background,

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Timer",
          style: GoogleFonts.abrilFatface(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxWidth * 0.75;

          return Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    /// TIMER UTAMA
                    SizedBox(
                      width: size,
                      height: size,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          /// PROGRESS RING
                          CircularProgressIndicator(
                            value: _controller.value,
                            color: const Color(0xFF6C5337),
                            strokeWidth: size * 0.50,
                            backgroundColor: Colors.white,
                          ),

                          /// INNER CIRCLE
                          Container(
                            width: size * 0.50,
                            height: size * 0.50,
                            decoration: const BoxDecoration(
                              color: AppColors.background,
                              shape: BoxShape.circle,
                            ),
                          ),

                          /// TEXT TIMER
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isPrep ? "PREP" : "WORK",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              if (!isPrep)
                                Text(
                                  "Round $currentRound/${widget.rounds}",
                                  style: const TextStyle(fontSize: 16),
                                ),

                              const SizedBox(height: 10),

                              Text(
                                timeLeft,
                                style: TextStyle(
                                  fontSize: size * 0.12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// OVERLAY COUNTDOWN (10s visual + beep)
                    if (showCountdown)
                      Preptime(name: widget.name, sound: widget.sound),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
