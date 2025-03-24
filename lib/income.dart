import 'package:cipher_assignment/const/appconst.dart';
import 'package:cipher_assignment/const/colors.dart';
import 'package:cipher_assignment/const/custom/custombutton.dart';
import 'package:cipher_assignment/const/custom/dropdown.dart';
import 'package:cipher_assignment/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;
  String? _selectedWallet;

  Future<void> _saveIncomeData() async {
    if (!_formKey.currentState!.validate()) return;

    final String uniqueKey = const Uuid().v4();
    final String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    final incomeData = {
      'key': uniqueKey,
      'amount': double.tryParse(_amountController.text) ?? 0.0,
      'category': _selectedCategory,
      'description': _descriptionController.text,
      'wallet': _selectedWallet,
      'timestamp': formattedTime,
    };

    try {
      final box = await Hive.openBox('incomeBox');
      await box.put(uniqueKey, incomeData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Income added successfully!')),
      );

      _amountController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedCategory = null;
        _selectedWallet = null;
      });

      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: SizedBox(
            height: 24,
            child: Image.asset('assets/arrow-left.png', color: Colors.white),
          ),

          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Income',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.currency_rupee,
                    size: 40,
                    color: Colors.white,
                  ),
                  hintText: '0',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 64),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter amount';
                  if (double.tryParse(value) == null)
                    return 'Enter a valid amount';
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    CustomExpandableDropdown(
                      hintText: "Category",
                      items: Constants.categories,
                      selectedValue: _selectedCategory,
                      onItemSelected: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.text,
                      enabled: true,

                      decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: TextStyle(color: textColor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            width: 3,
                            color: textFieldColor,
                          ),
                        ),

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    CustomExpandableDropdown(
                      hintText: "Wallet",
                      items: Constants.paymentMethods,
                      selectedValue: _selectedWallet,
                      onItemSelected: (value) {
                        setState(() {
                          _selectedWallet = value;
                        });
                      },
                    ),
                    const Spacer(),

                    Container(height: 2, color: primaryColor),
                    const SizedBox(height: 20),
                    CustomButton(text: 'Continue', onPressed: _saveIncomeData),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
