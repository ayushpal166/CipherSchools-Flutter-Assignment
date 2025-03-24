import 'package:cipher_assignment/const/appconst.dart';
import 'package:cipher_assignment/const/colors.dart';
import 'package:cipher_assignment/const/custom/custombutton.dart';
import 'package:cipher_assignment/const/custom/dropdown.dart';
import 'package:cipher_assignment/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  String? selectedCategory;
  String? selectedWallet;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  Future<void> _saveExpenseData() async {
    if (amountController.text.isEmpty ||
        selectedCategory == null ||
        descriptionController.text.isEmpty ||
        selectedWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields!')),
      );
      return;
    }

    final uid = Uuid();
    final String uniqueKey = uid.v4();

    final DateTime now = DateTime.now();
    final String formattedTime = DateFormat('hh:mm a').format(now);

    final expenseData = {
      'key': uniqueKey,
      'amount': double.parse(amountController.text),
      'category': selectedCategory,
      'description': descriptionController.text,
      'wallet': selectedWallet,
      'timestamp': formattedTime,
    };

    var box = Hive.box('expenseBox');
    await box.put(uniqueKey, expenseData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense added successfully!')),
    );

    amountController.clear();
    descriptionController.clear();

    // Navigate back to the home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0077FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/arrow-left.png',
              width: 24,
              color: Colors.white,
            ),
          ),
        ),
        title: const Text(
          'Expense',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'How much?',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffFCFCFC),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.currency_rupee,
                  size: 60,
                  color: Colors.white,
                ),
                hintText: '0',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    CustomExpandableDropdown(
                      hintText: "Category",
                      items: Constants.categories,
                      selectedValue: selectedCategory,
                      onItemSelected: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Enter Description";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Description",

                        hintStyle: const TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            width: 3,
                            color: textFieldColor,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),
                    CustomExpandableDropdown(
                      hintText: "Wallet",
                      items: Constants.paymentMethods,
                      selectedValue: selectedWallet,
                      onItemSelected: (value) {
                        setState(() {
                          selectedWallet = value;
                        });
                      },
                    ),
                    const SizedBox(height: 210),
                    Container(height: 2, color: primaryColor),
                    const SizedBox(height: 20),
                    CustomButton(text: 'Continue', onPressed: _saveExpenseData),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
