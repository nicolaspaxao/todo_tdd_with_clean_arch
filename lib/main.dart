import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_tdd_clen_arch/core/services/injection_container.dart';
import 'package:todo_tdd_clen_arch/src/posts/presentation/bloc/post_bloc.dart';
import 'package:todo_tdd_clen_arch/src/posts/presentation/cubit/post_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (BuildContext context) => sl<PostBloc>(),
        ),
        BlocProvider<PostCubit>(
          create: (BuildContext context) => sl<PostCubit>(),
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Hello World!'),
          ),
        ),
      ),
    );
  }
}
