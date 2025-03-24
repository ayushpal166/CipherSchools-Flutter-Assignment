import 'package:cipher_assignment/const/colors.dart';
import 'package:cipher_assignment/const/custom/cutom_bottom_nav_bar.dart';
import 'package:cipher_assignment/const/custom/income_expense_dialog.dart';
import 'package:cipher_assignment/screens/home.dart';
import 'package:cipher_assignment/screens/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int selectedIndex = 4;

  String userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          userName = userDoc['name'] ?? 'User';
        });
      }
    } catch (e) {
      debugPrint('Error fetching username: ${e.toString()}');
      setState(() {
        userName = 'User';
      });
    }
  }

  Future<void> clearHiveData() async {
    try {
      await Hive.deleteFromDisk();
      await Hive.close();
    } catch (e) {
      debugPrint("Error clearing Hive data: ${e.toString()}");
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    await clearHiveData();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Logout successful!')));
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => const SignUp()));
  }

  void onItemTap(int index) {
    if (index == 1 || index == 3) return;
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Profile()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IncomeExpenseDialog()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9FB),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTap,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      'assets/edit.png',
                      height: 24,
                      width: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildOption(
                        icon: 'assets/wallet 3.png',
                        label: 'Account',
                        color: const Color(0xffEEE5FF),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDivider(),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildOption(
                        icon: 'assets/settings.png',
                        label: 'Settings',
                        color: const Color(0xffEEE5FF),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDivider(),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildOption(
                        icon: 'assets/upload.png',
                        label: 'Export Data',
                        color: const Color(0xffEEE5FF),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDivider(),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: InkWell(
                        onTap: () async {
                          logout();
                        },
                        child: _buildOption(
                          icon: 'assets/logout.png',
                          label: 'Logout',
                          color: const Color(0xffFFE2E4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption({
    required String icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(child: Image.asset(icon, height: 24, width: 24)),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -1),
          ),
        ],
      ),
    );
  }
}
