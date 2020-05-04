import 'package:get_it/get_it.dart';
import 'package:git_viewer/presentation/bloc/fileviewer_bloc/fileviewer_bloc.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/git_data_source.dart';
import 'data/repositories/git_repository_impl.dart';
import 'domain/usecases/get_raw_content.dart';
import 'presentation/bloc/folder_bloc/folder_bloc.dart';
import 'presentation/bloc/git_bloc.dart';
import 'domain/repositories/git_repository.dart';
import 'domain/usecases/get_all_branches.dart';
import 'domain/usecases/get_subfolders.dart';


final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory(
    () => GitBloc(
      getAllBranches: sl(),
    ),
  );

  sl.registerFactory(
        () => FileViewerBloc(
          getRawContent: sl(),
    ),
  );

  sl.registerFactory(
        () => FolderBloc(
          getSubFolders: sl(),
    ),
  );


  // Use cases
  sl.registerLazySingleton(() => GetAllBranches(sl()));
  sl.registerLazySingleton(() => GetSubFolders(sl()));
  sl.registerLazySingleton(() => GetRawContent(sl()));

  // Repository
  sl.registerLazySingleton<GitRepository>(
    () => GitRepositoryImpl(
      gitDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<GitDataSource>(
    () => GitDataSourceImpl(client: sl()),
  );

  //! External
  sl.registerLazySingleton(() => http.Client());
}
