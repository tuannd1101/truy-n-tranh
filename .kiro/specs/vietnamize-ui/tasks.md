# Implementation Plan: Vietnamize UI

## Overview

This implementation plan converts all English UI text in the MangaFlow Flutter application to Vietnamese by creating a centralized constants file and refactoring all screens to use Vietnamese string constants. The approach ensures consistency, maintainability, and proper text rendering while preserving manga-specific terminology.

## Tasks

- [x] 1. Create Vietnamese string constants file
  - Create `lib/core/constants/app_strings_vi.dart` with all Vietnamese string constants
  - Organize constants by logical grouping (authentication, navigation, home, detail, reading, profile, subscription, payment, search, library, admin, common actions, status messages, errors, validation, manga terms, dual labels)
  - Use descriptive constant names following Dart lowerCamelCase convention
  - Include private constructor to prevent instantiation
  - Preserve manga terminology unchanged (Manga, Chapter, Premium, Free, VOL)
  - Format dual labels as "[Japanese] [Vietnamese]" (e.g., "少年 Thiếu Niên")
  - _Requirements: 2.1, 2.2, 2.4, 2.5, 3.1, 3.2, 3.3, 3.4, 8.2, 8.3, 8.4_

- [ ]* 1.1 Write property test for constants file structure
  - **Property 1: Constants file contains all required string keys**
  - **Property 2: All constant names follow Dart naming conventions**
  - **Property 9: All constant names are unique**
  - **Property 10: Constants file exists at specified location**
  - **Validates: Requirements 2.1, 2.2, 2.4, 2.5, 8.4**

- [ ]* 1.2 Write property test for manga terminology preservation
  - **Property 3: Manga terminology is preserved unchanged**
  - **Validates: Requirements 3.1, 3.3**

- [ ]* 1.3 Write property test for dual label format
  - **Property 4: Dual labels maintain correct format**
  - **Validates: Requirements 3.2, 3.4**

- [ ]* 1.4 Write property test for consistent translations
  - **Property 7: Common action terms have consistent translations**
  - **Property 8: Status message terms have consistent translations**
  - **Validates: Requirements 8.2, 8.3**

- [x] 2. Refactor authentication screens
  - [x] 2.1 Refactor login_screen.dart
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update title, labels, hints, buttons, links, and error messages
    - Verify text rendering and overflow handling
    - Test login functionality with Vietnamese text
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 2.3, 5.6, 7.1, 7.2, 7.4, 7.5_
  
  - [x] 2.2 Refactor register_screen.dart
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update title, labels, hints, buttons, links, and validation messages
    - Verify text rendering and overflow handling
    - Test registration functionality with Vietnamese text
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.6, 2.3, 5.7, 7.1, 7.2, 7.4, 7.5_

- [~] 3. Refactor home and search screens
  - [~] 3.1 Refactor home_screen.dart
    - Add import for `app_strings_vi.dart`
    - Replace hardcoded text in search bar, category labels, section headers, and manga cards
    - Update "Tất cả", "NỔI BẬT HÔM NAY", "MỚI CẬP NHẬT", "XEM TẤT CẢ" with constants
    - Preserve "HOT" and "NEW" tags as specified
    - Verify text rendering and overflow handling in manga cards
    - Test navigation and filtering functionality
    - _Requirements: 1.1, 1.5, 2.3, 5.1, 7.1, 7.2, 7.4, 7.5_
  
  - [~] 3.2 Refactor search_screen.dart (if exists)
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update search placeholder, recent searches, popular searches, results labels
    - Verify text rendering and overflow handling
    - Test search functionality with Vietnamese text
    - _Requirements: 1.1, 1.5, 2.3, 5.2, 7.1, 7.2, 7.4, 7.5_

- [~] 4. Refactor manga detail and reading screens
  - [~] 4.1 Refactor manga_detail_screen.dart
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update synopsis, chapters, buttons (read now, add to library, share)
    - Update metadata labels (author, artist, status, genres, rating)
    - Preserve manga terminology and dual labels for genres
    - Verify text rendering and overflow handling
    - Test detail view and navigation functionality
    - _Requirements: 1.1, 1.5, 2.3, 3.1, 3.2, 3.3, 3.4, 5.3, 7.1, 7.2, 7.4, 7.5_
  
  - [~] 4.2 Refactor manga_reading_screen.dart
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update navigation buttons (previous chapter, next chapter, chapter list)
    - Update settings labels (reading mode, vertical scroll, horizontal page)
    - Preserve "Chapter" terminology
    - Verify text rendering and overflow handling
    - Test reading functionality and navigation
    - _Requirements: 1.1, 1.5, 2.3, 3.1, 3.3, 5.4, 7.1, 7.2, 7.4, 7.5_

