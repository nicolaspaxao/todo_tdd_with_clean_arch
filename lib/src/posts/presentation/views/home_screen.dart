import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_tdd_clen_arch/src/posts/presentation/bloc/post_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void getPost() {
    context.read<PostBloc>().add(const GetPostsEvent());
  }

  @override
  void initState() {
    getPost();
    super.initState();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is PostCreated) {
          getPost();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Post - JsonPlaceholder'),
          ),
          body: state is GettingPosts
              ? const Center(child: CircularProgressIndicator())
              : state is CreatingPost
                  ? const Center(child: CircularProgressIndicator())
                  : state is PostLoaded
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.posts.length,
                          itemBuilder: (_, index) {
                            final post = state.posts[index];
                            return ListTile(
                              title: Text(post.title),
                              subtitle: Text(post.body),
                            );
                          },
                        )
                      : const SizedBox.shrink(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return Dialog(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'Criar uma postagem',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          TextFormField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: 'Título',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: bodyController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: 'Contéudo',
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<PostBloc>().add(
                                      CreatePostEvent(
                                        userId: 1,
                                        title: titleController.text,
                                        body: bodyController.text,
                                      ),
                                    );
                                Navigator.of(context).pop();
                                titleController.clear();
                                bodyController.clear();
                              },
                              child: const Text('Salvar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            label: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
