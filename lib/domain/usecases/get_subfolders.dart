import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:git_viewer/core/error/failures.dart';
import 'package:git_viewer/core/usecases/usecase.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/domain/repositories/git_repository.dart';

class GetSubFolders implements UseCase<List<TreeNodeEntity>, Params>{

  final GitRepository repository;

  GetSubFolders(this.repository);

  @override
  Future<Either<Failure, List<TreeNodeEntity>>> call(Params params) async{
    try {
      dynamic data = await repository.getChildNodes(params.treeNodeEntity);
      return data;
    }catch(e){
      return Left(ServerFailure());
    }

  }

}

class Params extends Equatable {
  final TreeNodeEntity treeNodeEntity;

  Params({@required this.treeNodeEntity});

  @override
  List<Object> get props => [treeNodeEntity];
}
