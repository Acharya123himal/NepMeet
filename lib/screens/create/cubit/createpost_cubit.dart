import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:nepmeet/blocs/blocs.dart';
import 'package:nepmeet/models/models.dart';
import 'package:nepmeet/repositories/repositories.dart';
part 'createpost_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  final AuthBloc _authBloc;

  CreatePostCubit(
      {@required PostRepository postRepository,
      @required StorageRepository storageRepository,
      @required AuthBloc authBloc})
      : _postRepository = postRepository,
        _storageRepository = storageRepository,
        _authBloc = authBloc,
        super(CreatePostState.initial());

  void postImageChanged(File file) {
    emit(state.copyWith(
      postImage: file,
      status: CreatePostStatus.initial,
    ));
  }

  void captionChanged(String caption) {
    emit(state.copyWith(
      caption: caption,
      status: CreatePostStatus.initial,
    ));
  }

  void submit() async {
    emit(state.copyWith(
      status: CreatePostStatus.submitting,
    ));

    try {
      final author = User.empty.copyWith(id: _authBloc.state.user.uid);
      final postImageUrl =
          await _storageRepository.uploadPostImage(image: state.postImage);
      final post = Post(
          author: author,
          imageUrl: postImageUrl,
          caption: state.caption,
          likes: 0,
          date: DateTime.now());
      await _postRepository.createPost(post: post);
      emit(state.copyWith(status: CreatePostStatus.sucess));
    } catch (err) {
      emit(state.copyWith(
        status: CreatePostStatus.error,
        failure: const Failure(message: 'We are unable to create post'),
      ));
    }
  }

  void reset() {
    //TODO Point System need to implemented here;
    emit(CreatePostState.initial());
  }
}
