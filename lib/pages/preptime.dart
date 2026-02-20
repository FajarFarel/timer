import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Preptime extends StatefulWidget {
  const Preptime({super.key});

  @override
  State<Preptime> createState() => _PreptimeState();
}

class _PreptimeState extends State<Preptime>
    with TickerProviderStateMixin {
  int seconds = 10;
  late Timer timer;

  late AnimationController scaleCtrl;
  late AnimationController shakeCtrl;
  late Animation<double> scaleAnim;

  final random = Random();
  final AudioPlayer beepPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // 🎞️ INIT ANIMATION
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
      end: 1.3,
    ).animate(
      CurvedAnimation(
        parent: scaleCtrl,
        curve: Curves.elasticOut,
      ),
    );

    // 🔊 PRELOAD SOUND
    beepPlayer.setAsset('assets/sound/beep.mp3');

    // ⏱️ BARU JALANIN TIMER
    startCountdown();
  }

  void startCountdown() {
    scaleCtrl.forward();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (seconds == 0) {
        timer.cancel();
        return;
      }

      if (seconds == 1) {
        await beepPlayer.setAsset('assets/explosion.mp3');
      } else {
        await beepPlayer.setAsset('assets/beep.mp3');
        beepPlayer.setSpeed(seconds <= 3 ? 1.4 : 1.0);
      }

      await beepPlayer.seek(Duration.zero);
      await beepPlayer.play();

      setState(() => seconds--);

      scaleCtrl
        ..reset()
        ..forward();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    scaleCtrl.dispose();
    shakeCtrl.dispose();
    beepPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDanger = seconds <= 3;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: isDanger ? Colors.red.withOpacity(0.9) : Colors.black,
        child: Center(
          child: AnimatedBuilder(
            animation: shakeCtrl,
            builder: (context, child) {
              final dx = isDanger ? random.nextDouble() * 10 - 5 : 0.0;
              final dy = isDanger ? random.nextDouble() * 10 - 5 : 0.0;

              return Transform.translate(
                offset: Offset(dx, dy),
                child: ScaleTransition(
                  scale: scaleAnim,
                  child: Text(
                    seconds == 0
                        ? "💥 HIDUP JOKOWI 💥"
                        : seconds.toString(),
                    style: TextStyle(
                      fontSize: seconds == 0 ? 80 : 140,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 30,
                          color: isDanger
                              ? Colors.yellow
                              : Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
