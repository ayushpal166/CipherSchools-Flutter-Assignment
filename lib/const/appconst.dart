import 'package:flutter/material.dart';

class Constants {
  static const List<String> categories = [
    'Food',
    'Travel',
    'Subscription',
    'shopping',
  ];

  static Map<String, dynamic> getCategoryData(String type) {
    const Map<String, Map<String, dynamic>> expenseData = {
      'Food': {
        'iconPath': 'assets/food.svg',
        'backgroundColor': Color(0xffFAE3E5),
      },
      'Travel': {
        'iconPath': 'assets/car.svg',
        'backgroundColor': Color(0xffEFEFFF),
      },
      'Subscription': {
        'iconPath': 'assets/recurring_bill.svg',
        'backgroundColor': Color(0xffF6E5FF),
      },
      'Shopping': {
        'iconPath': 'assets/shopping.svg',
        'backgroundColor': Color(0xffFFF4DA),
      },
    };

    return expenseData[type] ??
        {
          'iconPath': 'assets/shopping.svg',
          'backgroundColor': Colors.grey[300],
        };
  }

  static const List<String> paymentMethods = ['Cash', 'Credit', 'Debit', 'UPI'];
}
