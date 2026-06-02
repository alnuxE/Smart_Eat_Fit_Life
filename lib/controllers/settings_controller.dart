class SettingsController {
  // Valores simulados de configuración inicial
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  bool syncHealthData = true;

  // Métodos para cambiar estado (En una app real aquí guardarías en SharedPreferences o base de datos)
  void toggleNotifications(bool value) {
    notificationsEnabled = value;
  }

  void toggleDarkMode(bool value) {
    darkModeEnabled = value;
  }

  void toggleSyncHealthData(bool value) {
    syncHealthData = value;
  }
}
