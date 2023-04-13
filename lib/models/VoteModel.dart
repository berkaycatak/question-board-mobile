class Vote {
  int? id;
  int? eventId;
  int? questionId;
  String? userId;
  int? isAnonim;
  int? actionType;
  String? createdAt;
  String? updatedAt;

  Vote(
      {this.id,
      this.eventId,
      this.questionId,
      this.userId,
      this.isAnonim,
      this.actionType,
      this.createdAt,
      this.updatedAt});

  Vote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['event_id'];
    questionId = json['question_id'];
    userId = json['user_id'];
    isAnonim = json['is_anonim'];
    actionType = json['action_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['event_id'] = this.eventId;
    data['question_id'] = this.questionId;
    data['user_id'] = this.userId;
    data['is_anonim'] = this.isAnonim;
    data['action_type'] = this.actionType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
