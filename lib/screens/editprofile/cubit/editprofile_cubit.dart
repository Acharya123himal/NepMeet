import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:nepmeet/models/models.dart';
import 'package:nepmeet/repositories/repositories.dart';
import 'package:nepmeet/screens/profile/bloc/profile_bloc.dart';

part 'editprofile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;
  final ProfileBloc _profileBloc;

  EditProfileCubit({
    @required UserRepository userRepository,
    @required StorageRepository storageRepository,
    @required ProfileBloc profileBloc,
  })  : _userRepository = userRepository,
        _storageRepository = storageRepository,
        _profileBloc = profileBloc,
        super(EditProfileState.initial()) {
    final user = _profileBloc.state.user;
    emit(state.copyWith(username: user.username, bio: user.bio));
  }

  void profileImageChanged(File image) {
    emit(
        state.copyWith(profileImage: image, status: EditProfileStatus.initial));
  }

  void usernameChanged(String username) {
    emit(state.copyWith(username: username, status: EditProfileStatus.initial));
  }

  void bioChanged(String bio) {
    emit(state.copyWith(bio: bio, status: EditProfileStatus.initial));
  }

  void submit() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      final user = _profileBloc.state.user;
      var profileImageUrl = user.profileImageUrl;
      if (state.profileImage != null) {
        profileImageUrl = await _storageRepository.uploadProfileImage(
          url: profileImageUrl,
          image: state.profileImage,
        );
      }
      final updateUser = user.copyWith(
        username: state.username,
        bio: state.bio,
        profileImageUrl: profileImageUrl,
      );

      await _userRepository.updateUser(user: updateUser);
      _profileBloc.add(ProfileLoadUser(userId: user.id));
      emit(state.copyWith(status: EditProfileStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: EditProfileStatus.error,
          failure: const Failure(
            message: 'We were unable to update your Profile.',
          ),
        ),
      );
    }
  }
}
