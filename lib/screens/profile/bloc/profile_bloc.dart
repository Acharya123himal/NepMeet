import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:nepmeet/blocs/blocs.dart';
import 'package:nepmeet/models/models.dart';
import 'package:nepmeet/repositories/repositories.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final AuthBloc _authBloc;

  StreamSubscription<List<Future<Post>>> _postSubscription;

  ProfileBloc({
    @required UserRepository userRepository,
    @required PostRepository postRepository,
    @required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        _postRepository = postRepository,
        _authBloc = authBloc,
        super(ProfileState.initial());

  @override
  Future<void> close() {
    _postSubscription.cancel();
    return super.close();
  }

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileLoadUser) {
      yield* _mapProfileLoadUserToState(event);
    } else if (event is ProfileToggleGridView) {
      yield* _mapProfileToggleGridViewToState(event);
    } else if (event is ProfileUpdatePosts) {
      yield* _mapProfileUpdatePostsToState(event);
    }
  }

  Stream<ProfileState> _mapProfileLoadUserToState(
    ProfileLoadUser event,
  ) async* {
    yield state.copyWith(status: ProfileStatus.loading);
    try {
      final user = await _userRepository.getUserWithId(userId: event.userId);
      final isCurrentUser = _authBloc.state.user.uid == event.userId;

      _postSubscription?.cancel();
      _postSubscription = _postRepository
          .getUserPost(userId: event.userId)
          .listen((posts) async {
        final allPosts = await Future.wait(posts);
        add(ProfileUpdatePosts(allPosts));
      });

      yield state.copyWith(
          user: user,
          isCurrentUser: isCurrentUser,
          status: ProfileStatus.loaded);
    } catch (e) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: Failure(message: 'We are unable to load this profile'),
      );
    }
  }

  Stream<ProfileState> _mapProfileToggleGridViewToState(
      ProfileToggleGridView event) async* {
    yield state.copyWith(isGridView: event.isGridView);
  }

  Stream<ProfileState> _mapProfileUpdatePostsToState(
      ProfileUpdatePosts event) async* {
    yield state.copyWith(posts: event.posts);
  }
}