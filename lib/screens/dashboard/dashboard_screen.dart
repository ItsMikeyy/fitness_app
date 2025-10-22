import 'package:flutter/material.dart';
import 'package:nutrition/models/nutrition_log.dart';
import 'package:nutrition/providers/user_provider.dart';
import 'package:nutrition/screens/meal/meal_screen.dart';
import 'package:nutrition/screens/profile/profile_screen.dart';
import 'package:nutrition/screens/debug/debug_screen.dart';
import 'package:nutrition/services/nutrition_service.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  NutritionLog? _nutritionLog;
  final String _date = DateTime.now().toIso8601String();

  @override
  void initState() {
    super.initState();
    // Load nutrition log after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNutritionLog();
    });
  }

  Future<void> _loadNutritionLog() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.currentUser;
    if (user != null) {
      _nutritionLog = await _getNutritionLog(user.id, _date);
      if (mounted) {
        setState(() {});
      }
    }
  }

  // List of pages to display based on selected tab
  final List<Widget> _pages = [
    const HomePage(),
    const MealPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? "Home" : "Profile"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Meal"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<NutritionLog?> _getNutritionLog(String userId, String date) async {
    final NutritionService nutritionService = NutritionService();
    final NutritionLog? nutritionLog = await nutritionService
        .getNutritionLogByDate(userId, date);

    if (nutritionLog == null) {
      await nutritionService.createNutritionLog(userId, date);
      // Return the newly created nutrition log
      return await nutritionService.getNutritionLogByDate(userId, date);
    }
    return nutritionLog;
  }
}

// Home Page Widget
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.home, size: 64, color: Colors.blue),
          const SizedBox(height: 16),
          const Text(
            "Welcome to Home!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "This is your home page content.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DebugScreen()),
              );
            },
            icon: const Icon(Icons.bug_report),
            label: const Text('Database Debug'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
