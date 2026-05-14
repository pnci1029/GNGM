class AppDateUtils {
  static String formatChatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    final difference = today.difference(messageDate).inDays;
    
    if (difference == 0) {
      return _formatTime(dateTime);
    } else if (difference == 1) {
      return '어제';
    } else if (difference < 7) {
      return _formatWeekday(dateTime);
    } else if (dateTime.year == now.year) {
      return '${dateTime.month}월 ${dateTime.day}일';
    } else {
      return '${dateTime.year}.${dateTime.month}.${dateTime.day}';
    }
  }

  static String formatMessageTime(DateTime dateTime) {
    return _formatTime(dateTime);
  }

  static String formatChatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    final difference = today.difference(messageDate).inDays;
    
    if (difference == 0) {
      return '오늘';
    } else if (difference == 1) {
      return '어제';
    } else if (dateTime.year == now.year) {
      return '${dateTime.month}월 ${dateTime.day}일';
    } else {
      return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일';
    }
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    
    if (hour == 0) {
      return '오전 12:${minute.toString().padLeft(2, '0')}';
    } else if (hour < 12) {
      return '오전 $hour:${minute.toString().padLeft(2, '0')}';
    } else if (hour == 12) {
      return '오후 12:${minute.toString().padLeft(2, '0')}';
    } else {
      return '오후 ${hour - 12}:${minute.toString().padLeft(2, '0')}';
    }
  }

  static String _formatWeekday(DateTime dateTime) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return '${weekdays[dateTime.weekday - 1]}요일';
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}