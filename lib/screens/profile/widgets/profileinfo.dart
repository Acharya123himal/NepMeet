import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final String username;
  final String bio;
  final int points;
  const ProfileInfo({
    Key key,
    @required this.username,
    @required this.bio,
    @required this.points,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$username" + " (Points: $points)",
          style: const TextStyle(
            color: Color(0xffe0e0e0),
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          bio,
          style: const TextStyle(
            color: Color(0xffe0e0e0),
            fontSize: 15.0,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
