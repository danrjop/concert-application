import 'package:flutter/material.dart';

class SegmentedTabControl extends StatelessWidget {
  final bool isFirstTabSelected;
  final String firstTabLabel;
  final String secondTabLabel;
  final Function(bool) onTabChanged;

  const SegmentedTabControl({
    super.key,
    required this.isFirstTabSelected,
    required this.firstTabLabel,
    required this.secondTabLabel,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // First tab
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isFirstTabSelected ? Colors.white : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isFirstTabSelected
                      ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    firstTabLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Second tab
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isFirstTabSelected ? Colors.white : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: !isFirstTabSelected
                      ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    secondTabLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
