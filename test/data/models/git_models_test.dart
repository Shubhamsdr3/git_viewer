import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:git_viewer/data/models/git_models.dart';

import '../../fixtures/fixture_reader.dart';


void main() {

  CommitModel commitModel = CommitModel(sha: "122");
  BranchModel branchModel = BranchModel(name: "master", commit: commitModel);

  GithubTreeModel githubTreeModel = GithubTreeModel(sha: "123");
  CommitDetailModel commitDetailModel = CommitDetailModel(tree: githubTreeModel);

  GithubTreeNodeModel githubTreeNodeModel = GithubTreeNodeModel(path: ".gitignore",
      type: "blob", sha: "123");

  GithubTreeNodeModel githubTreeNodeModel2 = GithubTreeNodeModel(path: "lib",
      type: "tree", sha: "124");

  GithubTreeModel githubTreeDetailModel = GithubTreeModel(sha: "111",
      tree: [githubTreeNodeModel, githubTreeNodeModel2]);

  group('fromJson', ()
  {
    test(
      'testing conversion of json to Branch Model which we are expecting to get as a response',
          () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(
            fixture('branch.json'));
        // act
        final result = BranchModel.fromJson(jsonMap);
        // assert
        expect(result, branchModel);
      },
    );

    test(
      'testing conversion of json to commitDetailModel which we are expecting to get as a response from commit detail api',
          () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(
            fixture('commit_detail.json'));
        // act
        final result = CommitDetailModel.fromJson(jsonMap);
        // assert
        expect(result, commitDetailModel);
      },
    );

    test(
      'testing conversion of json to Githuh tree which we are expecting to get as a response from treeapi',
          () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('tree_detail.json'));
        // act
        final result = GithubTreeModel.fromJson(jsonMap);
        // assert
        expect(result, githubTreeDetailModel);
      },
    );


  });
}

