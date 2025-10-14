# Flutter Clean Architecture Boilerplate

## 🚀 Introduction

This Flutter Clean Architecture Boilerplate is designed with **Clean Architecture** principles and **responsive design** in mind, providing a scalable and maintainable foundation for cross-platform Flutter applications. The architecture follows **SOLID principles** to ensure code quality, testability, and flexibility across mobile, tablet, and desktop devices.

### 🎯 Key Features:

- **🏗️ Clean Architecture Layers**: Separation of concerns through distinct layers (Domain, Data, Presentation) that promote independence and testability
- **📱 Responsive Design System**: Comprehensive responsive utilities and widgets that adapt to any screen size
- **🎨 Adaptive Theme System**: Typography and spacing that scale based on device type
- **🧩 SOLID Principles**: Implementation follows Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, and Dependency Inversion principles
- **💉 Dependency Injection**: Uses GetIt for efficient dependency management and loose coupling
- **🔧 Modular Design**: Easily extensible architecture that allows adding new features without affecting existing code
- **📐 Scalable Structure**: Organized codebase that grows with your application needs
- **🛠️ Custom Extensions**: Built-in extension points for customizing behavior and adding domain-specific functionality
- **🌐 Multi-Platform Support**: Ready for Android, iOS, Web, and Desktop deployment

### 📱 Responsive Design Features:

- **Breakpoint System**: Mobile (< 600px), Tablet (600-1024px), Desktop (1024-1440px), Large Desktop (1440px+)
- **Adaptive Navigation**: Bottom navigation on mobile, navigation rail on tablet/desktop
- **Responsive Widgets**: Pre-built components that adapt to screen size
- **Typography Scaling**: Text that scales appropriately across devices
- **Flexible Layouts**: Grid systems and layout patterns that adapt to screen real estate

The boilerplate provides a robust starting point that can be easily extended and customized for various project requirements while maintaining code quality and architectural integrity across all platforms.

