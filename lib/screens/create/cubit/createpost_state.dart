part of 'createpost_cubit.dart';

enum CreatePostStatus { initial, submitting, sucess, error }

class CreatePostState extends Equatable {
  final File postImage;
  final String caption;
  final CreatePostStatus status;
  final Failure failure;

  const CreatePostState(
    @required this.postImage,
    @required this.caption,
    @required this.status,
    @required this.failure,
  );

  factory CreatePostState.initial() {
    return const CreatePostState(
      null,
      '',
      CreatePostStatus.initial,
      Failure(),
    );
  }

  @override
  List<Object> get props => [
        postImage,
        caption,
        status,
        failure,
      ];

  CreatePostState copyWith({
    File postImage,
    String caption,
    CreatePostStatus status,
    Failure failure,
  }) {
    return CreatePostState(
      postImage ?? this.postImage,
      caption ?? this.caption,
      status ?? this.status,
      failure ?? this.failure,
    );
  }
}
