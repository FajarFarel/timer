# Responsive UI Steps

- [x] 1. Make home.dart responsive (LayoutBuilder, dynamic widths)
- [x] 2. Improve login.dart & splashscreen.dart logos
- [x] 3. Test HP/laptop sizes

**RESPONSIVE UI DONE**

**Changes:**
- home.dart: LayoutBuilder + screenWidth * ratios, clamp max/min
- login.dart: ConstrainedBox maxWidth + dynamic logo/padding
- splashscreen.dart: FittedBox logo responsive

Test: flutter run -d windows (laptop) vs emulator (HP)

