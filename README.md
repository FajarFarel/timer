# ⏱️ Interval Timer

A clean and responsive interval timer built with **Flutter** for Android and Windows.

Designed for workout, practice, training, and other activities that need structured preparation time, work intervals, rounds, countdown feedback, and customizable sounds.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.44+-02569B?logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.9+-0175C2?logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20Windows-555555" alt="Platform">
</p>

## ✨ Features

* ⏳ Custom preparation time
* 🏋️ Configurable work duration
* 🔁 Up to 99 rounds
* 🔊 Multiple timer sounds
* 🔔 Countdown feedback during the final 10 seconds
* 💥 Animated countdown and finish screen
* 📊 Total session duration preview
* 📱 Responsive mobile layout
* 🖥️ Dedicated desktop layout
* 💾 Lightweight local app with no account or backend required

## 📥 Download

Ready-to-use builds are available from the GitHub Releases page.

| Platform   | Download                                                               |
| ---------- | ---------------------------------------------------------------------- |
| 🤖 Android | [Download APK](https://github.com/FajarFarel/timer/releases)           |
| 🪟 Windows | [Download Windows Build](https://github.com/FajarFarel/timer/releases) |

> Open **Releases** and choose the latest version for your platform.

## 🎯 How It Works

1. Set the **preparation time**.
2. Set the **work interval**.
3. Choose the timer sound.
4. Set the number of rounds.
5. Press **START**.
6. The timer runs through the configured intervals automatically.
7. A visual 10-second countdown appears near the end of each work interval.
8. When the session is complete, the finish sound and animation are triggered.

## 🛠️ Tech Stack

* **Flutter**
* **Dart**
* `shared_preferences` — local preferences
* `google_fonts` — custom typography
* `audioplayers` — timer audio
* `vibration` — device feedback

## 🚀 Run Locally

### Requirements

* Flutter SDK
* Dart SDK compatible with the project
* Android Studio for Android development
* Visual Studio with Desktop development with C++ for Windows development

### Clone

```bash
git clone https://github.com/FajarFarel/timer.git
cd timer
```

### Install dependencies

```bash
flutter pub get
```

### Run

Android:

```bash
flutter run
```

Windows:

```bash
flutter run -d windows
```

## 📦 Build

Android APK:

```bash
flutter build apk --release
```

Windows:

```bash
flutter build windows --release
```

The generated Windows application can be packaged into an installer such as an Inno Setup installer.

## 📁 Project Structure

```text
timer/
├── assets/
│   └── sounds/
├── lib/
│   ├── pages/
│   │   ├── home.dart
│   │   ├── preptime.dart
│   │   └── timer.dart
│   └── uttils/
├── android/
├── windows/
├── pubspec.yaml
└── README.md
```

## 👨‍💻 Author

**Fajar Farel**

* GitHub: [@FajarFarel](https://github.com/FajarFarel)

> Turning ideas into products, one commit at a time.

## 📄 License

This project is currently provided without a specified open-source license.
