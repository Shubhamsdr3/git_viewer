
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/core/error/exceptions.dart';
import 'package:git_viewer/core/error/failures.dart';
import 'package:git_viewer/data/datasources/git_data_source.dart';
import 'package:git_viewer/data/models/git_models.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/domain/repositories/git_repository.dart';

class GitRepositoryImpl implements GitRepository{

  final GitDataSource gitDataSource;

  GitRepositoryImpl({@required this.gitDataSource});


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
      return Right(githubTreeModel.tree.map((e) {
        TreeNodeEntity nodeEntity = TreeNodeEntity.from(e);
        nodeEntity.path = treeNodeEntity.path??"" + "/"+nodeEntity.fileName;
        nodeEntity.branch = treeNodeEntity.branch;
        return nodeEntity;
      }).toList());
    } on ServerException{
      return Left(ServerFailure());
    }

  }

  @override
  Future<Either<Failure, List<TreeNodeEntity>>> getParentNodes(BranchEntity branchEntity) async {
    try{
      CommitDetailModel commitDetailModel = await gitDataSource.getCommitDetail(branchEntity.commitId);
      GithubTreeModel githubTreeModel = await gitDataSource.getGithubTree(commitDetailModel.tree.sha);
      return Right(githubTreeModel.tree.map((e) {
        TreeNodeEntity nodeEntity = TreeNodeEntity.from(e);
        nodeEntity.path = nodeEntity.fileName;
        nodeEntity.branch = branchEntity.name;
        return nodeEntity;
      }).toList());
    } on ServerException{
      return Left(ServerFailure());
    }

  }

  @override
  Future<Either<Failure, String>> getRawContent(TreeNodeEntity treeNodeEntity) async {
    try {
      String content =  await gitDataSource.getGitContent(
          treeNodeEntity.branch, treeNodeEntity.path);
      return Right(content);
    }  on ServerException{
      return Left(ServerFailure());
    }
  }


}