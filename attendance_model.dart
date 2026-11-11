class AttendanceModel {
  final String id;
  final String userId;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final String status;
  final String workDate;

  AttendanceModel({
    required this.id,
    required this.userId,
    required this.checkInTime,
    this.checkOutTime,
    required this.status,
    required this.workDate,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      userId: json['user_id'],
      checkInTime: DateTime.parse(json['check_in_time']),
      checkOutTime: json['check_out_time'] != null ? DateTime.parse(json['check_out_time']) : null,
      status: json['status'],
      workDate: json['work_date'],
    );
  }
}