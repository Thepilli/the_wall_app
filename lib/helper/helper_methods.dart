// return formated data as a string

import 'package:cloud_firestore/cloud_firestore.dart';

String formatData(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  return formattedDate;
}
