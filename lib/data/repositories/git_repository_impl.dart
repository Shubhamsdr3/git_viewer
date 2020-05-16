
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/core/error/exceptions.dart';
import 'package:git_viewer/core/error/failures.dart';
import 'package:git_viewer/data/datasources/git_data_source.dart';
import 'package:git_viewer/data/datasources/git_local_data_source.dart';
import 'package:git_viewer/data/models/git_models.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/domain/repositories/git_repository.dart';
import 'package:git_viewer/core/util/local_storage_util.dart';


// Cache constants

final String PROJECT_ENTITY_LIST_KEY = 'project_entity_list';


class GitRepositoryImpl implements GitRepository{

  final GitRemoteDataSource gitDataSource;
  final GitLocalDataSource gitLocalDataSource;
  final LocalStorageUtil localStorageManager;

  GitRepositoryImpl({@required this.gitDataSource, @required this.localStorageManager, @required this.gitLocalDataSource});


  @override
  Future<Either<Failure, List<BranchEntity>>> getAllBranches() async {
      try{
        List<BranchModel> xl = await gitDataSource.getAllBranches();
        return Right(xl.map((e) => BranchEntity.from(e)).toList());
      } on ServerException{
        return Left(ServerFailure());
      }
  }

  @override
  Future<Either<Failure, List<TreeNodeEntity>>> getChildNodes(TreeNodeEntity treeNodeEntity) async{
    try{
      if(treeNodeEntity.treeNodeList!=null)
        return Right(treeNodeEntity.treeNodeList);

      GithubTreeModel githubTreeModel = await gitDataSource.getGithubTree(treeNodeEntity.id);
      List<TreeNodeEntity> treeNodeEntityList = githubTreeModel.tree.map((e) {
        TreeNodeEntity nodeEntity = TreeNodeEntity.from(e);
        nodeEntity.path = (treeNodeEntity.path??"") + "/"+ nodeEntity.fileName;
        nodeEntity.branch = treeNodeEntity.branch;
        nodeEntity.url = gitDataSource.getGitRootUrl() +"/"+treeNodeEntity.branch+nodeEntity.path;
        return nodeEntity;
      }).toList();
      treeNodeEntityList.sort((a, b){
        return a.isLeafNode ^ b.isLeafNode ? (a.isLeafNode? 1:0): -1*(a.fileName.compareTo(b.fileName));
      });
      return Right(treeNodeEntityList);
    } on ServerException{
      return Left(ServerFailure());
    }

  }

  @override
  Future<Either<Failure, TreeNodeEntity>> getRootNode(BranchEntity branchEntity) async {
    try{
      CommitDetailModel commitDetailModel = await gitDataSource.getCommitDetail(branchEntity.commitId);
      GithubTreeModel githubTreeModel =commitDetailModel.tree;
      TreeNodeEntity nodeEntity = TreeNodeEntity(id: githubTreeModel.sha, isLeafNode: false, fileName: gitDataSource.projectName);
      nodeEntity.branch = branchEntity.name;
      return Right(nodeEntity);
    } on ServerException{
      return Left(ServerFailure());
    }

  }

  @override
  Future<Either<Failure, String>> getRawContent(TreeNodeEntity treeNodeEntity) async {
    try {
      String contentUrl = gitDataSource.getContentUrl(treeNodeEntity.branch, treeNodeEntity.path);
      String content = gitLocalDataSource.getGitContent(contentUrl);
      if(content==null) {
        content = await gitDataSource.getGitContent(
            treeNodeEntity.branch, treeNodeEntity.path);
        gitLocalDataSource.saveGitContent(contentUrl, content);
      }
      return Right(content);
    }  on ServerException{
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjectEntityList() async {
    try {
      List<dynamic> list = localStorageManager.getFromDisk(PROJECT_ENTITY_LIST_KEY);
      print(list);
      if(list==null)
        return Right([]);
      List<ProjectEntity> list2 = list.map((e) => ProjectEntity.fromJson(e)).toList();
      return Right(list2);
    } catch (e, stacktrace){
      print(stacktrace);
      return Left(CacheFailure());
    }

  }

  @override
  Future<Either<Failure, Unit>> saveProjectEntityList(List<ProjectEntity> projectEntityList) async {
    try {
      localStorageManager.saveToDisk(key: PROJECT_ENTITY_LIST_KEY,
          value: projectEntityList.map((e) => e.toJson()).toList());
      return Right(unit);
    }
    catch(e, stacktrace){
      print(stacktrace);
      return Left(CacheFailure());
    }
  }



}