### 📚 References:
- [Flutter Documentation](https://flutter.dev/docs)
- [Clean Architecture Principles](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [SOLID Principles](https://www.digitalocean.com/community/conceptual-articles/s-o-l-i-d-the-first-five-principles-of-object-oriented-design)

## 🛠️ Requirements

- **Flutter SDK**: 3.35.1 or higher
- **Dart**: 3.9.0 or higher
- **Android SDK**: For Android development
- **Java JDK**: 17 or higher (for Android builds)

### Global Dependencies:
```bash
dart pub global activate flutter_gen 5.11.0
```

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter_clean_architecture_boilerplate
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   bash scripts/gen_all.sh
   # or individually:
   # bash scripts/gen_code.sh
   # bash scripts/gen_asset.sh
   # bash scripts/gen_locales.sh
   ```

4. **Run the application**
   ```bash
   # Development
   flutter run -t lib/main_dev.dart
   
   # Staging
   flutter run -t lib/main_staging.dart
   
   # Production
   flutter run -t lib/main_prod.dart
   ```

## 📱 Platform Support

### Android
- ✅ Full Android support with proper package structure
- ✅ Material Design components
- ✅ Responsive layouts for phones and tablets

### iOS (Ready for setup)
- 🔄 iOS platform files can be generated when needed
- 🔄 Cupertino design components

### Web & Desktop
- 🔄 Can be easily enabled through Flutter's platform support

## 🎯 Running on Different Platforms

### Android
```bash
flutter run -d android
# or for release
flutter build apk --release
```

### Web (when enabled)
```bash
flutter run -d web
```

### Desktop (when enabled)
```bash
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

## 📁 Project Structure

```
flutter_clean_architecture_boilerplate/
├── android/                              # Android platform files
│   ├── app/
│   │   ├── build.gradle.kts              # Android app configuration
│   │   └── src/main/
│   │       ├── AndroidManifest.xml       # Android manifest
│   │       └── kotlin/.../MainActivity.kt # Main Android activity
│   └── build.gradle.kts                  # Android project configuration
├── assets/                               # Static assets
│   ├── icons/                           # App icons and SVG files
│   └── translations/                    # Localization files
│       └── en.json                      # English translations
├── lib/
│   ├── core/                            # Core utilities and configurations
│   │   ├── constants/                   # App constants
│   │   │   ├── http_code.dart          # HTTP status codes
│   │   │   ├── network.dart            # Network constants
│   │   │   └── index.dart              # Export file
│   │   ├── di/                         # Dependency injection
│   │   │   ├── di.dart                 # GetIt configuration
│   │   │   └── di.config.dart          # Generated DI config
│   │   ├── env/                        # Environment configuration
│   │   │   ├── env.dart                # Environment variables
│   │   │   └── env.freezed.dart        # Generated environment code
│   │   ├── exceptions/                 # Exception handling
│   │   │   ├── base_exception.dart     # Base exception class
│   │   │   ├── base_exception_handler.dart # Exception handler
│   │   │   └── errors/                 # Error models
│   │   ├── extensions/                 # Dart extensions
│   │   │   ├── responsive_extension.dart # Responsive utilities
│   │   │   ├── string_extension.dart   # String utilities
│   │   │   ├── system_theme.dart       # Theme extensions
│   │   │   └── index.dart              # Export file
│   │   └── utils/                      # Utility functions
│   │       ├── responsive_utils.dart   # Responsive design utilities
│   │       ├── datetime_util.dart      # Date/time utilities
│   │       └── index.dart              # Export file
│   ├── data/                           # Data layer (Clean Architecture)
│   │   ├── models/                     # Data models
│   │   │   └── user/                   # User-related models
│   │   ├── network/                    # Network clients
│   │   │   ├── rest_client.dart        # REST API client
│   │   │   └── interceptor/            # HTTP interceptors
│   │   ├── repositories/               # Repository implementations
│   │   │   └── user/                   # User repository
│   │   └── sources/                    # Data sources
│   │       ├── local/                  # Local data sources
│   │       └── remote/                 # Remote data sources
│   ├── domain/                         # Domain layer (Clean Architecture)
│   │   ├── entities/                   # Business entities
│   │   │   └── user/                   # User entities
│   │   ├── enums/                      # Domain enums
│   │   ├── repositories/               # Repository interfaces
│   │   └── usecase/                    # Business use cases
│   │       └── user/                   # User-related use cases
│   └── presentation/                   # Presentation layer
│       ├── app.dart                    # Main app widget
│       ├── generated/                  # Generated files
│       │   ├── assets.gen.dart         # Generated asset references
│       │   └── locales/                # Generated localization
│       ├── home/                       # Home feature
│       │   ├── home_screen.dart        # Main home screen
│       │   └── responsive_navigation_demo.dart # Navigation demo
│       ├── routes/                     # App routing
│       │   ├── routes.dart             # Route definitions
│       │   └── route_name.dart         # Route constants
│       ├── theme/                      # App theming
│       │   ├── color_theme.dart        # Color definitions
│       │   ├── text_theme.dart         # Typography
│       │   ├── system_theme.dart       # Theme system
│       │   ├── system_theme_data.dart  # Theme data
│       │   ├── responsive_text_theme.dart # Responsive typography
│       │   └── responsive_spacing.dart # Responsive spacing
│       └── widgets/                    # Reusable widgets
│           └── responsive/             # Responsive widget library
│               ├── responsive_widgets.dart # Core responsive widgets
│               ├── responsive_layout.dart  # Layout patterns
│               └── index.dart          # Export file
├── scripts/                            # Build and generation scripts
│   ├── gen_all.sh                     # Generate all code
│   ├── gen_asset.sh                   # Generate assets
│   ├── gen_code.sh                    # Generate Dart code
│   └── gen_locales.sh                 # Generate localizations
├── test/                              # Unit and widget tests
├── main_dev.dart                      # Development entry point
├── main_staging.dart                  # Staging entry point
├── main_prod.dart                     # Production entry point
├── pubspec.yaml                       # Project dependencies
├── analysis_options.yaml             # Dart analysis configuration
├── build.yaml                         # Build configuration
└── RESPONSIVE_DESIGN.md              # Responsive design documentation
```

## 🎨 Responsive Design System

This boilerplate includes a comprehensive responsive design system that automatically adapts to different screen sizes and devices.

### 📐 Breakpoints
- **Mobile**: < 600px (phones)
- **Tablet**: 600px - 1024px (tablets)
- **Desktop**: 1024px - 1440px (small desktops)
- **Large Desktop**: 1440px+ (large screens)

### 🧩 Responsive Widgets

#### ResponsiveBuilder
```dart
ResponsiveBuilder(
  mobile: MobileWidget(),
  tablet: TabletWidget(),
  desktop: DesktopWidget(),
)
```

#### ResponsiveGrid
```dart
ResponsiveGrid(
  mobileColumns: 1,
  tabletColumns: 2,
  desktopColumns: 3,
  children: [...],
)
```

#### ResponsiveScaffold
```dart
ResponsiveScaffold(
  body: content,
  navigationItems: [...],
  // Automatically switches between bottom nav, rail, and extended rail
)
```

### 📱 Navigation Patterns
- **Mobile**: Bottom Navigation Bar
- **Tablet**: Navigation Rail
- **Desktop**: Extended Navigation Rail

### 🎯 Usage Examples

#### Responsive Values
```dart
final value = context.responsiveValue(
  mobile: 16.0,
  tablet: 20.0,
  desktop: 24.0,
);
```

#### Device Detection
```dart
if (context.isMobile) {
  // Mobile-specific UI
} else if (context.isTablet) {
  // Tablet-specific UI
} else {
  // Desktop UI
}
```

#### Responsive Spacing
```dart
Column(
  children: [
    Text('Hello'),
    context.verticalSpaceMD, // Adaptive spacing
    Text('World'),
  ],
)
```

#### Responsive Typography
```dart
Text(
  'Responsive Text',
  style: context.responsiveTextTheme.responsiveHeadline,
)
```

For detailed documentation, see [RESPONSIVE_DESIGN.md](RESPONSIVE_DESIGN.md).

## 🏗️ Clean Architecture Layers

### 🎯 Domain Layer (`lib/domain/`)
- **Entities**: Core business objects
- **Use Cases**: Business logic and rules
- **Repository Interfaces**: Abstract data access contracts

### 📊 Data Layer (`lib/data/`)
- **Repository Implementations**: Concrete data access
- **Models**: Data transfer objects
- **Data Sources**: Local and remote data providers
- **Network**: API clients and interceptors

### 🎨 Presentation Layer (`lib/presentation/`)
- **Screens**: UI components and pages
- **Widgets**: Reusable UI elements
- **Theme**: Design system and styling
- **Routes**: Navigation and routing

### ⚙️ Core Layer (`lib/core/`)
- **Utilities**: Helper functions and extensions
- **Constants**: App-wide constants
- **Dependency Injection**: Service location
- **Exceptions**: Error handling

## 📖 Usage Guide

### Adding a New Feature

1. **Create domain entities** in `lib/domain/entities/`
2. **Define repository interface** in `lib/domain/repositories/`
3. **Implement use cases** in `lib/domain/usecase/`
4. **Create data models** in `lib/data/models/`
5. **Implement repository** in `lib/data/repositories/`
6. **Build UI screens** in `lib/presentation/`
7. **Add responsive widgets** using the responsive system

### Using Responsive Design

1. **Use responsive extensions**:
   ```dart
   context.isMobile
   context.responsivePadding
   context.responsiveValue(mobile: ..., tablet: ..., desktop: ...)
   ```

2. **Build adaptive layouts**:
   ```dart
   ResponsiveContainer(
     child: ResponsiveGrid(
       mobileColumns: 1,
       tabletColumns: 2,
       desktopColumns: 3,
       children: widgets,
     ),
   )
   ```

3. **Implement responsive navigation**:
   ```dart
   ResponsiveScaffold(
     navigationItems: navItems,
     body: content,
   )
   ```

### Environment Configuration

The app supports multiple environments:

- **Development** (`main_dev.dart`): For development with debug features
- **Staging** (`main_staging.dart`): For testing with production-like settings
- **Production** (`main_prod.dart`): For production deployment

### Code Generation

Use the provided scripts for code generation:

```bash
# Generate all
bash scripts/gen_all.sh

# Individual generation
bash scripts/gen_code.sh      # Generate Dart code (Freezed, JSON, etc.)
bash scripts/gen_asset.sh     # Generate asset references
bash scripts/gen_locales.sh   # Generate localization files
```

## 🧪 Testing

The project structure supports comprehensive testing:

- **Unit Tests**: Test business logic in isolation
- **Widget Tests**: Test UI components
- **Integration Tests**: Test complete user flows
- **Responsive Tests**: Test layouts across screen sizes

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## 🎯 Best Practices

### Responsive Design
- Always use responsive utilities instead of hardcoded values
- Test on multiple screen sizes and orientations
- Use progressive disclosure (show more info on larger screens)
- Maintain consistent touch targets across devices

### Clean Architecture
- Keep domain layer independent of external frameworks
- Use dependency injection for loose coupling
- Follow the dependency rule (dependencies point inward)
- Separate business logic from UI logic

### Code Organization
- Use feature-based folder structure
- Export commonly used classes through index files
- Follow consistent naming conventions
- Document complex business logic

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Follow the existing code structure** and responsive design patterns
4. **Add tests** for new features
5. **Ensure responsive design** works across all breakpoints
6. **Update documentation** as needed
7. **Commit changes** (`git commit -m 'Add amazing feature'`)
8. **Push to branch** (`git push origin feature/amazing-feature`)
9. **Open a Pull Request**

### Development Guidelines
- Follow Flutter and Dart best practices
- Use the existing responsive design system
- Maintain clean architecture principles
- Add appropriate tests for new features
- Update documentation for new features

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Clean Architecture principles by Robert C. Martin
- The Flutter community for best practices and inspiration

---

**Happy Coding! 🚀**

For detailed responsive design documentation, see [RESPONSIVE_DESIGN.md](RESPONSIVE_DESIGN.md).
