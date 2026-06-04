import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'home.dart';

class Preptime extends StatefulWidget {
  final String name;
  final String sound;

  const Preptime({super.key, required this.name, required this.sound});

  @override
  State<Preptime> createState() => _PreptimeState();
}

class _PreptimeState extends State<Preptime> with TickerProviderStateMixin {
  int seconds = 10;
  Timer? timer;

  late AnimationController scaleCtrl;
  late AnimationController shakeCtrl;
  late Animation<double> scaleAnim;

  final random = Random();

  // 🔥 2 player biar gak tabrakan
  final AudioPlayer beepPlayer = AudioPlayer();
  final AudioPlayer finalPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _initAudio(); // 🔥 mulai langsung
  }

  Future<void> _initAudio() async {
    try {
      await beepPlayer.setReleaseMode(ReleaseMode.stop);
      await beepPlayer.setSource(AssetSource('sounds/beep.mp3'));

      await finalPlayer.setReleaseMode(ReleaseMode.stop);
      await finalPlayer.setSource(AssetSource('sounds/${widget.sound}'));
    } catch (e) {
      debugPrint("Audio error: $e");
    }

    // 🔥 timer tetap jalan walaupun audio error
    _startCountdown();
  }

  void _initAnimation() {
    scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    )..repeat(reverse: true);

    scaleAnim = Tween<double>(
      begin: 0.6,
      end: 1.2,
    ).animate(CurvedAnimation(parent: scaleCtrl, curve: Curves.elasticOut));
  }

  void _startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      // 🔥 Kalau sudah 0 → play selected sound
      if (seconds == 0) {
        t.cancel();

        await finalPlayer.stop();
        await finalPlayer.resume();

        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => IntervalPage(name: widget.name),
              ),
              (route) => false,
            );
          }
        });
        return;
      }

      // 🔥 10 - 1 pakai beep
      await beepPlayer.stop();
      await beepPlayer.resume();

      scaleCtrl
        ..reset()
        ..forward();

      if (mounted) {
        setState(() => seconds--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    scaleCtrl.dispose();
    shakeCtrl.dispose();
    beepPlayer.dispose();
    finalPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDanger = seconds <= 3;

    return Scaffold(
      body: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: double.infinity,
          color: isDanger ? Colors.red.withOpacity(0.9) : Colors.black,
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.maxWidth * 0.35;

                return AnimatedBuilder(
                  animation: shakeCtrl,
                  builder: (context, child) {
                    final dx = isDanger ? random.nextDouble() * 8 - 4 : 0.0;

                    final dy = isDanger ? random.nextDouble() * 8 - 4 : 0.0;

                    return Transform.translate(
                      offset: Offset(dx, dy),
                      child: ScaleTransition(
                        scale: scaleAnim,
                        child: FittedBox(
                          child: Text(
                            seconds == 0 ? "💥 SELESAI 💥" : seconds.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 30,
                                  color: isDanger ? Colors.yellow : Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
