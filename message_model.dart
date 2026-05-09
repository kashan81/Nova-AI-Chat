class MessageModel {
  final String? id;
  final String? userId;
  final String message;
  final bool isUser;
  final DateTime? createdAt;
  final String mode;

  MessageModel({
    this.id,
    this.userId,
    required this.message,
    required this.isUser,
    this.createdAt,
    this.mode = 'general',
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id']?.toString(),
      userId: map['user_id']?.toString(),
      message: map['message'] ?? '',
      isUser: map['is_user'] ?? false,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      mode: map['mode'] ?? 'general',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      'message': message,
      'is_user': isUser,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      'mode': mode,
    };
  }
}
