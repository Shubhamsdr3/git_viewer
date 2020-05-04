import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';

@immutable
abstract class FileViewerEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class GetRawContentEvent extends FileViewerEvent{
  final TreeNodeEntity treeNodeEntity;
  GetRawContentEvent(this.treeNodeEntity);
}