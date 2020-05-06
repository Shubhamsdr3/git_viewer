import 'package:flutter/material.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Bi-directionl Scrollview example'),
      ),
      body: Home()
    )
  ));
}


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(border: Border.all()),
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 30,),
                Expanded(child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(border: Border.all(color: Colors.green)),
                    child: scrollContainer))
              ],
            )
        ),

      ],
    );
  }

  Widget get scrollContainer => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          row, row, row, row
        ],
      ),
    ),
  );

  Widget get row => Row(
    children: <Widget>[
      widget, widget, widget
    ],
  );

  Widget get widget => Container(
      width: 10,
      height: 200,
      decoration: BoxDecoration(border: Border.all()),
  );

}

