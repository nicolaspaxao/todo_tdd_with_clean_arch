import 'package:get_it/get_it.dart';
import 'package:todo_tdd_clen_arch/src/posts/data/datasources/post_remote_datasource.dart';
import 'package:todo_tdd_clen_arch/src/posts/data/repos/post_repo_impl.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/repos/post_repo.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/usecases/create_post.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/usecases/get_posts.dart';
import 'package:todo_tdd_clen_arch/src/posts/presentation/bloc/post_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:todo_tdd_clen_arch/src/posts/presentation/cubit/post_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl
    //App Logic
    ..registerFactory(() => PostBloc(createPost: sl(), getPosts: sl()))
    ..registerFactory(() => PostCubit(createPost: sl(), getPosts: sl()))

    //Use Cases
    ..registerLazySingleton(() => CreatePost(repo: sl()))
    ..registerLazySingleton(() => GetPosts(repo: sl()))

    //Repos
    ..registerLazySingleton<PostRepo>(() => PostRepoImpl(datasource: sl()))

    //Datasource
    ..registerLazySingleton<PostRemoteDataSource>(
        () => PostRemoteDataSourceImpl(client: sl()))

    //Http Client
    ..registerLazySingleton(() => http.Client);
}
