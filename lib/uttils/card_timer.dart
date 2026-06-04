import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerPickerCard extends StatefulWidget {
  final int initialMinute;
  final int initialSecond;
  final void Function(int minute, int second) onSave;

  const TimerPickerCard({
    super.key,
    required this.initialMinute,
    required this.initialSecond,
    required this.onSave,
  });

  @override
  State<TimerPickerCard> createState() => _TimerPickerCardState();
}

class _TimerPickerCardState extends State<TimerPickerCard> {
  late int minute;
  late int second;

  @override
  void initState() {
    super.initState();
    minute = widget.initialMinute;
    second = widget.initialSecond;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const Text(
            "Atur Waktu",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: Row(
              children: [
                _buildPicker(
                  max: 59,
                  initial: minute,
                  onChanged: (v) => minute = v,
                ),
                const Text(":", style: TextStyle(fontSize: 30)),
                _buildPicker(
                  max: 59,
                  initial: second,
                  onChanged: (v) => second = v,
                ),
              ],
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              widget.onSave(minute, second);
              Navigator.pop(context);
            },
            child: const Text("SIMPAN", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker({
    required int max,
    required int initial,
    required Function(int) onChanged,
  }) {
    return Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: initial),
        itemExtent: 40,
        useMagnifier: true,
        onSelectedItemChanged: onChanged,
        children: List.generate(
          max + 1,
          (i) => Center(
            child: Text(
              i.toString().padLeft(2, '0'),
              style: const TextStyle(fontSize: 26),
            ),
          ),
        ),
      ),
    );
  }
}
