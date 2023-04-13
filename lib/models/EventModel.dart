import 'package:question_board_mobile/models/PeopleModel.dart';
import 'package:question_board_mobile/models/QuestionModel.dart';

class EventModel {
  int? id;
  String? name;
  String? description;
  String? adress;
  String? date;
  String? time;
  int? createdUserId;
  String? isLive;
  String? createdAt;
  String? updatedAt;
  PeopleModel? creatorUser;
  List<Question>? questions;

  EventModel({
    this.id,
    this.name,
    this.description,
    this.adress,
    this.date,
    this.time,
    this.createdUserId,
    this.isLive,
    this.createdAt,
    this.updatedAt,
    this.creatorUser,
    this.questions,
  });

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    adress = json['adress'];
    date = json['date'];
    time = json['time'];
    createdUserId = json['created_user_id'];
    isLive = json['is_live'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    creatorUser = json['creator_user'] != null
        ? PeopleModel.fromJson(json['creator_user'])
        : null;
    if (json['questions'] != null) {
      questions = <Question>[];
      json['questions'].forEach((v) {
        questions!.add(new Question.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['adress'] = adress;
    data['date'] = date;
    data['time'] = time;
    data['created_user_id'] = createdUserId;
    data['is_live'] = isLive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (creatorUser != null) {
      data['creator_user'] = creatorUser!.toJson();
    }
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
