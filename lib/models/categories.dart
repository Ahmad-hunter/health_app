import 'package:flutter/cupertino.dart';

class ReminderType {
  int? id;
  String? typeName;
  IconData? typeIcon;
  int? reminderCount;

  ReminderType({this.typeName, this.typeIcon, this.reminderCount, this.id});
}
