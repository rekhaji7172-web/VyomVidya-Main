/// Central registry of analytics event names and parameter keys.
///
/// Rule: features must NEVER inline raw event-name strings when calling
/// [AnalyticsService]. Add the event here first, then reference the
/// constant. This keeps event names consistent and greppable, and makes it
/// trivial to audit everything the app tracks.
abstract final class AnalyticsEvents {
  // ---- App lifecycle ----
  static const String appOpened = 'app_opened';
  static const String screenViewed = 'screen_viewed';

  // ---- Onboarding ----
  static const String onboardingStarted = 'onboarding_started';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String onboardingGoalSelected = 'onboarding_goal_selected';

  // ---- Study loop (wired up as those features land) ----
  static const String pomodoroStarted = 'pomodoro_started';
  static const String pomodoroCompleted = 'pomodoro_completed';
  static const String taskCreated = 'task_created';
  static const String taskCompleted = 'task_completed';

  // ---- AI ----
  static const String aiPromptSent = 'ai_prompt_sent';

  // ---- Param keys ----
  static const String paramScreenName = 'screen_name';
  static const String paramSubject = 'subject';
  static const String paramDurationSeconds = 'duration_seconds';

  const AnalyticsEvents._();
}
