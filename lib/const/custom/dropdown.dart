import 'package:cipher_assignment/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomExpandableDropdown extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final String? selectedValue;
  final Function(String) onItemSelected;

  const CustomExpandableDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.selectedValue,
    required this.onItemSelected,
  });

  @override
  State<CustomExpandableDropdown> createState() =>
      _CustomExpandableDropdownState();
}

class _CustomExpandableDropdownState extends State<CustomExpandableDropdown> {
  bool _isExpanded = false;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  void _toggleDropdown() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _selectItem(String value) {
    widget.onItemSelected(value);
    setState(() {
      _selectedValue = value;
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 3, color: textFieldColor),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleDropdown,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedValue ?? widget.hintText,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: _selectedValue == null ? textColor : textColor,
                      fontSize: 16,
                    ),
                  ),
                  SvgPicture.asset(
                    _isExpanded
                        ? "assets/arrow down 2.svg"
                        : "assets/arrow down 2.svg",
                    color: textColor,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            SizedBox(height: 8),
            Column(
              children: List.generate(
                widget.items.length,
                (index) => Column(
                  children: [
                    InkWell(
                      onTap: () => _selectItem(widget.items[index]),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                widget.items[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (index != widget.items.length - 1)
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 2,
                        height: 2,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
