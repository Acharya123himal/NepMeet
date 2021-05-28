import 'package:flutter/material.dart';
import 'package:nepmeet/screens/editprofile/editprofilescreen.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  const ProfileButton({
    Key key,
    @required this.isCurrentUser,
    @required this.isFollowing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pushNamed(
              EditProfileScreen.routeName,
              arguments: EditProfileArgs(context: context),
            ),
            child: const Text("Edit Profile"),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: isFollowing
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300],
              onPrimary: isFollowing ? Colors.black : Colors.white,
            ),
            onPressed: () {},
            child: Text(
              isFollowing ? "Unfollow" : "Follow",
              style: TextStyle(fontSize: 16.0),
            ),
          );
  }
}
