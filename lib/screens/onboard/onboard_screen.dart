import 'package:flutter/material.dart';
import 'package:nutrition/models/user.dart';
import 'package:nutrition/services/app_database.dart';
import 'package:nutrition/services/firebase_auth.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key, required this.onComplete});

  final Function(UserModel) onComplete;

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();

  String? _selectedGender;
  String? _selectedActivityLevel;
  String? _selectedGoal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        automaticallyImplyLeading: false, // Prevent back button
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Let\'s set up your profile to get personalized recommendations!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Height field
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid height';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Weight field
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age field
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Gender dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Activity level dropdown
              DropdownButtonFormField<String>(
                value: _selectedActivityLevel,
                decoration: const InputDecoration(
                  labelText: 'Activity Level',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'sedentary',
                    child: Text('Sedentary (little or no exercise)'),
                  ),
                  DropdownMenuItem(
                    value: 'light',
                    child: Text('Light (light exercise 1-3 days/week)'),
                  ),
                  DropdownMenuItem(
                    value: 'moderate',
                    child: Text('Moderate (moderate exercise 3-5 days/week)'),
                  ),
                  DropdownMenuItem(
                    value: 'active',
                    child: Text('Active (hard exercise 6-7 days/week)'),
                  ),
                  DropdownMenuItem(
                    value: 'very_active',
                    child: Text(
                      'Very Active (very hard exercise, physical job)',
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedActivityLevel = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your activity level';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Goal dropdown
              DropdownButtonFormField<String>(
                value: _selectedGoal,
                decoration: const InputDecoration(
                  labelText: 'Goal',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'lose_weight',
                    child: Text('Lose Weight'),
                  ),
                  DropdownMenuItem(
                    value: 'maintain',
                    child: Text('Maintain Weight'),
                  ),
                  DropdownMenuItem(
                    value: 'gain_weight',
                    child: Text('Gain Weight'),
                  ),
                  DropdownMenuItem(
                    value: 'build_muscle',
                    child: Text('Build Muscle'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGoal = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your goal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Complete button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _completeOnboarding,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Complete Setup',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    if (_formKey.currentState!.validate()) {
      try {
        final firebaseUser = AuthService().currentUser;
        if (firebaseUser == null) return;

        final now = DateTime.now().toIso8601String();

        final user = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: _nameController.text,
          profilePicture: null,
          gender: _selectedGender!,
          height: _heightController.text,
          weight: _weightController.text,
          age: _ageController.text,
          activityLevel: _selectedActivityLevel!,
          goal: _selectedGoal!,
          targetWeight: '', // Can be added later
          targetCalories: '', // Can be calculated later
          targetProtein: '', // Can be calculated later
          targetCarbs: '', // Can be calculated later
          targetFats: '', // Can be calculated later
          createdAt: now,
          updatedAt: now,
        );

        // Save user to database
        await AppDatabase.instance.insertUser(user);

        // Call the completion callback
        widget.onComplete(user);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile completed successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error saving profile: $e')));
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
