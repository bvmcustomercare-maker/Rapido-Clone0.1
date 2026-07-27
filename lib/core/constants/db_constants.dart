/// Constants relating to database and persistence layer (teck-stack.md §4)
abstract class DbConstants {
  static const String settingsBox = 'settings';
  static const String sessionsBox = 'sessions';
  static const String ridesBox = 'rides';
  static const String locationsBox = 'locations';
  static const String placesBox = 'places';

  static const String keyLoggedInUserId = 'loggedInUserId';
  static const String keyDarkMode = 'darkMode';
  static const String keyOnboardingDone = 'onboardingDone';
  static const String keyNotificationsOn = 'notificationsOn';
}
