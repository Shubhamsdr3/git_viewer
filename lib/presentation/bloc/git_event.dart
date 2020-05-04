import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class GitEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class GetAllBranchEvent extends GitEvent{

}