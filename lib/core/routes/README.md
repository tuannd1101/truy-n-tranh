# Routes Module

This module contains the routing configuration for the Flutter manga reading application.

## Files

### route_names.dart

Contains all route name constants used throughout the application. This ensures type-safe navigation and prevents typos in route names.

#### Route Categories

1. **Splash & Initial Routes**
   - `/splash` - Initial loading screen
   - `/` - Entry point of the app

2. **Authentication Routes**
   - `/login` - Login screen
   - `/register` - Register screen

3. **Main Navigation Routes** (Bottom Navigation Bar)
   - `/home` - Home screen with featured manga
   - `/search` - Search and filter manga
   - `/library` - User's reading list and favorites
   - `/profile` - User profile and settings

4. **Content Detail Routes**
   - `/manga/detail` - Manga detail screen (requires mangaId parameter)
   - `/manga/reading` - Reading screen (requires mangaId and chapterId parameters)

5. **Profile Sub-Routes**
   - `/history` - Reading history screen
   - `/favorites` - Favorites screen
   - `/settings` - Settings screen

6. **Subscription & Payment Routes**
   - `/subscription` - Subscription plans screen
   - `/payment` - Payment processing screen (requires planId parameter)

#### Helper Methods

The `RouteNames` class provides helper methods for constructing routes with parameters:

- `mangaDetailWithId(String mangaId)` - Returns manga detail route with ID
- `readingWithParams(String mangaId, String chapterId)` - Returns reading route with parameters
- `paymentWithPlanId(String planId)` - Returns payment route with plan ID

#### Route Lists

- `allRoutes` - List of all available routes
- `protectedRoutes` - Routes that require authentication
- `authOnlyRoutes` - Routes that redirect to home if user is authenticated
- `guestAccessibleRoutes` - Routes accessible to guest users

## Usage

```dart
import 'package:your_app/core/routes/route_names.dart';

// Navigate to a screen
Navigator.pushNamed(context, RouteNames.home);

// Navigate with parameters
Navigator.pushNamed(
  context,
  RouteNames.mangaDetail,
  arguments: {'mangaId': '123'},
);

// Or use helper methods
Navigator.pushNamed(
  context,
  RouteNames.mangaDetailWithId('123'),
);
```

## Naming Convention

All route names follow these conventions:

- Use lowercase letters
- Use forward slashes for hierarchical routes
- Use descriptive names that match screen names
- Keep names concise but clear

## References

- Requirements 13.1 - Navigation and Routing System
- Design Document - Navigation Flow section
