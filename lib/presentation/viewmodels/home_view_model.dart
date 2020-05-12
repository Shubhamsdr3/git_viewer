import 'package:git_viewer/core/viewmodels/base_view_model.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/domain/repositories/git_repository.dart';
import 'package:git_viewer/presentation/dialog_manager/home_page_dialog_manager.dart';

import '../../injection_container.dart';

class HomeViewModel extends BaseViewModel{

  final HomePageDialogService _dialogService = sl<HomePageDialogService>();
  GitRepository gitRepository = sl<GitRepository>();

  List<ProjectEntity> _projectList = [];

  Future getProjectList() async{
    setBusy(true);
    (await gitRepository.getProjectEntityList()).fold(
            (l) {
          print("Cache Failure");
        },
            (r) {
          _projectList = r;
          print("getProjectList");
          print(_projectList);
        }
    );
    setBusy(false);
  }

  Future addProject() async {
    setBusy(true);
    var dialogResult = await _dialogService.showGitRepoChangeDialog();
    if (dialogResult.confirmed) {
      var entity = ProjectEntity(userName: dialogResult.userName, projectName: dialogResult.projectName);
      if(!_projectList.contains(entity)) {
        _projectList.add(entity);
        (await gitRepository.saveProjectEntityList(_projectList));
      }
    }
    setBusy(false);
  }


  List<ProjectEntity> get projectList => _projectList;

}