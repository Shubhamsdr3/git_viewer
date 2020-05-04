
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';

@immutable
abstract class FileViewerState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends FileViewerState {}

class Loading extends FileViewerState {}

class Loaded extends FileViewerState {
  final String content;

  Loaded(@required this.content);

  @override
  List<Object> get props => [content];

}

class Error extends FileViewerState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
