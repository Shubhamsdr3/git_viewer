import 'package:get_it/get_it.dart';
import 'package:git_viewer/presentation/dialog_manager/home_page_dialog_manager.dart';
import 'package:git_viewer/presentation/viewmodels/file_explorer_view_model.dart';
import 'package:git_viewer/presentation/viewmodels/file_viewer_view_model.dart';
import 'package:git_viewer/presentation/viewmodels/project_viewer_viewmodels.dart';
import 'package:git_viewer/presentation/viewmodels/home_view_model.dart';
import 'package:http/http.dart' as http;

import 'core/util/local_storage_util.dart';
import 'data/datasources/git_data_source.dart';
import 'data/datasources/git_local_data_source.dart';
import 'data/repositories/git_repository_impl.dart';
import 'domain/repositories/git_repository.dart';


final sl = GetIt.instance;

Future<void> init() async {

  // Manager
  var instance = await LocalStorageUtil.getInstance();
  sl.registerSingleton<LocalStorageUtil>(instance);

  // ViewModels
  sl.registerFactory(() => BranchViewModel());
  sl.registerFactory(() => FileViewerViewModel());
  sl.registerFactory(() => FileExplorerViewModel());
  sl.registerFactory(() => ProjectViewerViewModel());
  sl.registerFactory(() => HomeViewModel());

  // Services
  sl.registerLazySingleton(() => HomePageDialogService());

  // Repository
  sl.registerLazySingleton<GitRepository>(
    () => GitRepositoryImpl(
      gitDataSource: sl(),
      localStorageManager: sl(),
      gitLocalDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<GitRemoteDataSource>(
    () => GitRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<GitLocalDataSource>(
        () => GitLocalDataSourceImpl(localStorageUtil: sl()),
  );

  //! External
  sl.registerLazySingleton(() => http.Client());
}
