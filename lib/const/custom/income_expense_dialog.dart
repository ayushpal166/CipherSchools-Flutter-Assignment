import 'package:cipher_assignment/const/colors.dart';
import 'package:cipher_assignment/income.dart';
import 'package:cipher_assignment/screens/expense.dart';
import 'package:cipher_assignment/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IncomeExpenseDialog extends StatefulWidget {
  const IncomeExpenseDialog({super.key});

  @override
  State<IncomeExpenseDialog> createState() => _IncomeExpenseDialogState();
}

class _IncomeExpenseDialogState extends State<IncomeExpenseDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Choose Option",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionCard(
                  context: context,
                  title: "Income",
                  icon: 'assets/income.svg',
                  color: const Color(0xff00A86B),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IncomeScreen(),
                        ),
                      ),
                ),
                _buildOptionCard(
                  context: context,
                  title: "Expense",
                  icon: 'assets/expense.svg',
                  color: const Color(0xffFD3C4A),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExpenseScreen(),
                        ),
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildCancelButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xffFD3C4A), Color(0xffFF7E67)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Center(
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
