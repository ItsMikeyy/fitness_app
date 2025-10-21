import 'package:flutter/material.dart';
import 'package:nutrition/models/meal.dart';
import 'package:nutrition/screens/AddMeal/add_meal_screen.dart';
import 'package:nutrition/screens/mealDetails/meal_details_screen.dart';
import 'package:nutrition/providers/user_provider.dart';
import 'package:nutrition/services/nutrition_service.dart';
import 'package:provider/provider.dart';

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  NutritionService nutritionService = NutritionService();
  List<Meal> meals = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final user = context.read<UserProvider>().currentUser;
      if (user != null) {
        final userMeals = await nutritionService.getUserMeals(user.id);
        setState(() {
          meals = userMeals;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'No user found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading meals: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Meals'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _loadMeals)],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMeal,
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading meals...'),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              errorMessage!,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _loadMeals, child: Text('Retry')),
          ],
        ),
      );
    }

    if (meals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No meals added yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add your first meal',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: meals.length,
      itemBuilder: (BuildContext context, int index) {
        final meal = meals[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                meal.name[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              meal.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal.description),
                SizedBox(height: 4),
                Row(
                  children: [
                    _buildNutritionChip('${meal.calories} cal'),
                    SizedBox(width: 8),
                    _buildNutritionChip('${meal.protein}g protein'),
                    SizedBox(width: 8),
                    _buildNutritionChip(meal.mealType),
                  ],
                ),
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealDetailsScreen(meal: meal),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNutritionChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.green[800],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _addMeal() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMealScreen()),
    ).then((_) {
      // Refresh meals list when returning from add meal screen
      _loadMeals();
    });
  }
}
