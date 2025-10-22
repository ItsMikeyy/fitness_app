import 'package:flutter/material.dart';
import 'package:nutrition/models/meal.dart';
import 'package:nutrition/providers/user_provider.dart';
import 'package:nutrition/screens/meal/meal_screen.dart';
import 'package:nutrition/services/nutrition_service.dart';
import 'package:provider/provider.dart';

class AddMealScreen extends StatefulWidget {
  final Meal? meal;
  const AddMealScreen({super.key, this.meal});

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

  static const int carbCalories = 4;
  static const int protienCalories = 4;
  static const int fatCalories = 9;

  @override
  void initState() {
    super.initState();
    _populateFields();
    _setDefaultValues();
  }

  void _populateFields() {
    if (widget.meal != null) {
      Meal meal = widget.meal!;
      mealName.text = meal.name;
      mealDescription.text = meal.description;
      mealCalories.text = meal.calories.toString();
      mealProtein.text = meal.protein.toString();
      mealCarbs.text = meal.carbs.toString();
      mealFats.text = meal.fats.toString();
      mealServings.text = meal.servings.toString();
      mealNotes.text = meal.notes ?? '';
      mealType.text = meal.mealType;
      mealImageUrl.text = meal.imageUrl ?? '';
    }
  }

  void _setDefaultValues() {
    // Set default values for new meals
    if (widget.meal == null) {
      mealProtein.text = "0";
      mealCarbs.text = "0";
      mealFats.text = "0";
      mealServings.text = "1";
      _calculateCalories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal != null ? 'Edit Meal' : 'Add New Meal'),
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
                  labelText: widget.meal?.name != null
                      ? "Meal Name *"
                      : "Meal Name",
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
                value: mealType.text.isEmpty ? null : mealType.text,
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
                      readOnly: true,
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
                      onChanged: (value) => _calculateCalories(),
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
                      onChanged: (value) => _calculateCalories(),
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
                      onChanged: (value) => _calculateCalories(),
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
                      onChanged: (value) => _calculateCalories(),
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
                  widget.meal != null ? "Update Meal" : "Save Meal",
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

      // Create or update meal object
      Meal meal;
      if (widget.meal != null) {
        // Update existing meal
        meal = widget.meal!.copyWith(
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
          updatedAt: DateTime.now().toIso8601String(),
        );
      } else {
        // Create new meal
        meal = Meal(
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
      }

      // Save meal using NutritionService
      final nutritionService = NutritionService();
      await nutritionService.saveMeal(meal);

      // Show success message and navigate back
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.meal != null
                  ? 'Meal "${meal.name}" updated successfully!'
                  : 'Meal "${meal.name}" saved successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MealPage()),
      );
    } catch (e) {
      _showErrorDialog('Error saving meal: $e');
    }
  }

  void _calculateCalories() {
    if (mealCarbs.text.isEmpty ||
        mealProtein.text.isEmpty ||
        mealFats.text.isEmpty ||
        mealServings.text.isEmpty) {
      return;
    }
    mealCalories.text =
        ((int.parse(mealCarbs.text) * carbCalories +
                    int.parse(mealProtein.text) * protienCalories +
                    int.parse(mealFats.text) * fatCalories) *
                int.parse(mealServings.text))
            .toString();
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
