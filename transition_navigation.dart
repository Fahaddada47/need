import 'package:flutter/material.dart';

enum PageTransitionType {
  fade,
  slide,
  scale,
  rotation,
  slideFromBottom,
  slideFromTop,
  slideFromLeft,
  slideFromRight,
}

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Enhanced push method with transition support
  static void push(
    BuildContext context, {
    required Widget page,
    Object? arguments,
    Route<dynamic>? route,
    PageTransitionType transitionType = PageTransitionType.slide,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    Navigator.of(context).push(
      route ??
          _createTransitionRoute(
            page: page,
            arguments: arguments,
            transitionType: transitionType,
            duration: duration,
            curve: curve,
          ),
    );
  }

  static void pushReplacement(
    BuildContext context, {
    required Widget page,
    Object? arguments,
    Route<dynamic>? route,
    PageTransitionType transitionType = PageTransitionType.slide,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    Navigator.of(context).pushReplacement(
      route ??
          _createTransitionRoute(
            page: page,
            arguments: arguments,
            transitionType: transitionType,
            duration: duration,
            curve: curve,
          ),
    );
  }

  static void pushAndRemoveUntil(
    BuildContext context, {
    required Widget page,
    Object? arguments,
    Route<dynamic>? route,
    PageTransitionType transitionType = PageTransitionType.slide,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    Navigator.of(context).pushAndRemoveUntil(
      route ??
          _createTransitionRoute(
            page: page,
            arguments: arguments,
            transitionType: transitionType,
            duration: duration,
            curve: curve,
          ),
      (route) => false,
    );
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void popUntil(BuildContext context) {
    Navigator.of(context).popUntil((route) => false);
  }

  static T? getArguments<T>(BuildContext context) {
    return ModalRoute.of(context)?.settings.arguments as T?;
  }

  // Private method to create custom transition routes
  static PageRoute _createTransitionRoute({
    required Widget page,
    Object? arguments,
    required PageTransitionType transitionType,
    required Duration duration,
    required Curve curve,
  }) {
    switch (transitionType) {
      case PageTransitionType.fade:
        return FadeTransitionRoute(
          page: page,
          arguments: arguments,
          duration: duration,
          curve: curve,
        );
      case PageTransitionType.scale:
        return ScaleTransitionRoute(
          page: page,
          arguments: arguments,
          duration: duration,
          curve: curve,
        );
      case PageTransitionType.rotation:
        return RotationTransitionRoute(
          page: page,
          arguments: arguments,
          duration: duration,
          curve: curve,
        );
      case PageTransitionType.slideFromBottom:
        return SlideTransitionRoute(
          page: page,
          arguments: arguments,
          duration: duration,
          curve: curve,
          direction: SlideDirection.fromBottom,
        );
      case PageTransitionType.slideFromTop:
        return SlideTransitionRoute(
          page: page,
          arguments: arguments,
          duration: duration,
          curve: curve,
          direction: SlideDirection.fromTop,
        );
      case PageTransitionType.slideFromLeft:
        return SlideTransitionRoute(
          page: page,
          arguments: arguments,
          duration: duration,
          curve: curve,
          direction: SlideDirection.fromLeft,
        );
      case PageTransitionType.slideFromRight:
        return SlideTransitionRoute(
          page: page,
          arguments: arguments,
          duration: duration,
          curve: curve,
          direction: SlideDirection.fromRight,
        );
      default:
        return SlideTransitionRoute(
          page: page,
          arguments: arguments,
          duration: duration,
          curve: curve,
          direction: SlideDirection.fromRight,
        );
    }
  }
}

// Custom Fade Transition Route
class FadeTransitionRoute extends PageRouteBuilder {
  final Widget page;
  final Object? arguments;
  final Duration duration;
  final Curve curve;

  FadeTransitionRoute({
    required this.page,
    this.arguments,
    required this.duration,
    required this.curve,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         settings: RouteSettings(arguments: arguments),
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: CurvedAnimation(parent: animation, curve: curve),
             child: child,
           );
         },
       );
}

// Custom Scale Transition Route
class ScaleTransitionRoute extends PageRouteBuilder {
  final Widget page;
  final Object? arguments;
  final Duration duration;
  final Curve curve;

  ScaleTransitionRoute({
    required this.page,
    this.arguments,
    required this.duration,
    required this.curve,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         settings: RouteSettings(arguments: arguments),
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return ScaleTransition(
             scale: CurvedAnimation(parent: animation, curve: curve),
             child: child,
           );
         },
       );
}

// Custom Rotation Transition Route
class RotationTransitionRoute extends PageRouteBuilder {
  final Widget page;
  final Object? arguments;
  final Duration duration;
  final Curve curve;

  RotationTransitionRoute({
    required this.page,
    this.arguments,
    required this.duration,
    required this.curve,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         settings: RouteSettings(arguments: arguments),
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return RotationTransition(
             turns: CurvedAnimation(parent: animation, curve: curve),
             child: child,
           );
         },
       );
}

// Slide Direction Enum
enum SlideDirection { fromLeft, fromRight, fromTop, fromBottom }

// Custom Slide Transition Route
class SlideTransitionRoute extends PageRouteBuilder {
  final Widget page;
  final Object? arguments;
  final Duration duration;
  final Curve curve;
  final SlideDirection direction;

  SlideTransitionRoute({
    required this.page,
    this.arguments,
    required this.duration,
    required this.curve,
    required this.direction,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         settings: RouteSettings(arguments: arguments),
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           Offset begin;
           const Offset end = Offset.zero;

           switch (direction) {
             case SlideDirection.fromLeft:
               begin = const Offset(-1.0, 0.0);
               break;
             case SlideDirection.fromRight:
               begin = const Offset(1.0, 0.0);
               break;
             case SlideDirection.fromTop:
               begin = const Offset(0.0, -1.0);
               break;
             case SlideDirection.fromBottom:
               begin = const Offset(0.0, 1.0);
               break;
           }

           var tween = Tween(begin: begin, end: end);
           var offsetAnimation = animation.drive(
             tween.chain(CurveTween(curve: curve)),
           );

           return SlideTransition(position: offsetAnimation, child: child);
         },
       );
}

// Combined Transition Route (Multiple effects)
class CombinedTransitionRoute extends PageRouteBuilder {
  final Widget page;
  final Object? arguments;
  final Duration duration;
  final Curve curve;

  CombinedTransitionRoute({
    required this.page,
    this.arguments,
    required this.duration,
    required this.curve,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         settings: RouteSettings(arguments: arguments),
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return SlideTransition(
             position: Tween<Offset>(
               begin: const Offset(1.0, 0.0),
               end: Offset.zero,
             ).animate(CurvedAnimation(parent: animation, curve: curve)),
             child: FadeTransition(
               opacity: CurvedAnimation(parent: animation, curve: curve),
               child: child,
             ),
           );
         },
       );
}
