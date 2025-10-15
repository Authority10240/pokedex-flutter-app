# 🔥 Pokédex - Gotta Catch 'Em All!

A beautiful, cross-platform Pokédex application built with **Flutter** and **Firebase**. Browse, search, and collect your favorite Pokémon with a modern, responsive UI that works seamlessly across all platforms!

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## ✨ Features

### 🎮 Core Features
- **Browse All Pokémon** - Explore the complete Pokédex with beautiful cards
- **Advanced Search** - Find Pokémon by name with instant results
- **Detailed Information** - View stats, abilities, types, and more
- **Favorites System** - Save and manage your favorite Pokémon
- **Infinite Scroll** - Seamless pagination for smooth browsing

### 🔐 Authentication
- **Firebase Auth** - Secure email/password authentication
- **User Profiles** - Personalized experience for each trainer
- **Guest Mode** - Browse without signing in (with Firebase disabled)

### 🎨 UI/UX
- **Dark/Light Theme** - Toggle between themes instantly
- **Responsive Design** - Works on phones, tablets, and desktops
- **Material Design 3** - Modern, beautiful interface
- **Smooth Animations** - Delightful transitions and effects
- **Type-based Colors** - Color-coded Pokémon cards by type

### 📱 Cross-Platform Support
- ✅ **iOS** (iPhone & iPad)
- ✅ **Android** (Phones & Tablets)
- ✅ **macOS** (Desktop)
- ✅ **Web** (Progressive Web App)
- ✅ **Windows** (Coming Soon)
- ✅ **Linux** (Coming Soon)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.32.5 or higher)
- Dart SDK (3.8.1 or higher)
- Firebase account (for authentication)
- iOS: Xcode 16.2+ and macOS 10.15+
- Android: Android Studio and SDK 33+

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/Authority10240/pokedex-flutter-app.git
cd pokedex-flutter-app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Firebase Setup** (Optional - app works without Firebase)
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

4. **Enable Email/Password Authentication**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Select your project
   - Navigate to Authentication > Sign-in method
   - Enable Email/Password authentication

5. **Run the app**
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# macOS
flutter run -d macos

# Web
flutter run -d chrome

# Or select device interactively
flutter run
```

## 🏗️ Architecture

### Project Structure
```
lib/
├── constants/       # App-wide constants
├── models/          # Data models
├── services/        # API and business logic
│   ├── auth_service.dart
│   ├── pokemon_service.dart
│   └── storage_service.dart
├── viewmodels/      # State management (Provider)
│   ├── auth_viewmodel.dart
│   ├── pokemon_viewmodel.dart
│   └── theme_viewmodel.dart
├── views/           # UI components
│   ├── screens/     # Full-page screens
│   └── widgets/     # Reusable widgets
└── utils/           # Helper functions
```

### Tech Stack
- **Framework**: Flutter 3.32.5
- **State Management**: Provider
- **Backend**: Firebase (Auth)
- **API**: [PokéAPI](https://pokeapi.co/)
- **Local Storage**: SharedPreferences
- **HTTP Client**: http package
- **Image Caching**: cached_network_image

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.5+1
  
  # Firebase
  firebase_core: ^3.15.2
  firebase_auth: ^5.7.0
  
  # Networking
  http: ^1.5.0
  
  # Local Storage
  shared_preferences: ^2.5.3
  
  # UI Components
  cached_network_image: ^3.4.1
  shimmer: ^3.0.0
  cupertino_icons: ^1.0.8
```

## 🎯 Features in Detail

### Pokemon Browsing
- Grid view with responsive columns (2 on mobile, 4 on tablet)
- Beautiful cards with:
  - Pokémon image
  - Name and ID
  - Type chips with color coding
  - Favorite button
- Smooth infinite scroll with pagination

### Search System
- Real-time search as you type
- Search history tracking
- Clear search functionality
- Filtered results display

### Favorites
- Local storage for offline access
- Quick favorite/unfavorite toggle
- Dedicated favorites screen
- Synced across sessions

### Authentication
- Email/Password sign in/up
- Form validation
- Error handling
- Profile management
- Secure logout

### Theme System
- Light and Dark themes
- Instant theme switching
- Persistent theme preference
- Material Design 3 colors

## 🔧 Configuration

### Firebase Setup
The app includes `firebase_options.dart` with platform-specific configurations. To use your own Firebase project:

1. Create a new Firebase project
2. Run `flutterfire configure`
3. Enable Email/Password authentication
4. Replace the generated `firebase_options.dart`

### API Configuration
The app uses PokéAPI with no authentication required. Default settings in `lib/constants/app_constants.dart`:
- Base URL: `https://pokeapi.co/api/v2`
- Pagination: 20 items per page

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 📱 Screenshots

*(Add your app screenshots here)*

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- [PokéAPI](https://pokeapi.co/) - The amazing Pokémon API
- [Flutter](https://flutter.dev/) - The UI framework
- [Firebase](https://firebase.google.com/) - Authentication backend
- Pokémon and all related assets are © Nintendo/Game Freak

## 📞 Contact

**Freedom Mathebula**
- GitHub: [@Authority10240](https://github.com/Authority10240)
- Email: themba10240@gmail.com

## 🗺️ Roadmap

- [ ] Add advanced filtering (by type, generation, stats)
- [ ] Team builder functionality
- [ ] Pokémon comparison feature
- [ ] Evolution chain visualization
- [ ] Offline mode with cached data
- [ ] Push notifications for new Pokémon
- [ ] Social features (share favorites)
- [ ] Multi-language support

---

**Made with ❤️ and Flutter**
