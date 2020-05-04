import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';

@immutable
abstract class FolderEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class GetSubFolderEvent extends FolderEvent{
  final TreeNodeEntity treeNodeEntity;
  GetSubFolderEvent(this.treeNodeEntity);
}