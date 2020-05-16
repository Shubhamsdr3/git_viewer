
import 'dart:convert';

import 'package:git_viewer/core/error/exceptions.dart';
import 'package:git_viewer/data/models/git_models.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';


abstract class GitRemoteDataSource {

  String userName;
  String projectName;
  void updateGitInfo(String userName, String projectName);

  Future<List<BranchModel>> getAllBranches();
  Future<CommitDetailModel> getCommitDetail(String commitId);
  Future<GithubTreeModel> getGithubTree(String parentTreeId);
  Future<String> getGitContent(String branchName, String filePath);
  String getGitRootUrl();
  String getContentUrl(String branchName, String filePath);
}

class GitRemoteDataSourceImpl implements GitRemoteDataSource{

  @override
  String projectName = 'digyed_reader';

  @override
  String userName = 'manishag777';

  String baseUrl = 'https://api.github.com/repos/manishag777/digyed_reader';
  String contentUrl = 'https://raw.githubusercontent.com/manishag777/digyed_reader';

  void updateGitInfo(String userName, String projectName){
    this.userName=userName;
    this.projectName=projectName;
    baseUrl = 'https://api.github.com/repos/$userName/$projectName';
    contentUrl = 'https://raw.githubusercontent.com/$userName/$projectName';
  }

  @override
  String getGitRootUrl() {
    return "https://github.com/$userName/$projectName/blob";
  }

  final http.Client client;

  GitRemoteDataSourceImpl({@required this.client});

  dynamic _fetchDataFromApi(String url, Function(String) decoder) async {
    dynamic header = {
      'Content-Type': 'application/json'
    };
    final response = await client.get(
        url,
        headers: header
    );
    if (response.statusCode == 200) {
      try {
        return decoder(response.body);
      } catch (e){
        throw ServerException();
      }
    } else {
      throw ServerException();
    }

  }

  dynamic _fetchStringDataFromApi(String url, Function(String) decoder) async {
    final response = await client.get(
        url,
    );
    if (response.statusCode == 200) {
      try {
        return decoder(response.body);
      } catch (e){
        throw ServerException();
      }
    } else {
      throw ServerException();
    }

  }


  @override
  Future<List<BranchModel>> getAllBranches() async{
    String url = baseUrl+ "/branches";
    Function decoder = (String body) {
      List<dynamic> _branchModelList = json.decode(body);
      return _branchModelList.map((b) => BranchModel.fromJson(b)).toList();
    };
    return await _fetchDataFromApi(url, decoder);
  }

  @override
  Future<CommitDetailModel> getCommitDetail(String commitId) async {
    String url = baseUrl+"/commits/"+commitId;
    Function decoder = (String body){
        return CommitDetailModel.fromJson(json.decode(body)['commit']);
    };
    return await _fetchDataFromApi(url, decoder);
  }

  @override
  Future<GithubTreeModel> getGithubTree(String parentTreeId) async{
    String url = baseUrl+"/git/trees/"+parentTreeId;
    Function decoder = (String body){
      return GithubTreeModel.fromJson(json.decode(body));
    };
    dynamic data =  await _fetchDataFromApi(url, decoder);
    return data;
  }

  String getContentUrl(String branchName, String filePath){
    return contentUrl + '/' + branchName + filePath;
  }

  @override
  Future<String> getGitContent(String branchName, String filePath) async {
    String url = contentUrl + '/' + branchName + filePath;
    try {
      Function decoder = (String body) {
        return body;
      };
      String rawContent = await _fetchStringDataFromApi(url, decoder);
      return rawContent;
    }
    catch (e) {
      return "Error Content";
    }
  }


}
