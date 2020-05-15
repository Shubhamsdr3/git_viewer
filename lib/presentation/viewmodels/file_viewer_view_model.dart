import 'package:git_viewer/core/viewmodels/base_view_model.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/domain/repositories/git_repository.dart';

import '../../injection_container.dart';

class FileViewerViewModel extends BaseViewModel{
  GitRepository gitRepository = sl<GitRepository>();

  String _content;
  FileViewerViewModel();
  TreeNodeEntity nodeEntity;

  String get content => _content;


  Future fetchContent(TreeNodeEntity nodeEntity) async {
    this.nodeEntity=nodeEntity;
    setBusy(true);
    final failureOrContent = await gitRepository.getRawContent(nodeEntity);
    failureOrContent.fold(
            (l) {_content = "Error loading the content";},
            (r) {_content = r;}
    );
    setBusy(false);
    notifyListeners();
  }
}