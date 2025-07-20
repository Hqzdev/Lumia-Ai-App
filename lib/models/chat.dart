/// Represents a chat conversation
class Chat {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> messageIds;
  final bool isPinned;
  final String? model;

  const Chat({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messageIds,
    this.isPinned = false,
    this.model,
  });

  /// Creates a Chat from JSON
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      messageIds: List<String>.from(json['messageIds'] as List),
      isPinned: json['isPinned'] as bool? ?? false,
      model: json['model'] as String?,
    );
  }

  /// Converts Chat to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'messageIds': messageIds,
      'isPinned': isPinned,
      'model': model,
    };
  }

  /// Creates a copy of Chat with updated fields
  Chat copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? messageIds,
    bool? isPinned,
    String? model,
  }) {
    return Chat(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messageIds: messageIds ?? this.messageIds,
      isPinned: isPinned ?? this.isPinned,
      model: model ?? this.model,
    );
  }

  /// Creates a new chat with the given title
  factory Chat.create({
    required String title,
    String? model,
  }) {
    final now = DateTime.now();
    return Chat(
      id: now.millisecondsSinceEpoch.toString(),
      title: title,
      createdAt: now,
      updatedAt: now,
      messageIds: [],
      model: model,
    );
  }

  /// Adds a message ID to the chat
  Chat addMessage(String messageId) {
    final newMessageIds = List<String>.from(messageIds)..add(messageId);
    return copyWith(
      messageIds: newMessageIds,
      updatedAt: DateTime.now(),
    );
  }

  /// Removes a message ID from the chat
  Chat removeMessage(String messageId) {
    final newMessageIds = List<String>.from(messageIds)..remove(messageId);
    return copyWith(
      messageIds: newMessageIds,
      updatedAt: DateTime.now(),
    );
  }

  /// Toggles the pinned state
  Chat togglePinned() {
    return copyWith(isPinned: !isPinned);
  }

  /// Updates the title
  Chat updateTitle(String newTitle) {
    return copyWith(
      title: newTitle,
      updatedAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Chat && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Chat(id: $id, title: $title, messageCount: ${messageIds.length})';
  }
} 