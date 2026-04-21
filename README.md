<p align="center">
  <a href="https://dart.dev" title="Dart"><img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" /></a>
  <a href="https://flutter.dev" title="Flutter"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  <img src="https://img.shields.io/badge/Numerical%20methods-6A1B9A?style=for-the-badge&logo=latex&logoColor=white" alt="Math / LaTeX" />
</p>

<h1 align="center">📐 NAPP 🔢</h1>

<p align="center">
  <strong>N</strong>umerical <strong>A</strong>nalysis <strong>P</strong>layground — roots, iterations, and linear algebra helpers 📊
</p>

---

**NAPP** is a Flutter app for **numerical methods**: it helps you enter a function and parameters, runs classic root-finding algorithms, and shows iteration tables and an approximate root.

Chapter 1 (nonlinear equations) is fully implemented. Chapter 2 (linear systems) provides a matrix-style input screen; the **Calculate** action is not wired to solvers yet, and `lib/screens/chapter_2/answer_screen.dart` is currently empty.

## ✨ Features

### 📈 Chapter 1 — Roots of \(f(x) = 0\)

| Method | Inputs (typical) |
|--------|------------------|
| **Bisection** | \(f(x)\), interval \(X_L\), \(X_U\), error tolerance |
| **False position** | Same as bisection |
| **Simple fixed-point** | \(f(x)\), iteration \(x = g(x)\) (second expression), \(X_0\), error |
| **Newton** | \(f(x)\), \(f'(x)\), \(X_0\), error |
| **Secant** | \(f(x)\), \(X_{-1}\), \(X_0\), error |

- 🧮 Functions are parsed with [`math_parser`](https://pub.dev/packages/math_parser) (independent variable **`x`**).
- 📝 Results screen uses [`tex_text`](https://pub.dev/packages/tex_text) to render formulas nicely.
- ⚠️ Bisection and false position detect when \(f(x_L) \cdot f(x_U) > 0\) and show an error instead of iterating.

### 🔲 Chapter 2 — Linear systems (UI only)

Cards for **Gauss elimination**, **LU decomposition**, **Cramer’s rule**, and **Gauss–Jordan elimination** open a **3×3** augmented-style table (\(X_1, X_2, X_3, b\)). Fractions like `1/2` are accepted in cells. **Solvers for this chapter are not connected in the current codebase.**

## 🛠️ Requirements

- 📱 [Flutter](https://docs.flutter.dev/get-started/install) (Dart SDK **^3.9.0** as in `pubspec.yaml`)
- 💻 A device or emulator for Android / iOS / desktop / web, depending on your target

## 🚀 Getting started

From the project root:

```bash
flutter pub get
flutter run
```

Release build example (Android):

```bash
flutter build apk --release
```

## 📁 Project layout

| Path | Role |
|------|------|
| `lib/main.dart` | `MaterialApp`, theme, `HomeScreen` |
| `lib/screens/home_screen.dart` | Chapter 1 & 2 method cards |
| `lib/widgets/cards.dart` | Routes each method to its input screen |
| `lib/screens/chapter_1/` | Function input (`input_screen.dart`) and results (`answer_screen.dart`) |
| `lib/screens/chapter_2/` | System input (`input_screen.dart`); answer screen placeholder |
| `lib/core/utils/the_function.dart` | Wraps `math_parser` for \(f(x)\) |
| `lib/core/solver/` | Bisection, false position, fixed point, Newton, secant |

## 🎨 Assets and fonts

- 🔤 **Font:** Bebas Neue (`fonts/BebasNeue-Regular.ttf`) for chapter headings.
- 🖼️ **Assets:** `asset/` is declared in `pubspec.yaml` (add files there if the app needs images or other bundles).

## 🏷️ Version

`pubspec.yaml`: **1.0.1+1**

## 📄 License

Licensed under the [MIT License](LICENSE). Copyright © 2026 Mikhael Sameh Ferwez Masoud.
