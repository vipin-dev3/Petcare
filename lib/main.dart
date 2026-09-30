import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/auth_service.dart';
import 'services/storage_service.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';
import 'widgets/animated_paw.dart';
import 'widgets/custom_dialogs.dart';
import 'widgets/sidebar_navigation.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/pets/pets_screen.dart';
import 'screens/appointments/appointments_screen.dart';
import 'screens/services/services_screen.dart';
import 'screens/wellness/wellness_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  final authService = AuthService();
  await authService.init();

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('petcare_dark_mode') ?? false;

  runApp(PetCareApp(
    storageService: storageService,
    authService: authService,
    initialDarkMode: isDarkMode,
  ));
}

class PetCareApp extends StatefulWidget {
  final StorageService storageService;
  final AuthService authService;
  final bool initialDarkMode;

  const PetCareApp({
    super.key,
    required this.storageService,
    required this.authService,
    required this.initialDarkMode,
  });

  @override
  State<PetCareApp> createState() => _PetCareAppState();
}

class _PetCareAppState extends State<PetCareApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialDarkMode;
    widget.authService.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    widget.authService.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    setState(() {});
  }

  Future<void> _toggleDarkMode() async {
    setState(() => _isDarkMode = !_isDarkMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('petcare_dark_mode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare Pro - Veterinary & Care Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: widget.authService.isLoggedIn
          ? MainShell(
              storage: widget.storageService,
              authService: widget.authService,
              isDarkMode: _isDarkMode,
              onToggleTheme: _toggleDarkMode,
            )
          : LoginScreen(authService: widget.authService),
    );
  }
}

class MainShell extends StatefulWidget {
  final StorageService storage;
  final AuthService authService;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const MainShell({
    super.key,
    required this.storage,
    required this.authService,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _handleAddNewPet() async {
    final newPet = await CustomDialogs.showAddEditPetDialog(context);
    if (newPet != null) {
      await widget.storage.addPet(newPet);
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Text('${newPet.name} was successfully registered!'),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 850;
    final isDark = widget.isDarkMode;

    final screens = [
      DashboardScreen(
        storage: widget.storage,
        onNavigateToPets: () => setState(() => _currentIndex = 1),
        onNavigateToAppointments: () => setState(() => _currentIndex = 2),
        onNavigateToServices: () => setState(() => _currentIndex = 3),
        onAddPet: _handleAddNewPet,
      ),
      PetsScreen(
        storage: widget.storage,
        onAddPet: _handleAddNewPet,
      ),
      AppointmentsScreen(
        storage: widget.storage,
      ),
      ServicesScreen(
        storage: widget.storage,
      ),
      WellnessScreen(
        storage: widget.storage,
      ),
    ];

    final titles = [
      'Dashboard Overview',
      'Pets Directory',
      'Appointments',
      'Clinic Services',
      'Wellness & Health',
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: isDesktop
          ? null
          : AppBar(
              title: Row(
                children: [
                  const AnimatedPawBadge(size: 30, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    titles[_currentIndex],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  onPressed: widget.onToggleTheme,
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => widget.authService.logout(),
                ),
              ],
            ),
      drawer: isDesktop
          ? null
          : Drawer(
              child: SidebarNavigation(
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) {
                  setState(() => _currentIndex = index);
                  Navigator.pop(context);
                },
                onAddPet: () {
                  Navigator.pop(context);
                  _handleAddNewPet();
                },
                onToggleTheme: widget.onToggleTheme,
                onLogout: () => widget.authService.logout(),
                isDarkMode: widget.isDarkMode,
                userName: widget.authService.userName,
              ),
            ),
      body: Row(
        children: [
          if (isDesktop)
            SidebarNavigation(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) => setState(() => _currentIndex = index),
              onAddPet: _handleAddNewPet,
              onToggleTheme: widget.onToggleTheme,
              onLogout: () => widget.authService.logout(),
              isDarkMode: widget.isDarkMode,
              userName: widget.authService.userName,
            ),
          Expanded(
            child: Container(
              color: isDark ? AppColors.darkBg : AppColors.lightBg,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: KeyedSubtree(
                  key: ValueKey<int>(_currentIndex),
                  child: screens[_currentIndex],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) => setState(() => _currentIndex = index),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.pets_outlined), selectedIcon: Icon(Icons.pets), label: 'Pets'),
                NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Visits'),
                NavigationDestination(icon: Icon(Icons.medical_services_outlined), selectedIcon: Icon(Icons.medical_services), label: 'Services'),
                NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite), label: 'Wellness'),
              ],
            ),
    );
  }
}