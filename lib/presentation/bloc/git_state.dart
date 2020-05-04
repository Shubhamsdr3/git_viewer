
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';

@immutable
abstract class GitState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends GitState {}

class Loading extends GitState {}

class Loaded extends GitState {
  final List<BranchEntity> branchEntityList;

  Loaded(@required this.branchEntityList);

  @override
  List<Object> get props => [branchEntityList];

}

class Error extends GitState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
