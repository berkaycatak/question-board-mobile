import 'package:intl/intl.dart';

class Helpers {
  static String getTimeDifference(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'şimdi';
    }
  }

  static dateToApiFormat(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
