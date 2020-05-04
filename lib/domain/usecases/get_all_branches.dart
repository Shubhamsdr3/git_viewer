import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:git_viewer/core/error/failures.dart';
import 'package:git_viewer/core/usecases/usecase.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/domain/repositories/git_repository.dart';

class GetAllBranches implements UseCase<List<BranchEntity>, NoParams>{

  final GitRepository repository;

  GetAllBranches(this.repository);

  @override
  Future<Either<Failure, List<BranchEntity>>> call(NoParams params) async{
    return await repository.getAllBranches();
  }

}
