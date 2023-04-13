import 'package:question_board_mobile/models/PeopleModel.dart';
import 'package:question_board_mobile/models/VoteModel.dart';

class Question {
  int? id;
  String? question;
  String? name;
  int? eventId;
  int? createdUserId;
  int? isAnonim;
  int? isAnswered;
  int? isLive;
  String? createdAt;
  String? updatedAt;
  PeopleModel? user;
  List<Vote>? votes;

  Question(
      {this.id,
      this.question,
      this.name,
      this.eventId,
      this.createdUserId,
      this.isAnonim,
      this.isAnswered,
      this.isLive,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.votes});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    name = json['name'];
    eventId = json['event_id'];
    createdUserId = json['created_user_id'];
    isAnonim = json['is_anonim'];
    isAnswered = json['is_answered'];
    isLive = json['is_live'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new PeopleModel.fromJson(json['user']) : null;
    if (json['votes'] != null) {
      votes = <Vote>[];
      json['votes'].forEach((v) {
        votes!.add(new Vote.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['name'] = this.name;
    data['event_id'] = this.eventId;
    data['created_user_id'] = this.createdUserId;
    data['is_anonim'] = this.isAnonim;
    data['is_answered'] = this.isAnswered;
    data['is_live'] = this.isLive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.votes != null) {
      data['votes'] = this.votes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
