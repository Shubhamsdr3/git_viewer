
import 'package:dartz/dartz.dart';
import 'package:git_viewer/core/error/failures.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';

abstract class GitRepository{
  Future<Either<Failure, List<BranchEntity>>> getAllBranches();
  Future<Either<Failure, List<TreeNodeEntity>>> getChildNodes(TreeNodeEntity treeNodeEntity);
  Future<Either<Failure, List<TreeNodeEntity>>> getParentNodes(BranchEntity branchEntity);
  Future<Either<Failure, String>> getRawContent(TreeNodeEntity treeNodeEntity);
}