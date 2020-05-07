import 'package:get_it/get_it.dart';
import 'package:git_viewer/presentation/viewmodels/git_viewer_viewmodels.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/git_data_source.dart';
import 'data/repositories/git_repository_impl.dart';
import 'domain/repositories/git_repository.dart';


final sl = GetIt.instance;

Future<void> init() async {

  // ViewModels
  sl.registerFactory(() => BranchViewModel());
  sl.registerFactory(() => FileViewerViewModel());
  sl.registerFactory(() => FileExplorerViewModel());
  sl.registerFactory(() => GVViewModel());

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
