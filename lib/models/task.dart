class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  Task(
      {this.id,
      required this.title,
      required this.note,
      required this.isCompleted,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.color,
      required this.repeat,
      required this.remind});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'repeat': repeat,
      'remind': remind,
    };
  }

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    color = json['color'];
    repeat = json['repeat'];
    remind = json['remind'];
  }
}
