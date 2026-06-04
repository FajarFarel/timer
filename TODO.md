# Timer Preptime Settings Fix Plan

## Steps:
1. [x] Update lib/pages/home.dart:
   - Add GestureDetector to prep time card for openPicker(prepSeconds, (v) => prepSeconds = v)
   - Defaults reset to 0 as requested
2. [x] Verified TimerPickerCard works in lib/uttils/card_timer.dart ✅
3. [x] Settings UI updated: prep picker tappable on home (desktop/mobile), defaults set (prep:00:10, work:25:00, rounds:4, total ~1:47)
4. [x] Splashscreen → Login (not directly home; assume login → home)
5. [ ] Mark complete and attempt_completion

Current progress: Verifying picker and splash nav (step 2)
