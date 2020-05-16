
import 'package:git_viewer/core/util/local_storage_util.dart';

abstract class GitLocalDataSource {
    String getGitContent(String contentUrl);
    void saveGitContent(String contentUrl, String content);
}

class GitLocalDataSourceImpl extends GitLocalDataSource{
  int expiryTimeInSec = 60;

  GitLocalDataSourceImpl({this.localStorageUtil});
  LocalStorageUtil localStorageUtil;


  @override
  String getGitContent(String contentUrl)  {
      return localStorageUtil.getFromDisk(contentUrl);
  }

  @override
  void saveGitContent(String contentUrl, String content)  {
      localStorageUtil.saveToDisk(key: contentUrl, value: content, expiryInSecond: expiryTimeInSec);
  }

}
