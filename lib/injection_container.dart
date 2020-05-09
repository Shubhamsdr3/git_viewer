import 'package:get_it/get_it.dart';
import 'package:git_viewer/presentation/manager/local_storage_manager.dart';
import 'package:git_viewer/presentation/viewmodels/git_viewer_viewmodels.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/git_data_source.dart';
import 'data/repositories/git_repository_impl.dart';
import 'domain/repositories/git_repository.dart';
import 'domain/services/dialog_service.dart';


final sl = GetIt.instance;

Future<void> init() async {

  // Manager
  var instance = await LocalStorageManager.getInstance();
  sl.registerSingleton<LocalStorageManager>(instance);

  // ViewModels
  sl.registerFactory(() => BranchViewModel());
  sl.registerFactory(() => FileViewerViewModel());
  sl.registerFactory(() => FileExplorerViewModel());
  sl.registerFactory(() => GVViewModel());
  sl.registerFactory(() => HomeViewModel());

  // Services
  sl.registerLazySingleton(() => DialogService());

  // Repository
  sl.registerLazySingleton<GitRepository>(
    () => GitRepositoryImpl(
      gitDataSource: sl(),
      localStorageManager: sl()
    ),
  );

  // Data sources
  sl.registerLazySingleton<GitDataSource>(
    () => GitDataSourceImpl(client: sl()),
  );

  //! External
  sl.registerLazySingleton(() => http.Client());
}
