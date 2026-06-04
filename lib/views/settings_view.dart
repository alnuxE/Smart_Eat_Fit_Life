import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';
import '../main.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // Instanciamos el controlador específico de la vista de ajustes
  final SettingsController _controller = SettingsController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuración',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Ajusta tus preferencias y cuenta.',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 32),

            _buildSectionHeader('Cuenta'),
            _buildListTile(
              icon: Icons.person_outline_rounded,
              title: 'Editar Perfil',
              subtitle: 'Cambia tu nombre, email o contraseña',
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.security_rounded,
              title: 'Privacidad y Seguridad',
              subtitle: 'Controla quién ve tus datos',
              onTap: () {},
            ),

            SizedBox(height: 24),
            _buildSectionHeader('Preferencias'),
            _buildSwitchTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notificaciones Push',
              value: _controller.notificationsEnabled,
              onChanged: (val) {
                setState(() {
                  _controller.toggleNotifications(val);
                });
              },
            ),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, currentMode, child) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      currentMode == ThemeMode.dark ? Icons.dark_mode_outlined : (currentMode == ThemeMode.light ? Icons.light_mode_outlined : Icons.brightness_auto),
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    'Apariencia',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  trailing: DropdownButton<ThemeMode>(
                    value: currentMode,
                    underline: SizedBox(),
                    icon: Icon(Icons.arrow_drop_down_rounded),
                    onChanged: (ThemeMode? newValue) {
                      if (newValue != null) {
                        themeNotifier.value = newValue;
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('Sistema', style: TextStyle(fontSize: 14)),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Claro', style: TextStyle(fontSize: 14)),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Oscuro', style: TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                );
              },
            ),
            _buildSwitchTile(
              icon: Icons.favorite_border_rounded,
              title: 'Sincronizar Salud',
              value: _controller.syncHealthData,
              onChanged: (val) {
                setState(() {
                  _controller.toggleSyncHealthData(val);
                });
              },
            ),

            SizedBox(height: 24),
            _buildSectionHeader('Acerca de'),
            _buildListTile(
              icon: Icons.help_outline_rounded,
              title: 'Centro de Ayuda',
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.info_outline_rounded,
              title: 'Términos y Condiciones',
              onTap: () {},
            ),

            SizedBox(height: 100), // Espaciado final para el Navbar
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  // Widget base para opciones tocables
  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
            )
          : null,
      trailing: Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }

  // Widget base para opciones con interruptor (Switch)
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Theme.of(context).colorScheme.onSurface, // Estilo Next.js negro
        activeTrackColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
      ),
    );
  }
}
