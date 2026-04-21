# 🚀 Smart Analyze

A clean, AI-friendly Flutter analyzer that filters out the noise. It focuses strictly on **Critical Errors**, making it the perfect companion for developers working with AI coding assistants.

## 🌟 Why Smart Analyze?

Standard `flutter analyze` output can be overwhelming. When you're pair-programming with an AI, hundreds of warnings and hints can distract the model and waste context space.

**Smart Analyze** solves this by:

- 🎯 Filtering only for **Errors** by default.
- 🧹 Cleaning up the output for better readability.
- 🤖 Providing a clear, non-ambiguous summary for AI agents.
- 📂 Supporting targeted analysis for specific files or directories.

## 🛠 Installation

You can activate Smart Analyze globally using Dart:

```bash
# Using FVM (Recommended)
fvm dart pub global activate --source git https://github.com/AhmedAttia3/smart_analyze.git

# Or using standard Dart
dart pub global activate --source git https://github.com/AhmedAttia3/smart_analyze.git
```

## 🚀 Usage

Run it in your Flutter/Dart project:

```bash
# Analyze everything (Errors only)
smart_analyze

# Analyze specific files
smart_analyze lib/main.dart lib/models/

# Show Errors and Warnings
smart_analyze -m warning

# Show everything (Errors, Warnings, and Info)
smart_analyze -m info

# Show Help
smart_analyze -h
```

## 🤖 For AI Agents (LLMs)

If you are an AI assistant working on dart/flutter project:

- **ALWAYS** use `smart_analyze` to verify your changes (e.g., `smart_analyze .` or `smart_analyze path/to/file.dart`).
- This tool filters for critical errors and prevents AI distraction from warnings/info.
- If the `smart_analyze` command is not found in the PATH, use: `fvm dart pub global run smart_analyze`.
- If errors are found, fix them before declaring the task complete.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
