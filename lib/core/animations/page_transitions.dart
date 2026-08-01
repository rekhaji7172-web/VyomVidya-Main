import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'app_animations.dart';

/// Reusable [CustomTransitionPage] builders for GoRouter routes, so every
/// screen transition in the app feels consistent ("premium transitions",
/// per the animation philosophy) without repeating transition code per
/// route.
abstract final class AppPageTransitions {
  /// Standard fade + subtle upward slide — the default for most pushes.
  static CustomTransitionPage<T> fadeThrough<T>({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: AppDurations.normal,
      reverseTransitionDuration: AppDurations.fast,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: AppCurves.standard);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Horizontal slide — used for stack-style drill-in navigation
  /// (e.g. list → detail).
  static CustomTransitionPage<T> slideHorizontal<T>({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: AppDurations.normal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: AppCurves.standard);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    );
  }

  /// Bottom-sheet-style vertical reveal — used for modals pushed as routes.
  static CustomTransitionPage<T> slideUp<T>({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: AppDurations.medium,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: AppCurves.springInOut);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.15),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  const AppPageTransitions._();
}
