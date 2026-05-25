import 'package:flutter/material.dart';

/// Utility class for navigation operations
/// Provides wrapper functions for common navigation patterns with error handling
class NavigationHelper {
  // ==================== Basic Navigation ====================
  
  /// Navigates to a new screen
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [screen]: Widget to navigate to
  /// - [fullscreenDialog]: Whether to show as fullscreen dialog (default: false)
  /// 
  /// Returns: Future that completes with the result when the screen is popped
  static Future<T?> push<T>(
    BuildContext context,
    Widget screen, {
    bool fullscreenDialog = false,
  }) async {
    try {
      return await Navigator.push<T>(
        context,
        MaterialPageRoute(
          builder: (context) => screen,
          fullscreenDialog: fullscreenDialog,
        ),
      );
    } catch (e) {
      debugPrint('Navigation error: $e');
      return null;
    }
  }
  
  /// Navigates to a named route
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [routeName]: Name of the route
  /// - [arguments]: Optional arguments to pass to the route
  /// 
  /// Returns: Future that completes with the result when the screen is popped
  static Future<T?> pushNamed<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) async {
    try {
      return await Navigator.pushNamed<T>(
        context,
        routeName,
        arguments: arguments,
      );
    } catch (e) {
      debugPrint('Navigation error: $e');
      return null;
    }
  }
  
  /// Replaces the current screen with a new one
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [screen]: Widget to navigate to
  /// 
  /// Returns: Future that completes with the result when the screen is popped
  static Future<T?> pushReplacement<T, TO>(
    BuildContext context,
    Widget screen, {
    TO? result,
  }) async {
    try {
      return await Navigator.pushReplacement<T, TO>(
        context,
        MaterialPageRoute(builder: (context) => screen),
        result: result,
      );
    } catch (e) {
      debugPrint('Navigation error: $e');
      return null;
    }
  }
  
  /// Replaces the current screen with a named route
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [routeName]: Name of the route
  /// - [arguments]: Optional arguments to pass to the route
  /// - [result]: Optional result to return to the previous screen
  static Future<T?> pushReplacementNamed<T, TO>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    TO? result,
  }) async {
    try {
      return await Navigator.pushReplacementNamed<T, TO>(
        context,
        routeName,
        arguments: arguments,
        result: result,
      );
    } catch (e) {
      debugPrint('Navigation error: $e');
      return null;
    }
  }
  
  /// Removes all previous routes and navigates to a new screen
  /// Useful for logout or completing a flow
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [screen]: Widget to navigate to
  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    Widget screen, {
    bool Function(Route<dynamic>)? predicate,
  }) async {
    try {
      return await Navigator.pushAndRemoveUntil<T>(
        context,
        MaterialPageRoute(builder: (context) => screen),
        predicate ?? (route) => false,
      );
    } catch (e) {
      debugPrint('Navigation error: $e');
      return null;
    }
  }
  
  /// Removes all previous routes and navigates to a named route
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [routeName]: Name of the route
  /// - [arguments]: Optional arguments to pass to the route
  /// - [predicate]: Optional predicate to determine which routes to keep
  static Future<T?> pushNamedAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) async {
    try {
      return await Navigator.pushNamedAndRemoveUntil<T>(
        context,
        routeName,
        predicate ?? (route) => false,
        arguments: arguments,
      );
    } catch (e) {
      debugPrint('Navigation error: $e');
      return null;
    }
  }
  
  // ==================== Pop Operations ====================
  
  /// Pops the current screen
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [result]: Optional result to return to the previous screen
  static void pop<T>(BuildContext context, [T? result]) {
    try {
      if (Navigator.canPop(context)) {
        Navigator.pop<T>(context, result);
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
    }
  }
  
  /// Pops until a specific route
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [routeName]: Name of the route to pop until
  static void popUntil(BuildContext context, String routeName) {
    try {
      Navigator.popUntil(context, ModalRoute.withName(routeName));
    } catch (e) {
      debugPrint('Navigation error: $e');
    }
  }
  
  /// Pops until the first route (root)
  /// 
  /// Parameters:
  /// - [context]: Build context
  static void popToRoot(BuildContext context) {
    try {
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      debugPrint('Navigation error: $e');
    }
  }
  
  /// Checks if the navigator can pop
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// 
  /// Returns: true if there are routes to pop, false otherwise
  static bool canPop(BuildContext context) {
    try {
      return Navigator.canPop(context);
    } catch (e) {
      debugPrint('Navigation error: $e');
      return false;
    }
  }
  
  /// Pops the current screen if possible, otherwise does nothing
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [result]: Optional result to return to the previous screen
  static void maybePop<T>(BuildContext context, [T? result]) {
    try {
      if (Navigator.canPop(context)) {
        Navigator.pop<T>(context, result);
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
    }
  }
  
  // ==================== Dialog Operations ====================
  
  /// Shows a dialog
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [builder]: Builder function for the dialog
  /// - [barrierDismissible]: Whether tapping outside dismisses the dialog (default: true)
  /// 
  /// Returns: Future that completes with the result when the dialog is dismissed
  static Future<T?> showDialogHelper<T>(
    BuildContext context, {
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = true,
  }) async {
    try {
      return await showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: builder,
      );
    } catch (e) {
      debugPrint('Dialog error: $e');
      return null;
    }
  }
  
  /// Shows a confirmation dialog
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [title]: Dialog title
  /// - [message]: Dialog message
  /// - [confirmText]: Text for confirm button (default: 'Confirm')
  /// - [cancelText]: Text for cancel button (default: 'Cancel')
  /// 
  /// Returns: Future<bool> - true if confirmed, false if cancelled
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(confirmText),
            ),
          ],
        ),
      );
      return result ?? false;
    } catch (e) {
      debugPrint('Dialog error: $e');
      return false;
    }
  }
  
  /// Shows an alert dialog
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [title]: Dialog title
  /// - [message]: Dialog message
  /// - [buttonText]: Text for the button (default: 'OK')
  static Future<void> showAlertDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) async {
    try {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(buttonText),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('Dialog error: $e');
    }
  }
  
  // ==================== Bottom Sheet Operations ====================
  
  /// Shows a modal bottom sheet
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [builder]: Builder function for the bottom sheet
  /// - [isScrollControlled]: Whether the bottom sheet can be scrolled (default: false)
  /// - [isDismissible]: Whether tapping outside dismisses the sheet (default: true)
  /// 
  /// Returns: Future that completes with the result when the sheet is dismissed
  static Future<T?> showBottomSheetHelper<T>(
    BuildContext context, {
    required Widget Function(BuildContext) builder,
    bool isScrollControlled = false,
    bool isDismissible = true,
  }) async {
    try {
      return await showModalBottomSheet<T>(
        context: context,
        isScrollControlled: isScrollControlled,
        isDismissible: isDismissible,
        builder: builder,
      );
    } catch (e) {
      debugPrint('Bottom sheet error: $e');
      return null;
    }
  }
  
  // ==================== Snackbar Operations ====================
  
  /// Shows a snackbar
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [message]: Message to display
  /// - [duration]: Duration to show the snackbar (default: 3 seconds)
  /// - [action]: Optional action button
  static void showSnackbar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          action: action,
        ),
      );
    } catch (e) {
      debugPrint('Snackbar error: $e');
    }
  }
  
  /// Shows a success snackbar
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [message]: Success message to display
  static void showSuccessSnackbar(
    BuildContext context, {
    required String message,
  }) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      debugPrint('Snackbar error: $e');
    }
  }
  
  /// Shows an error snackbar
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [message]: Error message to display
  static void showErrorSnackbar(
    BuildContext context, {
    required String message,
  }) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      debugPrint('Snackbar error: $e');
    }
  }
  
  /// Shows a warning snackbar
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [message]: Warning message to display
  static void showWarningSnackbar(
    BuildContext context, {
    required String message,
  }) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      debugPrint('Snackbar error: $e');
    }
  }
  
  /// Shows an info snackbar
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [message]: Info message to display
  static void showInfoSnackbar(
    BuildContext context, {
    required String message,
  }) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      debugPrint('Snackbar error: $e');
    }
  }
  
  // ==================== Loading Dialog ====================
  
  /// Shows a loading dialog
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [message]: Optional loading message
  static void showLoadingDialog(
    BuildContext context, {
    String? message,
  }) {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(message),
                ],
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Loading dialog error: $e');
    }
  }
  
  /// Hides the loading dialog
  /// 
  /// Parameters:
  /// - [context]: Build context
  static void hideLoadingDialog(BuildContext context) {
    try {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Hide loading dialog error: $e');
    }
  }
  
  // ==================== Route Information ====================
  
  /// Gets the current route name
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// 
  /// Returns: Current route name or null if not available
  static String? getCurrentRouteName(BuildContext context) {
    try {
      final route = ModalRoute.of(context);
      return route?.settings.name;
    } catch (e) {
      debugPrint('Get route name error: $e');
      return null;
    }
  }
  
  /// Gets the route arguments
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// 
  /// Returns: Route arguments or null if not available
  static Object? getRouteArguments(BuildContext context) {
    try {
      final route = ModalRoute.of(context);
      return route?.settings.arguments;
    } catch (e) {
      debugPrint('Get route arguments error: $e');
      return null;
    }
  }
  
  /// Checks if a specific route is in the navigation stack
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [routeName]: Name of the route to check
  /// 
  /// Returns: true if the route is in the stack, false otherwise
  static bool isRouteInStack(BuildContext context, String routeName) {
    try {
      bool found = false;
      Navigator.popUntil(context, (route) {
        if (route.settings.name == routeName) {
          found = true;
        }
        return true;
      });
      return found;
    } catch (e) {
      debugPrint('Check route in stack error: $e');
      return false;
    }
  }
}
