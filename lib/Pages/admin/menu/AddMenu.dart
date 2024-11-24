import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // for date formatting

class AddLunchMenu extends StatefulWidget {
  final DateTime selectedDate;

  const AddLunchMenu({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<AddLunchMenu> createState() => _AddLunchMenuState();
}
class _AddLunchMenuState extends State<AddLunchMenu> {
  String? selectedRice;
  String? selectedMainDish;
  String? selectedAlternativeDish;
  String? selectedDrink;
  String? selectedMealType = 'Lunch';

  final Map<String, double> riceOptions = {
    'Rice': 50.0,
    'Fried Rice': 80.0,
    'Kichuri': 60.0,
  };
  final Map<String, double> mainDishOptions = {
    'Meat': 150.0,
    'Chicken': 120.0,
    'Mutton': 180.0,
  };
  final Map<String, double> alternativeDishOptions = {
    'Vegetable': 30.0,
    "Lentil Soup": 10.0,
  };
  final Map<String, double> drinkOptions = {
    'Mojo': 40.0,
    'Water': 20.0,
    'Juice': 50.0,
  };

  double totalPrice = 0.0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Set Menu",
          style: GoogleFonts.merriweather(
              fontSize: 25, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Meal Type:",
                style: GoogleFonts.merriweather(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: selectedMealType,
                items: ['Lunch', 'Dinner'].map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option, style: GoogleFonts.merriweather()),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedMealType = newValue;
                    totalPrice = _calculateTotalPrice();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Select a Rice Dish:",
                style: GoogleFonts.merriweather(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: selectedRice,
                items: riceOptions.keys.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text("$option - \$${riceOptions[option]}",
                        style: GoogleFonts.merriweather()),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedRice = newValue;
                    totalPrice = _calculateTotalPrice();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Select a Main Dish:",
                style: GoogleFonts.merriweather(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: selectedMainDish,
                items: mainDishOptions.keys.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text("$option - \$${mainDishOptions[option]}",
                        style: GoogleFonts.merriweather()),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedMainDish = newValue;
                    totalPrice = _calculateTotalPrice();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Select an Alternative Dish:",
                style: GoogleFonts.merriweather(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: selectedAlternativeDish,
                items: alternativeDishOptions.keys.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text("$option - \$${alternativeDishOptions[option]}",
                        style: GoogleFonts.merriweather()),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedAlternativeDish = newValue;
                    totalPrice = _calculateTotalPrice();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Select a Beverage:",
                style: GoogleFonts.merriweather(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: selectedDrink,
                items: drinkOptions.keys.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      "$option - \$${drinkOptions[option]}",
                      style: GoogleFonts.merriweather(),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedDrink = newValue;
                    totalPrice = _calculateTotalPrice();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price:",
                    style: GoogleFonts.merriweather(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1FAF40),
                    ),
                  ),
                  Text(
                    "\$${totalPrice.toStringAsFixed(2)}",
                    style: GoogleFonts.merriweather(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: size.width,
                child: ElevatedButton(
                  onPressed: _updateMealMenu,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1FAF40),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Update Meal Menu',
                    style: GoogleFonts.merriweather(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  double _calculateTotalPrice() {
    double ricePrice =
        selectedRice != null ? riceOptions[selectedRice] ?? 0.0 : 0.0;
    double mainDishPrice = selectedMainDish != null
        ? mainDishOptions[selectedMainDish] ?? 0.0
        : 0.0;
    double alternativeDishPrice = selectedAlternativeDish != null
        ? alternativeDishOptions[selectedAlternativeDish] ?? 0.0
        : 0.0;
    double drinkPrice =
        selectedDrink != null ? drinkOptions[selectedDrink] ?? 0.0 : 0.0;
    return ricePrice + mainDishPrice + alternativeDishPrice + drinkPrice;
  }
  Future<void> _updateMealMenu() async {
    if (selectedRice == null ||
        selectedMainDish == null ||
        selectedAlternativeDish == null ||
        selectedDrink == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select all options!')),
      );
      return;
    }
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('meal_menus')
          .where('meal_type', isEqualTo: selectedMealType)
          .where('date', isEqualTo: formattedDate)
          .get();

      if (snapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('You can only update $selectedMealType once per day!'),
          ),
        );
        return;
      }
      double ricePrice = riceOptions[selectedRice] ?? 0.0;
      double mainDishPrice = mainDishOptions[selectedMainDish] ?? 0.0;
      double alternativeDishPrice =
          alternativeDishOptions[selectedAlternativeDish] ?? 0.0;
      double drinkPrice = drinkOptions[selectedDrink] ?? 0.0;
      await _firestore.collection('meal_menus').add({
        'date': formattedDate,
        'meal_type': selectedMealType,
        'rice': selectedRice ?? 'Not selected',
        'main_dish': selectedMainDish ?? 'Not selected',
        'alternative_dish': selectedAlternativeDish ?? 'Not selected',
        'drink': selectedDrink ?? 'Not selected',
        'rice_price': ricePrice,
        'main_dish_price': mainDishPrice,
        'alternative_dish_price': alternativeDishPrice,
        'drink_price': drinkPrice,
        'total_price': totalPrice,
      });

      setState(() {
        selectedRice = null;
        selectedMainDish = null;
        selectedAlternativeDish = null;
        selectedDrink = null;
        totalPrice = 0.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Meal menu updated successfully!',
            style: GoogleFonts.merriweather(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update meal menu: $e',
            style: GoogleFonts.merriweather(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
