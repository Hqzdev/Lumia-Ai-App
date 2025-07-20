/// Represents a message in the chat conversation
class Message {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final bool isStreaming;
  final String? model;

  const Message({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.isStreaming = false,
    this.model,
  });

  /// Creates a Message from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: json['content'] as String,
      role: MessageRole.values.firstWhere(
        (e) => e.toString() == 'MessageRole.${json['role']}',
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isStreaming: json['isStreaming'] as bool? ?? false,
      model: json['model'] as String?,
    );
  }

  /// Converts Message to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'role': role.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'isStreaming': isStreaming,
      'model': model,
    };
  }

  /// Creates a copy of this Message with updated fields
  Message copyWith({
    String? id,
    String? content,
    MessageRole? role,
    DateTime? timestamp,
    bool? isStreaming,
    String? model,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      isStreaming: isStreaming ?? this.isStreaming,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents the role of a message sender
enum MessageRole {
  user,
  assistant,
  system,
}

/// Extension to get display name for MessageRole
extension MessageRoleExtension on MessageRole {
  String get displayName {
    switch (this) {
      case MessageRole.user:
        return 'User';
      case MessageRole.assistant:
        return 'Yumi AI';
      case MessageRole.system:
        return 'System';
    }
  }

  /// Returns true if the message is from the user
  bool get isUser => this == MessageRole.user;
  
  /// Returns true if the message is from the assistant
  bool get isAssistant => this == MessageRole.assistant;
} 