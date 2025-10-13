import 'package:flutter/material.dart';
import 'package:nutrition/models/meal.dart';
import 'package:nutrition/providers/user_provider.dart';
import 'package:nutrition/services/nutrition_service.dart';
import 'package:provider/provider.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final TextEditingController mealName = TextEditingController();
  final TextEditingController mealDescription = TextEditingController();
  final TextEditingController mealCalories = TextEditingController();
  final TextEditingController mealProtein = TextEditingController();
  final TextEditingController mealCarbs = TextEditingController();
  final TextEditingController mealFats = TextEditingController();
  final TextEditingController mealServings = TextEditingController();
  final TextEditingController mealNotes = TextEditingController();
  final TextEditingController mealType = TextEditingController();
  final TextEditingController mealImageUrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Meal'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Meal Name
              TextFormField(
                controller: mealName,
                decoration: InputDecoration(
                  labelText: "Meal Name *",
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: 16),

              // Meal Description
              TextFormField(
                controller: mealDescription,
                decoration: InputDecoration(
                  labelText: "Meal Description *",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 16),

              // Meal Type Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Meal Type *",
                  border: OutlineInputBorder(),
                ),
                items: ['breakfast', 'lunch', 'dinner', 'snack']
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    mealType.text = value;
                  }
                },
              ),
              SizedBox(height: 16),

              // Nutrition Information Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: mealCalories,
                      decoration: InputDecoration(
                        labelText: "Calories",
                        border: OutlineInputBorder(),
                        suffixText: "kcal",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: mealServings,
                      decoration: InputDecoration(
                        labelText: "Servings",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Macronutrients
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: mealProtein,
                      decoration: InputDecoration(
                        labelText: "Protein",
                        border: OutlineInputBorder(),
                        suffixText: "g",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: mealCarbs,
                      decoration: InputDecoration(
                        labelText: "Carbs",
                        border: OutlineInputBorder(),
                        suffixText: "g",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: mealFats,
                      decoration: InputDecoration(
                        labelText: "Fats",
                        border: OutlineInputBorder(),
                        suffixText: "g",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Optional Fields
              TextFormField(
                controller: mealNotes,
                decoration: InputDecoration(
                  labelText: "Notes (Optional)",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: mealImageUrl,
                decoration: InputDecoration(
                  labelText: "Image URL (Optional)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _saveMeal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Save Meal",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveMeal() async {
    try {
      // Validate required fields
      if (mealName.text.isEmpty) {
        _showErrorDialog('Please enter a meal name');
        return;
      }
      if (mealDescription.text.isEmpty) {
        _showErrorDialog('Please enter a meal description');
        return;
      }
      if (mealType.text.isEmpty) {
        _showErrorDialog('Please enter a meal type');
        return;
      }

      // Parse numeric values with error handling
      int calories = int.tryParse(mealCalories.text) ?? 0;
      int protein = int.tryParse(mealProtein.text) ?? 0;
      int carbs = int.tryParse(mealCarbs.text) ?? 0;
      int fats = int.tryParse(mealFats.text) ?? 0;
      int servings = int.tryParse(mealServings.text) ?? 1;

      // Create meal object
      Meal meal = Meal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: context.read<UserProvider>().currentUser!.id,
        name: mealName.text,
        description: mealDescription.text,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fats: fats,
        servings: servings,
        notes: mealNotes.text.isEmpty ? null : mealNotes.text,
        mealType: mealType.text,
        imageUrl: mealImageUrl.text.isEmpty ? null : mealImageUrl.text,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      print(meal);

      // Save meal using NutritionService
      final nutritionService = NutritionService();
      await nutritionService.saveMeal(meal);

      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Meal "${meal.name}" saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      _showErrorDialog('Error saving meal: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
