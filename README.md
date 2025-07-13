# 🌱 GreenSteps: Eco Walking & Reward App

A comprehensive Flutter application that promotes sustainable transportation by helping users find eco-friendly walking and biking routes while earning rewards for their green activities.

## 🎯 Features

### 🗺️ Eco-Friendly Route Finding
- **Smart Route Calculation**: Find the most environmentally friendly walking and biking paths
- **Green Zones Integration**: Prioritize routes through parks, green spaces, and low-pollution areas
- **Real-time Navigation**: GPS-based navigation with eco-friendly route suggestions
- **Multiple Transportation Modes**: Walking, biking, and public transport integration

### 🏆 Rewards & Gamification
- **Eco Points System**: Earn points for every eco-friendly trip taken
- **Achievement Badges**: Unlock badges for various green milestones
- **Daily Challenges**: Complete daily eco-friendly goals
- **Leaderboard**: Compete with friends and community members
- **Progress Tracking**: Monitor your environmental impact over time

### 📊 Analytics & Insights
- **Distance Tracking**: Track total eco-friendly distance traveled
- **Carbon Footprint**: Calculate CO2 savings from using eco-friendly routes
- **Weekly/Monthly Reports**: Detailed analytics of your green activities
- **Impact Visualization**: See your positive environmental impact

### 👤 User Experience
- **Google Sign-In**: Secure authentication with Google
- **Cross-Platform**: Available on Android and Web
- **Beautiful UI**: Modern Material 3 design with green theme
- **Offline Support**: Core features work without internet connection

## 🛠️ Technical Stack

### Frontend
- **Flutter**: Cross-platform mobile and web development
- **Dart**: Programming language
- **Material 3**: Modern UI design system
- **Provider**: State management
- **Font Awesome**: Icon library

### Backend & Services
- **Firebase**: Backend-as-a-Service
  - Authentication (Google Sign-In)
  - Cloud Firestore (Database)
  - Cloud Storage (File storage)
- **Google Maps API**: Maps and navigation
- **Google Directions API**: Route calculation
- **Geolocator**: GPS and location services

### Architecture
- **Clean Architecture**: Separation of concerns
- **Provider Pattern**: State management
- **Service Layer**: Business logic abstraction
- **Model Layer**: Data representation

## 📱 Supported Platforms

- ✅ **Android** (API 23+)
- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- 🔄 **iOS** (Coming Soon)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- Google Maps API Key
- Firebase Project

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/greensteps-app.git
   cd greensteps-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication (Google Sign-In)
   - Enable Cloud Firestore
   - Enable Cloud Storage
   - Download `google-services.json` (Android)
   - Update `firebase_options.dart` with your config

4. **Google Maps Setup**
   - Get Google Maps API Key
   - Enable Maps SDK for Android/iOS
   - Enable Directions API
   - Add API key to platform-specific config

5. **Run the app**
   ```bash
   # For Android
   flutter run -d android
   
   # For Web
   flutter run -d chrome
   ```

## 🔧 Configuration

### Firebase Configuration
```dart
// lib/firebase_options.dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-api-key',
  appId: 'your-app-id',
  messagingSenderId: 'your-sender-id',
  projectId: 'your-project-id',
  authDomain: 'your-domain.firebaseapp.com',
  storageBucket: 'your-bucket.appspot.com',
);
```

### Google Maps API Key
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE" />
```

## 📁 Project Structure

```
lib/
├── models/          # Data models
│   ├── user_model.dart
│   ├── route_model.dart
│   └── goal_model.dart
├── services/        # Business logic services
│   ├── auth_service.dart
│   ├── firebase_service.dart
│   ├── maps_service.dart
│   └── location_service.dart
├── providers/       # State management
│   ├── auth_provider.dart
│   └── app_provider.dart
├── screens/         # UI screens
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── rewards_screen.dart
│   └── profile_screen.dart
├── widgets/         # Reusable UI components
└── main.dart        # App entry point
```

## 🌟 Key Features Implementation

### Authentication Flow
- Google Sign-In integration for both web and mobile
- Firebase Authentication with automatic user creation
- Persistent login state management

### Route Calculation
- Integration with Google Directions API
- Eco-friendly route scoring algorithm
- Real-time GPS tracking and navigation

### Rewards System
- Point calculation based on distance and route type
- Achievement system with multiple badge categories
- Daily challenge generation and completion tracking

### Data Management
- Firestore for user data and app state
- Real-time synchronization across devices
- Offline data caching for core features

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Developer**: Your Name
- **Project Type**: Hackathon Project
- **Category**: Environmental Technology

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Google Maps for navigation services
- Font Awesome for beautiful icons
- The open-source community for various packages

## 📞 Support

For support, email your-email@example.com or create an issue in this repository.

---

**Made with 💚 for a greener planet** 🌍
