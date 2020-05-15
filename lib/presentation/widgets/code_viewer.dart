
import 'package:flutter/widgets.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';


class CodeViewer extends StatelessWidget {
  String code;
  String language='dart';
  CodeViewer({this.code, this.language, String filename}){
    if(filename!=null)
      language = filename.split(".").last;
  }

  @override
  Widget build(BuildContext context) {
    return HighlightView(
      // The original code to be highlighted
      code,

      // Specify language
      // It is recommended to give it a value for performance
      language: language,

      // Specify highlight theme
      // All available themes are listed in `themes` folder
      theme: githubTheme,

      // Specify padding
      padding: EdgeInsets.all(12),

      // Specify text style
      textStyle: TextStyle(
        fontFamily: 'My awesome monospace font',
        fontSize: 16,
      ),
    );
  }
}
