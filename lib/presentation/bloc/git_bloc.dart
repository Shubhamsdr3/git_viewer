import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_viewer/core/usecases/usecase.dart';
import 'package:git_viewer/domain/usecases/get_all_branches.dart';

import 'git_event.dart';
import 'git_state.dart';

class GitBloc extends Bloc<GitEvent, GitState> {

  final GetAllBranches getAllBranches;

  @override
  GitState get initialState => Empty();

  GitBloc({@required GetAllBranches getAllBranches}):
        assert(getAllBranches!=null),
        getAllBranches=getAllBranches;

  @override
  Stream<GitState> mapEventToState(GitEvent event) async* {
    if(event is GetAllBranchEvent){
      yield Loading();
      final failureOrBranches = await getAllBranches(NoParams());
      yield failureOrBranches.fold(
          (failure) => Error(message: "Error loading branches"),
          (branchList) => Loaded(branchList)
      );
    }
  }

}