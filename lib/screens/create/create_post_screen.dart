import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:nepmeet/helpers/helpers.dart';
import 'package:nepmeet/screens/create/cubit/createpost_cubit.dart';
import 'package:smart_alert_dialog/smart_alert_dialog.dart';

class CreatePostScreen extends StatelessWidget {
  static const String routeName = '/createPost';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
        ),
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) {
            if (state.status == CreatePostStatus.sucess) {
              _formKey.currentState.reset();
              context.read<CreatePostCubit>().reset();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                  content: const Text('Post Created')));
            } else if (state.status == CreatePostStatus.error) {
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
                  GestureDetector(
                    onTap: () => _selectPostImage(
                      context,
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: state.postImage != null
                          ? Image.file(
                              state.postImage,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.image,
                              color: Color(0xff616161),
                              size: 120.0,
                            ),
                    ),
                  ),
                  if (state.status == CreatePostStatus.submitting)
                    const LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Caption',
                                hintStyle: TextStyle(color: Colors.white)),
                            onChanged: (value) => context
                                .read<CreatePostCubit>()
                                .captionChanged(value),
                            validator: (value) => value.trim().isEmpty
                                ? 'Caption cannot be Empty'
                                : null,
                          ),
                          const SizedBox(
                            height: 28.0,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 1.0,
                              primary: Theme.of(context).primaryColor,
                              onPrimary: Colors.white,
                            ),
                            onPressed: () => _submitForm(
                                context,
                                state.postImage,
                                state.status == CreatePostStatus.submitting),
                            child: const Text('Post'),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _selectPostImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
        context: context, cropStyle: CropStyle.rectangle, title: 'Create Post');
    if (pickedFile != null) {
      context.read<CreatePostCubit>().postImageChanged(pickedFile);
    }
  }

  void _submitForm(BuildContext context, File postImage, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<CreatePostCubit>().submit();
    }
  }
}