- [~] 5. Checkpoint - Verify core screens functionality
  - Ensure all tests pass, ask the user if questions arise.

- [~] 6. Refactor profile and library screens
  - [~] 6.1 Refactor profile_screen.dart
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update profile labels, menu items, buttons
    - Update reading history, favorites, subscription status, account settings, logout
    - Verify text rendering and overflow handling
    - Test profile functionality and navigation
    - _Requirements: 1.1, 1.5, 2.3, 5.5, 7.1, 7.2, 7.4, 7.5_
  
  - [~] 6.2 Refactor favorites_screen.dart (if exists)
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update screen title, empty state messages, action buttons
    - Verify text rendering and overflow handling
    - Test favorites functionality
    - _Requirements: 1.1, 1.5, 2.3, 5.5, 7.1, 7.2, 7.4, 7.5_
  
  - [~] 6.3 Refactor reading_history_screen.dart (if exists)
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update screen title, history items, action buttons
    - Verify text rendering and overflow handling
    - Test reading history functionality
    - _Requirements: 1.1, 1.5, 2.3, 5.5, 7.1, 7.2, 7.4, 7.5_
  
  - [~] 6.4 Refactor library_screen.dart
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update library tabs (reading, completed, plan to read, dropped)
    - Update sort options (sort by title, date, rating)
    - Verify text rendering and overflow handling
    - Test library functionality and filtering
    - _Requirements: 1.1, 1.5, 2.3, 5.5, 7.1, 7.2, 7.4, 7.5_

- [~] 7. Refactor subscription and payment screens
  - [~] 7.1 Refactor subscription_screen.dart
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update subscription title, plan labels (monthly, yearly), buttons
    - Update current plan, renewal date, cancel subscription labels
    - Preserve "Premium" terminology
    - Verify text rendering and overflow handling
    - Test subscription display functionality
    - _Requirements: 1.1, 1.5, 2.3, 3.1, 3.3, 5.8, 7.1, 7.2, 7.4, 7.5_
  
  - [~] 7.2 Refactor payment_screen.dart
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update payment title, payment method labels, order summary, total
    - Update payment method options (credit card, MoMo, ZaloPay, bank transfer)
    - Verify text rendering and overflow handling
    - Test payment screen display
    - _Requirements: 1.1, 1.5, 2.3, 5.9, 7.1, 7.2, 7.4, 7.5_
  
  - [~] 7.3 Refactor payment_result_screen.dart
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update success, failed, pending messages
    - Update buttons (return to home, try again), transaction ID label
    - Verify text rendering and overflow handling
    - Test payment result display
    - _Requirements: 1.1, 1.5, 2.3, 5.11, 7.1, 7.2, 7.4, 7.5_

- [~] 8. Refactor admin dashboard screens
  - [~] 8.1 Refactor admin_dashboard_screen.dart
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update dashboard title, navigation items, statistics labels
    - Update manage manga, chapters, users, creators, tags labels
    - Update total counts (total manga, users, chapters), recent activity
    - Preserve "Manga" terminology
    - Verify text rendering and overflow handling
    - Test admin dashboard navigation and display
    - _Requirements: 1.1, 1.5, 2.3, 3.1, 3.3, 6.1, 6.4, 6.5, 7.1, 7.3, 7.4, 7.5_
  
  - [~] 8.2 Refactor admin_chapter_screen.dart
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update chapter management title, action buttons (add, edit, delete)
    - Update form labels (chapter number, title, upload pages, publish date, status)
    - Update status options (published, draft)
    - Preserve "Chapter" terminology
    - Verify text rendering and overflow handling
    - Test chapter management functionality
    - _Requirements: 1.1, 1.5, 2.3, 3.1, 3.3, 6.2, 6.4, 6.5, 7.1, 7.3, 7.4, 7.5_
  
  - [~] 8.3 Refactor admin_chapter_detail_screen.dart
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update chapter details title, metadata labels (page count, views, likes, comments)
    - Update action buttons (reorder pages, replace pages)
    - Preserve "Chapter" terminology
    - Verify text rendering and overflow handling
    - Test chapter detail display and actions
    - _Requirements: 1.1, 1.5, 2.3, 3.1, 3.3, 6.3, 6.4, 6.5, 7.1, 7.3, 7.4, 7.5_
  
  - [~] 8.4 Refactor admin tab screens (admin_manga_tab.dart, admin_creator_tab.dart, admin_tag_tab.dart)
    - Add import for `app_strings_vi.dart` to each tab screen
    - Replace all hardcoded English text with Vietnamese constants
    - Update tab titles, table headers, action buttons, form labels
    - Preserve "Manga" terminology in manga tab
    - Verify text rendering and overflow handling
    - Test tab functionality and data display
    - _Requirements: 1.1, 1.5, 2.3, 3.1, 3.3, 6.1, 6.4, 6.5, 7.1, 7.3, 7.4, 7.5_

