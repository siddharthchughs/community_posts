import 'dart:io';

import 'package:core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/di.dart';
import '../bloc/post_form/post_form_bloc.dart';

class PostFormPage extends StatelessWidget {
  const PostFormPage({super.key, this.postId});
  final String? postId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PostFormBloc>(),
      child: PostFormView(isEditMode: postId != null),
    );
  }
}

class PostFormView extends StatefulWidget {
  const PostFormView({super.key, required this.isEditMode});
  final bool isEditMode;

  @override
  State<PostFormView> createState() => _PostFormState();
}

class _PostFormState extends State<PostFormView> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.always;
  final _titleTextController = TextEditingController();
  final _contentTextController = TextEditingController();
  File? _selectedIage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _selectedIage = File(pickedImage.path);
        });
      }
    } on PlatformException catch (e) {
      print('Failed to pick image !');
    } catch (e) {
      print('Unexpected Error Occured : ${e}');
      showSnackbar(context, message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostFormBloc, PostFormState>(
      listener: (context, state) {
        if (state is PostFormFailure) {
          showSnackbar(context, message: state.failure.message);
        }
        if (state is PostFormSuccess) {
          context.pop();
        }
      },
      builder: (context, state) {
        final isLoading = state is PostFormProgress;

        return Scaffold(
          appBar: AppBar(title: Text('Create Post')),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: _createPostForm(isLoading: isLoading),
                ),
        );
      },
    );
  }

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final title = _titleTextController.text.trim();
    final content = _contentTextController.text.trim();
    context.read<PostFormBloc>().add(
      PostFormSubmittedEvent(
        title: title,
        content: content,
        imageFile: _selectedIage,
      ),
    );
  }

  Widget _buildImagePreview() {
    Widget? imageView;
    if (_selectedIage != null) {
      imageView = Image.file(
        _selectedIage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    if (imageView != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          imageView,
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _selectedIage = null;
                });
              },
              icon: const Icon(Icons.camera),
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue.withValues(alpha: 0.5),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      );
    } else {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              size: 48,
              color: Colors.blueAccent,
            ),
            SizedBox(height: 12),
            Text('Take a pic'),
          ],
        ),
      );
    }
  }

  Widget _createPostForm({required bool isLoading}) {
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        children: [
          Container(
            height: 200,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightGreenAccent.shade100),
              borderRadius: BorderRadius.circular(12),
              color: Colors.amberAccent.shade100,
            ),
            child: InkWell(
              onTap: isLoading ? null : _pickImage,
              child: _buildImagePreview(),
            ),
          ),
          _postform(isLoading: isLoading),
        ],
      ),
    );
  }

  Widget _postform({required bool isLoading}) {
    return Column(
      children: [
        const SizedBox(height: 20),
        TextFormField(
          controller: _titleTextController,
          decoration: const InputDecoration(label: Text('title')),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          enabled: !isLoading,
        ),

        TextFormField(
          controller: _contentTextController,
          decoration: const InputDecoration(
            label: Text('Content'),
            alignLabelWithHint: true,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Please enter atleast 623 characters';
            }
            return null;
          },
          maxLines: 10,
          minLines: 5,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          enabled: !isLoading,
        ),
        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: isLoading ? null : _submit,
          child: isLoading
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.amber,
                  ),
                )
              : const Text('Submit'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }
}
