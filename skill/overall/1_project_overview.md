# Project Overview: Manga Reading Mobile Application

## 1. General Information

- **Target**: Personal student project (Exercise/Assignment).
- **Backend Stack**: Dart
- **Frontend Stack**: Flutter (Dart) for Mobile App.
- **Architectural Style**: RESTful API /Monolith.

## 2. Main Actors & Roles

- `GUEST`: Unauthenticated user. Can only view the landing/login screen and register.
- `FREE_USER`: Authenticated user. Can read free manga, search, bookmark, and purchase upgrades.
- `PREMIUM_USER`: Authenticated user. Has all `FREE_USER` rights + permission to read Premium/Locked manga chapters.
- `ADMIN`: Management role. Can upload/update manga, manage users, and view transaction logs via API/Web Admin.

## 3. Core Functional Requirements

1. **Authentication**: Sign up, Sign in, JWT-based Authorization.
2. **Content Delivery**: Separation of Free and Premium chapters.
3. **Payment Integration**: Upgrade account via MoMo or VNPay Sandbox.
4. **Content Management**: Admin flow to create Manga metadata and upload Chapter images.
5. **User Preferences**: Add to favorites, tracking reading progress, filtering genres.
