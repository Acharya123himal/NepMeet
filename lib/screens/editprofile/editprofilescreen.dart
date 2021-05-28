import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:nepmeet/helpers/helpers.dart';
import 'package:smart_alert_dialog/smart_alert_dialog.dart';
import 'package:nepmeet/models/models.dart';
import 'package:nepmeet/repositories/repositories.dart';
import 'package:nepmeet/screens/editprofile/cubit/editprofile_cubit.dart';
import 'package:nepmeet/screens/profile/bloc/profile_bloc.dart';
import 'package:nepmeet/widgets/userprofileimage.dart';

class EditProfileArgs {
  final BuildContext context;
  const EditProfileArgs({
    @required this.context,
  });
}

class EditProfileScreen extends StatelessWidget {
  static const routeName = '/editProfile';

  static Route route(@required EditProfileArgs args) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<EditProfileCubit>(
          create: (_) => EditProfileCubit(
              userRepository: context.read<UserRepository>(),
              storageRepository: context.read<StorageRepository>(),
              profileBloc: args.context.read<ProfileBloc>()),
          child: EditProfileScreen(
            user: args.context.read<ProfileBloc>().state.user,
          )),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final User user;

  EditProfileScreen({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
        ),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state.status == EditProfileStatus.success) {
              Navigator.of(context).pop();
            } else if (state.status == EditProfileStatus.error) {
              showDialog(
                context: context,
                builder: (context) => SmartAlertDialog(
                  title: "Error",
                  content: state.failure.message,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (state.status == EditProfileStatus.submitting)
                    const LinearProgressIndicator(),
                  const SizedBox(height: 32.0),
                  GestureDetector(
                    onTap: () => _selectProfileImage(context),
                    child: UserProfileImage(
                      radius: 40.0,
                      profileImageUrl: user.profileImageUrl,
                      profileImage: state.profileImage,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            initialValue: user.username,
                            decoration: InputDecoration(hintText: 'Username'),
                            onChanged: (value) => context
                                .read<EditProfileCubit>()
                                .usernameChanged(value),
                            validator: (value) => value.trim().isEmpty
                                ? 'Username cannot be empty'
                                : null,
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: user.bio,
                            decoration: InputDecoration(hintText: 'Bio'),
                            onChanged: (value) => context
                                .read<EditProfileCubit>()
                                .bioChanged(value),
                            validator: (value) => value.trim().isEmpty
                                ? 'Bio cannot be empty'
                                : null,
                          ),
                          const SizedBox(height: 28.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 1.0,
                              primary: Theme.of(context).primaryColor,
                              onPrimary: Colors.white,
                            ),
                            onPressed: () => _submitForm(context,
                                state.status == EditProfileStatus.submitting),
                            child: const Text('Update'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _selectProfileImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
        context: context, cropStyle: CropStyle.circle, title: 'Profile Image');
    if (pickedFile != null) {
      context.read<EditProfileCubit>().profileImageChanged(pickedFile);
    }
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<EditProfileCubit>().submit();
    }
  }
}
