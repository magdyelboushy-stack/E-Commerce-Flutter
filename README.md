# E-Commerce Flutter

A modern Flutter e-commerce application built with Firebase, GetX, and a clean feature-based structure.

This project includes the main shopping flow for a mobile store experience: onboarding, authentication, browsing products, cart management, checkout, wishlist, profile settings, and order-related screens.

## Overview

The app is designed as a scalable Flutter storefront with Firebase-powered authentication and backend services. It focuses on a polished UI, modular organization, and a complete user journey from sign-in to checkout.

## Features

- Email/password authentication
- Google sign-in
- Onboarding flow
- Product browsing and featured store sections
- Product details and reviews
- Wishlist / favorites
- Shopping cart
- Checkout flow
- Profile and account settings
- Address management
- Firebase integration for auth, database, and storage
- Local persistence with `get_storage`

## Tech Stack

- Flutter
- Dart
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- GetX
- Get Storage
- Google Sign-In

## Project Structure

```text
lib/
|- data/
|- features/
|  |- authentication/
|  |- personalization/
|  |- shop/
|- routes/
|- utils/
|- app.dart
|- main.dart
```

## Main Screens

- Onboarding
- Login
- Signup
- Forgot Password
- Home
- Store
- Product Details
- Product Reviews
- Cart
- Checkout
- Wishlist
- Orders
- Profile
- Settings
- Address Management

## Packages Used

Some of the main packages used in this project:

- `get`
- `get_storage`
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `firebase_storage`
- `google_sign_in`
- `connectivity_plus`
- `cached_network_image`
- `image_picker`
- `carousel_slider`
- `flutter_rating_bar`
- `lottie`
- `shimmer`

## Getting Started

### Prerequisites

Make sure you have installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Android Studio or VS Code
- Android SDK
- A running emulator or physical device
- A Firebase project configured for Flutter

### Setup

1. Clone the repository:

```bash
git clone https://github.com/magdyelboushy-stack/E-Commerce-Flutter.git
cd E-Commerce-Flutter
```

2. Install dependencies:

```bash
flutter pub get
```

3. Configure Firebase:

- Add your Firebase configuration files.
- Ensure `lib/firebase_options.dart` is generated and matches your Firebase project.
- For Android, verify `android/app/google-services.json` exists.

4. Run the app:

```bash
flutter run
```

## Build APK

```bash
flutter build apk --debug
```

## Notes

- The project uses Firebase services, so the app will not run correctly without valid Firebase configuration.
- Android builds may require a stable network connection the first time Gradle resolves dependencies.

## Future Improvements

- Admin dashboard integration
- Product search and filtering improvements
- Payment gateway integration
- Better state separation for larger scale growth
- Production-ready error handling and analytics

## Author

Magdy Elboushy

- GitHub: [magdyelboushy-stack](https://github.com/magdyelboushy-stack)

## License

This project is for learning, portfolio, and development use unless a separate license is added later.
