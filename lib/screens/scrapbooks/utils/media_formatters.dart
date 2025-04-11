/// Utility class for formatting dates, timestamps, and other data
class MediaFormatters {
  /// Format date to display in timeline (MM/DD/YYYY)
  static String formatDate(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }
  
  /// Format timestamp for display (h:mm AM/PM)
  static String formatTimestamp(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
  
  /// Format media duration (m:ss)
  static String formatDuration(Duration? duration) {
    if (duration == null) return '';
    
    final minutes = duration.inMinutes;
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
  
  /// Check if two dates are the same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  
  /// Format section name for display
  static String formatSectionName(String section) {
    switch (section) {
      case 'pre-show':
        return 'Before the Show';
      case 'main-show':
        return 'During the Show';
      case 'post-show':
        return 'After the Show';
      default:
        return section.split('-').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
    }
  }
}
