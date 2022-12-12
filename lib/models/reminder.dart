class Reminder {
  String? reminderName;
  String? reminderDate;
  bool? reminderCompleted;
  int? id;
  String? simiReminders;
  String? remindertype;
  Reminder(
      {this.reminderName,
      this.reminderDate,
      this.reminderCompleted,
      this.simiReminders,
      this.remindertype,
      this.id});
}

class SimiReminder {
  String? simiReminderName;
  String? simiReminderDate;
  bool? simiReminderCompleted;

  SimiReminder(
      {this.simiReminderName,
      this.simiReminderDate,
      this.simiReminderCompleted});
  Map toJson() => {
        'simiReminderName': simiReminderName,
        'simiReminderDate': simiReminderDate,
        'simiReminderCompleted': simiReminderCompleted,
      };

  SimiReminder.fromJson(Map<String, dynamic> json)
      : simiReminderName = json['simiReminderName'],
        simiReminderDate = json['simiReminderDate'],
        simiReminderCompleted = json['simiReminderCompleted'];
}
