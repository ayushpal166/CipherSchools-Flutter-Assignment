import 'package:cipher_assignment/const/appconst.dart';
import 'package:cipher_assignment/const/colors.dart';
import 'package:cipher_assignment/const/custom/balance_card.dart';
import 'package:cipher_assignment/const/custom/cutom_bottom_nav_bar.dart';
import 'package:cipher_assignment/const/custom/date_tab.dart';
import 'package:cipher_assignment/const/custom/income_expense_dialog.dart';
import 'package:cipher_assignment/income.dart';
import 'package:cipher_assignment/screens/profile.dart';
import 'package:cipher_assignment/screens/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedTabIndex = 0;
  int selectedIndex = 0;

  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  double accountBalance = 0.0;
  List<Map<String, dynamic>> recentTransactions = [];

  void onItemTap(int index) {
    if (index == 1 || index == 3) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IncomeExpenseDialog()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Profile()),
      );
    }
  }

  final List<String> tabs = ["Today", "Week", "Month", "Year"];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var incomeBox = await Hive.openBox('incomeBox');
    var expenseBox = await Hive.openBox('expenseBox');

    double incomeSum = 0;
    double expenseSum = 0;
    List<Map<String, dynamic>> transactions = [];

    for (var key in incomeBox.keys) {
      var income = incomeBox.get(key);
      String timestamp = income['timestamp'] ?? '12:00 PM';
      incomeSum += income['amount'] as double;
      String selectedCategory = income['category'];
      final Map<String, dynamic> categoryInfo = Constants.getCategoryData(
        selectedCategory,
      );

      transactions.add({
        'key': key,
        'title': income['category'],
        'subtitle': income['description'],
        'amount': '+ ₹${income['amount'].toStringAsFixed(2)}',
        'time': _formatTime(timestamp),
        'textColor': const Color(0xff00A86B),
        'color': categoryInfo['backgroundColor'],
        'icon': categoryInfo['iconPath'],
        'type': 'income',
      });
    }

    for (var key in expenseBox.keys) {
      var expense = expenseBox.get(key);
      String timestamp = expense['timestamp'] ?? "12:00 PM";
      expenseSum += expense['amount'] as double;
      String selectedCategory = expense['category'];
      final Map<String, dynamic> categoryInfo = Constants.getCategoryData(
        selectedCategory,
      );

      transactions.add({
        'key': key,
        'title': expense['category'],
        'subtitle': expense['description'],
        'amount': '- ₹${expense['amount'].toStringAsFixed(2)}',
        'time': _formatTime(timestamp),
        'textColor': const Color(0xffFD3C4A),
        'color': categoryInfo['backgroundColor'],
        'icon': categoryInfo['iconPath'],
        'type': 'expense',
      });
    }

    setState(() {
      totalIncome = incomeSum;
      totalExpenses = expenseSum;
      accountBalance = totalIncome - totalExpenses;
      recentTransactions = transactions;
    });
  }

  void updateIncomeData(Map<String, dynamic> newIncome) {
    double newAmount = newIncome['amount'];

    setState(() {
      totalIncome += newAmount;
      accountBalance += newAmount;
    });
  }

  Future<void> _deleteTransaction(String key, String type) async {
    var incomeBox = await Hive.openBox('incomeBox');
    var expenseBox = await Hive.openBox('expenseBox');

    if (type == 'income' && incomeBox.containsKey(key)) {
      await incomeBox.delete(key);
    } else if (type == 'expense' && expenseBox.containsKey(key)) {
      await expenseBox.delete(key);
    } else {}

    _fetchData();
  }

  String _formatTime(String timestamp) {
    return timestamp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9FB),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTap,
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xffFFF6E5),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.asset('assets/profile1.png'),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: primaryColor.withOpacity(0.1), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/arrow down 2.png", color: primaryColor),
              const SizedBox(width: 8),
              const Text(
                'March',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SvgPicture.asset(
              'assets/notification.svg',
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xffFFF6E5),
              const Color(0xffF8EDD8).withOpacity(0),
              const Color(0xffF9F9FB),
            ],
            stops: const [0.0, 0.5, 0.5],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Account Balance',
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                '₹${accountBalance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BalanceCard(
                      title: 'Income',
                      amount: '₹${totalIncome.toStringAsFixed(2)}',
                      icon: 'assets/income.svg',
                      color: const Color(0xff00A86B),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const IncomeScreen(),
                          ),
                        );

                        if (result != null) {
                          updateIncomeData(result);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BalanceCard(
                      title: 'Expenses',
                      amount: '₹${totalExpenses.toStringAsFixed(2)}',
                      icon: 'assets/expense.svg',
                      color: const Color(0xffFD3C4A),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ExpenseScreen(),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            totalExpenses += result['amount'];
                            accountBalance -= result['amount'];
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  tabs.length,
                  (index) => DateTab(
                    text: tabs[index],
                    isSelected: index == selectedTabIndex,
                    onTap: () {
                      setState(() {
                        selectedTabIndex = index;
                      });
                    },
                    selectedColor: const Color(0xffFCEED4),
                    unselectedColor: const Color(0xffFCAC12),
                    textColor: textColor,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Transactions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xffEEE5FF),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      "See All",
                      style: TextStyle(
                        color: const Color(0xff7F3DFF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Column(
                children:
                    recentTransactions
                        .map(
                          (transaction) => TransactionCard(
                            keyValue: transaction['key'],
                            title: transaction['title'],
                            subtitle: transaction['subtitle'],
                            amount: transaction['amount'],
                            time: transaction['time'],
                            backgroundColor: transaction['color'],
                            textColor: transaction['textColor'],
                            iconPath: transaction['icon'],
                            onDelete:
                                (key) => _deleteTransaction(
                                  key,
                                  transaction['type'],
                                ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String keyValue;
  final String title;
  final String subtitle;
  final String amount;
  final String time;
  final String iconPath;
  final Color backgroundColor;
  final Color textColor;
  final Function(String key) onDelete;

  const TransactionCard({
    super.key,
    required this.keyValue,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.iconPath,
    required this.backgroundColor,
    required this.textColor,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(keyValue),
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 24),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        onDelete(keyValue);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff545456),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff545456),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