- [~] 9. Checkpoint - Verify admin screens functionality
  - Ensure all tests pass, ask the user if questions arise.

- [~] 10. Refactor shared widgets
  - [~] 10.1 Refactor main_drawer.dart (if exists)
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update navigation menu items
    - Verify text rendering and overflow handling
    - Test drawer navigation
    - _Requirements: 1.1, 1.5, 2.3, 7.1, 7.4, 7.5_
  
  - [~] 10.2 Refactor main_app_bar.dart (if exists)
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update app bar title and action labels
    - Verify text rendering and overflow handling
    - Test app bar functionality
    - _Requirements: 1.1, 1.5, 2.3, 7.1, 7.4, 7.5_
  
  - [~] 10.3 Refactor other shared widgets (manga_widgets.dart, etc.)
    - Add import for `app_strings_vi.dart` to any widgets with text
    - Replace all hardcoded English text with Vietnamese constants
    - Verify text rendering and overflow handling
    - Test widget functionality across all screens
    - _Requirements: 1.1, 1.5, 2.3, 7.1, 7.4, 7.5_

- [~] 11. Refactor remaining screens
  - [~] 11.1 Refactor settings_screen.dart (if exists)
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update settings labels, options, buttons
    - Verify text rendering and overflow handling
    - Test settings functionality
    - _Requirements: 1.1, 1.5, 2.3, 7.1, 7.2, 7.4, 7.5_
  
  - [~] 11.2 Refactor splash_screen.dart (if exists)
    - Add import for `app_strings_vi.dart`
    - Replace any hardcoded English text with Vietnamese constants
    - Verify text rendering
    - Test splash screen display
    - _Requirements: 1.1, 1.5, 2.3, 7.1, 7.2, 7.4, 7.5_
  
  - [~] 11.3 Refactor task_board_screen.dart (if exists)
    - Add import for `app_strings_vi.dart`
    - Replace all hardcoded English text with Vietnamese constants
    - Update task board labels, status labels, action buttons
    - Verify text rendering and overflow handling
    - Test task board functionality
    - _Requirements: 1.1, 1.5, 2.3, 7.1, 7.2, 7.4, 7.5_

- [ ]* 12. Write property tests for screen refactoring
  - **Property 5: No hardcoded English strings in screen files**
  - **Property 6: All screen files import the constants file**
  - **Validates: Requirements 2.3, 7.1, 7.2, 7.3**

- [ ]* 13. Write integration tests for Vietnamese text display
  - Test each client screen displays Vietnamese text correctly
  - Test each admin screen displays Vietnamese text correctly
  - Test error messages display in Vietnamese
  - Test validation messages display in Vietnamese
  - Test text overflow handling on various screen sizes
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 4.1, 4.2, 4.3, 4.4, 4.5, 5.1-5.11, 6.1-6.5_

- [~] 14. Final verification and cleanup
  - [~] 14.1 Verify no hardcoded English strings remain
    - Search codebase for common English words in string literals
    - Verify all screens use constants from `app_strings_vi.dart`
    - Check for any missed error messages or validation messages
    - _Requirements: 7.1, 7.2, 7.3_
  
  - [~] 14.2 Verify consistent terminology usage
    - Check that common actions use consistent Vietnamese terms
    - Check that status messages use consistent Vietnamese terms
    - Verify manga terminology is preserved correctly
    - Verify dual labels are formatted correctly
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 8.1, 8.2, 8.3, 8.4_
  
  - [~] 14.3 Visual inspection and manual testing
    - Visually inspect all client screens for proper Vietnamese text display
    - Visually inspect all admin screens for proper Vietnamese text display
    - Test text overflow handling on different screen sizes
    - Test all user flows end-to-end with Vietnamese text
    - Verify text readability and layout consistency
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 7.4, 7.5_

- [~] 15. Final checkpoint - Complete verification
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate code structure and consistency
- Integration tests validate UI rendering and functionality
- Manual testing ensures visual quality and user experience
- Preserve existing Manga Brutalism design aesthetic throughout
- Maintain all existing functionality while updating text
- Handle text overflow gracefully with maxLines and overflow properties
