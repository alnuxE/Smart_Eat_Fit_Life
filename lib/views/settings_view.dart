import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';

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
            const Text(
              'Configuración',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Ajusta tus preferencias y cuenta.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),

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

            const SizedBox(height: 24),
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
            _buildSwitchTile(
              icon: Icons.dark_mode_outlined,
              title: 'Modo Oscuro',
              value: _controller.darkModeEnabled,
              onChanged: (val) {
                setState(() {
                  _controller.toggleDarkMode(val);
                });
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

            const SizedBox(height: 24),
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

            const SizedBox(height: 100), // Espaciado final para el Navbar
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
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: Colors.black87,
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
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black87, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            )
          : null,
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
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
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black87, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.black, // Estilo Next.js negro
        activeTrackColor: Colors.black12,
      ),
    );
  }
}
