class Student {
  final int id;
  final String fullname;
  final String major;
  final String photo;
  final String status;
  final DateTime? lastEntry;
  final DateTime? lastExit;

  Student({
    required this.id,
    required this.fullname,
    required this.major,
    required this.photo,
    required this.status,
    this.lastEntry,
    this.lastExit,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: int.parse(json['id'].toString()),
      fullname: json['fullname'],
      major: json['major'],
      photo: json['photo'],
      status: json['status'] ?? 'unknown',
      lastEntry: json['entry_time'] != null ? DateTime.parse(json['entry_time']) : null,
      lastExit: json['exit_time'] != null ? DateTime.parse(json['exit_time']) : null,
    );
  }
} 