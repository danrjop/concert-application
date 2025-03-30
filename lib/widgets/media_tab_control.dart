import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class MediaTabControl extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;
  final List<String> tabLabels;

  const MediaTabControl({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    required this.tabLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 44, // iOS standard height
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppConstants.darkGreyColor
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: List.generate(tabLabels.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(index),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? Theme.of(context).brightness == Brightness.dark
                        ? AppConstants.darkSurfaceColor
                        : Colors.white 
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 0.5,
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    tabLabels[index],
                    style: TextStyle(
                      color: isSelected 
                          ? Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black 
                          : Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black54,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
