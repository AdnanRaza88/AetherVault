import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/vault_service.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AetherVaultApp());
}

class AetherVaultApp extends StatelessWidget {
  const AetherVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VaultService(),
      child: MaterialApp(
        title: 'AetherVault',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF7C3AED),
          scaffoldBackgroundColor: const Color(0xFF0F0F0F),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A1A1A),
            elevation: 0,
          ),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF7C3AED),
            secondary: Color(0xFFA78BFA),
            surface: Color(0xFF1A1A1A),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
