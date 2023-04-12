class PeopleModel {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  int? currentTeamId;
  String? profilePhotoPath;
  String? isAdmin;
  String? createdAt;
  String? updatedAt;
  String? profilePhotoUrl;

  PeopleModel(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.currentTeamId,
      this.profilePhotoPath,
      this.isAdmin,
      this.createdAt,
      this.updatedAt,
      this.profilePhotoUrl});

  PeopleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    currentTeamId = json['current_team_id'];
    profilePhotoPath = json['profile_photo_path'];
    isAdmin = json['is_admin'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profilePhotoUrl = json['profile_photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['current_team_id'] = this.currentTeamId;
    data['profile_photo_path'] = this.profilePhotoPath;
    data['is_admin'] = this.isAdmin;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['profile_photo_url'] = this.profilePhotoUrl;
    return data;
  }
}
