# Movie Explorer App

A Flutter application that allows users to explore and discover movies using a public movie database API. This app was developed as part of the IIT Guwahati Coding Week 25 Task 3.

## Features

- 🔍 Search and discover movies
- 📱 Clean and responsive UI
- ⭐ Mark movies as favorites
- 💾 Local storage for favorite movies
- 🔄 Asynchronous data fetching
- ⚡ State management for loading, success, and error states

## Technical Implementation

- Built with Flutter framework
- Uses async/await for non-blocking API calls
- Implements proper state management
- Integrates with a public movie database API
- Features local storage for persisting favorite movies

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK (latest version)
- Android Studio / VS Code with Flutter extensions
- An API key from a movie database service (e.g., OMDb API)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Ayush-Raj-Chourasia/App-Development-Task_3.git
```

2. Navigate to the project directory:
```bash
cd movie_explorer
```

3. Install dependencies:
```bash
flutter pub get
```

4. Add your API key to the configuration file

5. Run the app:
```bash
flutter run
```

## Project Structure

```
movie_explorer/
├── lib/
│   ├── models/       # Data models
│   ├── screens/      # UI screens
│   ├── services/     # API services
│   ├── widgets/      # Reusable widgets
│   └── main.dart     # Entry point
├── assets/          # Images and other assets
└── pubspec.yaml     # Dependencies
```

## Dependencies

- [Flutter](https://flutter.dev/) - UI Framework
- [Provider](https://pub.dev/packages/provider) - State Management
- [http](https://pub.dev/packages/http) - API Calls
- [shared_preferences](https://pub.dev/packages/shared_preferences) - Local Storage

## Contributing

This project was developed as part of a coding task. Feel free to fork and modify for your own learning purposes.

## License

This project is open source and available under the MIT License.

## Acknowledgments

- IIT Guwahati Coding Club for the task
- Flutter team for the amazing framework
- Movie database API providers
