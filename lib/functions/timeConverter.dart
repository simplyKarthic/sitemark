import 'package:cloud_firestore/cloud_firestore.dart';

getTimeElapsed(Timestamp timestamp){
  final DateTime now = DateTime.now();
  final DateTime dateTime = timestamp.toDate();
  final Duration difference = now.difference(dateTime);

  if (difference.inDays > 0) {
    final int days = difference.inDays;
    final int hours = difference.inHours.remainder(24);
    return '${days}d, ${hours}hr ago';
  } else if (difference.inHours > 0) {
    final int hours = difference.inHours;
    final int minutes = difference.inMinutes.remainder(60);
    return '${hours}hr, $minutes min ago';
  } else {
    final int minutes = difference.inMinutes;
    if(minutes == 0){
      return 'just now';
    }
    return '$minutes min ago';
  }
}
