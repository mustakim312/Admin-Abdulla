class ProfileModel {
  final String id;
  final String email;
  final String role;
  final String status;
  final bool isOnline;
  final DateTime? lastActiveAt;

  ProfileModel({
    required this.id,
    required this.email,
    required this.role,
    required this.status,
    required this.isOnline,
    this.lastActiveAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      status: json['status'],
      isOnline: json['is_online'] ?? false,
      lastActiveAt: json['last_active_at'] != null ? DateTime.parse(json['last_active_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'status': status,
      'is_online': isOnline,
      'last_active_at': lastActiveAt?.toIso8601String(),
    };
  }
}