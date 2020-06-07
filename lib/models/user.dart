import 'package:flutter/cupertino.dart';

class User {
  final String username;
  final String userId;
  final String email;
  final String avatar;
  final String token;
  User({
    @required this.username,
    @required this.userId,
    @required this.email,
    @required this.avatar,
    this.token,
  });
}
