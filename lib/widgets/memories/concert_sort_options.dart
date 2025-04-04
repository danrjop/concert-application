import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

// Define the tab types for context-aware sorting options
enum SortTabType {
  been,     // Shows all sort options including rating
  wantToGo, // Excludes rating from sort options
  recs,     // Includes recommendation rating
  trending  // Excludes rating from sort options
}

enum ConcertSortOption {
  artistAsc, // Artist A-Z
  artistDesc, // Artist Z-A
  venueAsc, // Venue A-Z
  venueDesc, // Venue Z-A
  genreAsc, // Genre A-Z
  genreDesc, // Genre Z-A
  ratingDesc, // Highest rating first
  ratingAsc, // Lowest rating first
  dateDesc, // Most recent first
  dateAsc, // Oldest first
}

class SortDropdown extends StatefulWidget {
  final ConcertSortOption currentSortOption;
  final Function(ConcertSortOption) onSortOptionSelected;
  final SortTabType tabType;

  const SortDropdown({
    super.key, 
    required this.currentSortOption,
    required this.onSortOptionSelected,
    this.tabType = SortTabType.been,
  });

  @override
  State<SortDropdown> createState() => _SortDropdownState();
}

class _SortDropdownState extends State<SortDropdown> {
  // Get the sort field without direction information
  String get sortField {
    switch (widget.currentSortOption) {
      case ConcertSortOption.artistAsc:
      case ConcertSortOption.artistDesc:
        return 'Artist';
      case ConcertSortOption.venueAsc:
      case ConcertSortOption.venueDesc:
        return 'Venue';
      case ConcertSortOption.genreAsc:
      case ConcertSortOption.genreDesc:
        return 'Genre';
      case ConcertSortOption.ratingAsc:
      case ConcertSortOption.ratingDesc:
        return 'Rating';
      case ConcertSortOption.dateAsc:
      case ConcertSortOption.dateDesc:
        return 'Date';
    }
  }

  // Is the current sort in descending order?
  bool get isDescending {
    return [
      ConcertSortOption.artistDesc,
      ConcertSortOption.venueDesc,
      ConcertSortOption.genreDesc,
      ConcertSortOption.ratingDesc,
      ConcertSortOption.dateDesc,
    ].contains(widget.currentSortOption);
  }

  // Get the option for a given field and direction
  ConcertSortOption getOptionForFieldAndDirection(String field, bool descending) {
    switch (field) {
      case 'Artist':
        return descending ? ConcertSortOption.artistDesc : ConcertSortOption.artistAsc;
      case 'Venue':
        return descending ? ConcertSortOption.venueDesc : ConcertSortOption.venueAsc;
      case 'Genre':
        return descending ? ConcertSortOption.genreDesc : ConcertSortOption.genreAsc;
      case 'Rating':
        return descending ? ConcertSortOption.ratingDesc : ConcertSortOption.ratingAsc;
      case 'Date':
        return descending ? ConcertSortOption.dateDesc : ConcertSortOption.dateAsc;
      default:
        return ConcertSortOption.dateDesc; // Default to date
    }
  }

  // Toggle the sort direction while keeping the same field
  void _toggleSortDirection() {
    // Get current field but opposite direction
    final newOption = getOptionForFieldAndDirection(sortField, !isDescending);
    widget.onSortOptionSelected(newOption);
  }

  // Get the available sort fields based on tab type
  List<String> get _sortFields {
    switch (widget.tabType) {
      case SortTabType.been:
        return ['Artist', 'Venue', 'Genre', 'Rating', 'Date'];
      case SortTabType.wantToGo:
      case SortTabType.trending:
        return ['Artist', 'Venue', 'Genre', 'Date'];
      case SortTabType.recs:
        return ['Artist', 'Venue', 'Genre', 'Rating', 'Date'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sort direction toggle button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              onTap: _toggleSortDirection,
              child: Container(
                height: 32,
                width: 32,
                alignment: Alignment.center,
                child: Icon(
                  isDescending ? Icons.arrow_downward : Icons.arrow_upward,
                  color: AppConstants.primaryColor,
                  size: 18,
                ),
              ),
            ),
          ),
          
          // Simple dropdown for sort field
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _sortFields.contains(sortField) ? sortField : _sortFields.first,
              icon: const Icon(Icons.arrow_drop_down, size: 14),
              iconSize: 14,
              isDense: true,
              itemHeight: 48,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              underline: Container(),
              menuMaxHeight: 400,
              padding: const EdgeInsets.only(left: 8, right: 12),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(8),
              // Control dropdown alignment
              alignment: AlignmentDirectional.topStart,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  final newOption = getOptionForFieldAndDirection(newValue, isDescending);
                  widget.onSortOptionSelected(newOption);
                }
              },
              items: _sortFields
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
