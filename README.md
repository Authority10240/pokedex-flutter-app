# Pokédex App 📱

A comprehensive Flutter application that serves as a digital Pokédex, allowing users to explore, search, and favorite Pokémon using the [PokéAPI](https://pokeapi.co/).

## 🌟 Features

### Core Functionality
- **Authentication System**: Complete login/register functionality with Firebase Auth
- **Pokémon Exploration**: Browse through all Pokémon with infinite scroll pagination
- **Advanced Search**: Search Pokémon by name with search history
- **Detailed View**: Comprehensive Pokémon details including stats, abilities, and descriptions
- **Favorites System**: Save favorite Pokémon with local persistence
- **Theme Support**: Toggle between light and dark themes with preference persistence

### Technical Highlights
- **MVVM Architecture**: Clean separation of concerns with proper architectural patterns
- **State Management**: Efficient state management using Provider pattern
- **Responsive Design**: Optimized for both mobile and tablet devices
- **Offline Support**: Local storage for favorites and user preferences
- **Error Handling**: Robust error handling with user-friendly messages
- **Testing**: Comprehensive unit and widget tests

## 🏗️ Architecture

This project follows the **MVVM (Model-View-ViewModel)** architectural pattern:

```
lib/
├── models/              # Data models and entities
├── views/               # UI components (screens and widgets)
│   ├── screens/         # Application screens
│   └── widgets/         # Reusable UI components
├── viewmodels/          # Business logic and state management
├── services/            # Data services (API, storage, auth)
├── utils/               # Utility functions and extensions
└── constants/           # App constants and configurations
```

### Layer Responsibilities

- **Models**: Define data structures and handle JSON serialization
- **Views**: Handle UI presentation and user interactions
- **ViewModels**: Manage application state and business logic
- **Services**: Handle external data sources and system services

## 🚀 Tech Stack

### Core Technologies
- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language
- **Firebase**: Authentication and backend services
- **PokéAPI**: RESTful API for Pokémon data

### Key Dependencies
- `provider`: State management
- `http`: API communication
- `shared_preferences`: Local storage
- `cached_network_image`: Efficient image loading
- `firebase_auth`: Authentication
- `shimmer`: Loading animations

### Development Tools
- `flutter_test`: Testing framework
- `mockito`: Mocking for tests
- `build_runner`: Code generation
- `flutter_lints`: Code quality

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / VS Code
- Firebase project (for authentication)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pokedex_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup** (Optional - app works without auth)
   ```bash
   # Add your Firebase configuration files:
   # - android/app/google-services.json
   # - ios/Runner/GoogleService-Info.plist
   ```

4. **Run the app**
   ```bash
   # Debug mode
   flutter run
   
   # Release mode
   flutter run --release
   ```

### Platform Setup

#### Android
- Minimum SDK: 21
- Target SDK: 34
- No additional setup required

#### iOS
- Minimum deployment target: 12.0
- No additional setup required

#### Web
- Runs out of the box with Flutter web support

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/models/pokemon_test.dart
```

### Test Structure
```
test/
├── models/              # Model unit tests
├── services/            # Service unit tests
├── viewmodels/          # ViewModel unit tests
└── widgets/             # Widget tests
```

### Test Coverage
- **Unit Tests**: Models, services, and business logic
- **Widget Tests**: UI components and user interactions
- **Integration Tests**: (Can be added for E2E testing)

## 📱 Screenshots

*(Note: Add actual screenshots of your app here)*

### Light Theme
- Home screen with Pokémon grid
- Pokémon detail view
- Search functionality
- Favorites screen

### Dark Theme
- Dark mode variants of all screens
- Theme toggle functionality

## 🎯 Key Features in Detail

### Authentication System
- **Firebase Integration**: Secure user authentication
- **Email/Password**: Standard authentication flow
- **Password Reset**: Email-based password recovery
- **Profile Management**: User profile with display name
- **Persistence**: Auto-login on app restart

### Pokémon Data Management
- **Infinite Scroll**: Seamless loading of Pokémon data
- **Search with History**: Smart search with previous queries
- **Detailed Information**: Comprehensive Pokémon stats and data
- **Image Caching**: Efficient image loading and caching
- **Error Recovery**: Graceful handling of network issues

### User Experience
- **Responsive Design**: Adapts to different screen sizes
- **Theme Switching**: Smooth transitions between light/dark themes
- **Loading States**: Beautiful loading animations
- **Empty States**: Informative empty state screens
- **Error Handling**: User-friendly error messages

## 🔧 Configuration

### API Configuration
The app uses the public PokéAPI with no authentication required:
```dart
// lib/constants/app_constants.dart
static const String baseUrl = 'https://pokeapi.co/api/v2';
```

### Theme Configuration
Customize app themes in:
```dart
// lib/viewmodels/theme_viewmodel.dart
ThemeData get lightTheme { ... }
ThemeData get darkTheme { ... }
```

### Constants
App-wide constants are defined in:
```dart
// lib/constants/app_constants.dart
class AppConstants {
  static const int defaultLimit = 20;
  static const String favoritesKey = 'favorite_pokemon';
  // ... other constants
}
```

## 🚀 Performance Optimizations

- **Image Caching**: Cached network images for faster loading
- **Lazy Loading**: Infinite scroll with pagination
- **State Management**: Efficient state updates with Provider
- **Memory Management**: Proper disposal of resources
- **Error Boundaries**: Graceful error handling throughout the app

## 🔮 Future Enhancements

### Planned Features
- **Advanced Filtering**: Filter by type, generation, stats
- **Battle Simulator**: Simple Pokémon battle mechanics
- **Teams**: Create and manage Pokémon teams
- **Offline Mode**: Cache Pokémon data for offline use
- **Social Features**: Share favorites with other users
- **Animations**: Enhanced UI animations and transitions

### Technical Improvements
- **Bloc Pattern**: Migration to Bloc for complex state management
- **Dio**: Enhanced HTTP client with interceptors
- **Floor**: Local database for better offline support
- **CI/CD**: Automated testing and deployment
- **Flavors**: Environment-specific configurations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Standards
- Follow Dart/Flutter style guidelines
- Add tests for new features
- Update documentation for significant changes
- Use meaningful commit messages

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **PokéAPI**: For providing the comprehensive Pokémon data
- **Flutter Team**: For the amazing cross-platform framework
- **Firebase**: For authentication and backend services
- **Pokémon Company**: For creating the beloved Pokémon universe

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](../../issues) page
2. Create a new issue with detailed information
3. Include device information and error logs

---

**Built with ❤️ using Flutter**

*Gotta Code 'Em All!* 🚀