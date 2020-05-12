import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_viewer/domain/entities/git_entities.dart';
import 'package:git_viewer/presentation/viewmodels/project_viewer_viewmodels.dart';
import 'package:git_viewer/presentation/widgets/drop_down.dart';
import 'package:provider/provider.dart';

class BranchSelectorView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
      BranchViewModel model = Provider.of<BranchViewModel>(context);
      if(model.branchList!=null)
        return dropDown(model.branchList, model.selectedBranch);
      return Container();

  }

  Widget dropDown(List<BranchEntity> branchList, BranchEntity selectedBranch){
    DropDownItemModel selectedItem;
    List items = branchList.map((e) {
      DropDownItemModel dropDownItemModel = DropDownItemModel(id: e, value: e.name, isDivider: false);
      if(e == selectedBranch){
        selectedItem = dropDownItemModel;
      }
      return dropDownItemModel;
    } ).toList();
    return Builder(
        builder: (context) {
          return DropDown(items: items, dropDownSelected: (e){
            Provider.of<BranchViewModel>(context, listen: false).selectedBranch = e.id;
          }, selection: selectedItem, color: Colors.black,);
        }
    );
  }


}