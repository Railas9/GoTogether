/// This class is used to share notification among the app.
/// That could be used to refresh data after an action occurred on another page.
class Notification{
  final String name;
  final List<String> stateImpacted;

  Notification({
    required this.name,
    required this.stateImpacted
  });
}

class NotificationCenter{
  static Notification userJoinActivity = Notification(name: "UserJoinActivity", stateImpacted: ["_ActivityListState"]);
  static Notification userCancelActivity = Notification(name: "UserCancelActivity", stateImpacted: ["_ActivityListState"]);
  static Notification createActivity = Notification(name: "CreateActivity", stateImpacted: ["_ActivityListState"]);
  static Notification updateActivity = Notification(name: "UpdateActivity", stateImpacted: ["_ActivityListState"]);
}
