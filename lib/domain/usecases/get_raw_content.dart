import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:git_viewer/core/error/failures.dart';
import 'package:git_viewer/core/usecases/usecase.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/domain/repositories/git_repository.dart';

class GetRawContent implements UseCase<String, Params>{

  final GitRepository repository;

  GetRawContent(this.repository);

  @override
  Future<Either<Failure, String>> call(Params params) async{
    print("pushing get raw content");
    return await repository.getRawContent(params.treeNodeEntity);
  }

}

class Params extends Equatable {
  final TreeNodeEntity treeNodeEntity;

  Params({@required this.treeNodeEntity});

  @override
  List<Object> get props => [treeNodeEntity];
}
