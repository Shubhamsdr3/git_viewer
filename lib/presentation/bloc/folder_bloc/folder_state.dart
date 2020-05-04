
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';

@immutable
abstract class FolderState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends FolderState {}

class Loading extends FolderState {}

class Loaded extends FolderState {
  final List<TreeNodeEntity> treeNodeEntityList;

  Loaded(@required this.treeNodeEntityList);

  @override
  List<Object> get props => [treeNodeEntityList];

}

class Error extends FolderState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
