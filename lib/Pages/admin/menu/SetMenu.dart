import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SetMenuPage extends StatefulWidget {
  final Map<String, double> riceOptions;
  final Map<String, double> mainDishOptions;
  final Map<String, double> alternativeDishOptions;
  final Map<String, double> drinkOptions;
  final DateTime selectedDate;

  const SetMenuPage({
    super.key,
    required this.riceOptions,
    required this.mainDishOptions,
    required this.alternativeDishOptions,
    required this.drinkOptions,
    required this.selectedDate,
  });

  @override
  State<SetMenuPage> createState() => _SetMenuPageState();
}

class _SetMenuPageState extends State<SetMenuPage> {
  String? _selectedRice;
  String? _selectedMainDish;
  String? _selectedAlternativeDish;
  String? _selectedDrink;

  double _totalPrice = 0.0;

  void _calculateTotal() {
    setState(() {
      _totalPrice = 0.0;
      if (_selectedRice != null)
        _totalPrice += widget.riceOptions[_selectedRice] ?? 0.0;
      if (_selectedMainDish != null)
        _totalPrice += widget.mainDishOptions[_selectedMainDish] ?? 0.0;
      if (_selectedAlternativeDish != null)
        _totalPrice +=
            widget.alternativeDishOptions[_selectedAlternativeDish] ?? 0.0;
      if (_selectedDrink != null)
        _totalPrice += widget.drinkOptions[_selectedDrink] ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set Menu for $formattedDate',
          style: GoogleFonts.merriweather(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rice selection
              Text(
                'Select Rice',
                style: GoogleFonts.merriweather(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              DropdownButton<String>(
                value: _selectedRice,
                hint: Text('Choose Rice'),
                items: widget.riceOptions.keys.map((rice) {
                  return DropdownMenuItem<String>(
                    value: rice,
                    child: Text(rice),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRice = value;
                    _calculateTotal();
                  });
                },
              ),
              SizedBox(height: 20),

              // Main dish selection
              Text(
                'Select Main Dish',
                style: GoogleFonts.merriweather(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              DropdownButton<String>(
                value: _selectedMainDish,
                hint: Text('Choose Main Dish'),
                items: widget.mainDishOptions.keys.map((dish) {
                  return DropdownMenuItem<String>(
                    value: dish,
                    child: Text(dish),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMainDish = value;
                    _calculateTotal();
                  });
                },
              ),
              SizedBox(height: 20),

              // Alternative dish selection
              Text(
                'Select Alternative Dish',
                style: GoogleFonts.merriweather(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              DropdownButton<String>(
                value: _selectedAlternativeDish,
                hint: Text('Choose Alternative Dish'),
                items: widget.alternativeDishOptions.keys.map((dish) {
                  return DropdownMenuItem<String>(
                    value: dish,
                    child: Text(dish),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAlternativeDish = value;
                    _calculateTotal();
                  });
                },
              ),
              SizedBox(height: 20),

              // Drink selection
              Text(
                'Select Drink',
                style: GoogleFonts.merriweather(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              DropdownButton<String>(
                value: _selectedDrink,
                hint: Text('Choose Drink'),
                items: widget.drinkOptions.keys.map((drink) {
                  return DropdownMenuItem<String>(
                    value: drink,
                    child: Text(drink),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDrink = value;
                    _calculateTotal();
                  });
                },
              ),
              SizedBox(height: 30),

              // Display total price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Price:',
                    style: GoogleFonts.merriweather(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${_totalPrice.toStringAsFixed(2)}',
                    style: GoogleFonts.merriweather(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Save menu button
              SizedBox(
                width: size.width,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Save the menu to Firestore (or any other database)
                    // You can customize this according to your database structure
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Menu saved for $formattedDate'),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Save Menu',
                    style: GoogleFonts.merriweather(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF4C4D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
