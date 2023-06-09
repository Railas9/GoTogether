import 'package:flutter/material.dart';

/// This is a row that contains [children] we automatically will
/// nested into Expanded widget.
/// This avoid error when we don't provide a size to one children
class CustomRow extends StatelessWidget {
  const CustomRow({Key? key,  required this.children,
    this.mainAlignementAxis = MainAxisAlignment.center, this.crossAlignementAxis = CrossAxisAlignment.center,
  this.isFirstLastOnBorder = false}) : super(key: key);
  final List<Widget> children;
  final MainAxisAlignment mainAlignementAxis;
  final CrossAxisAlignment crossAlignementAxis;
  final bool isFirstLastOnBorder;

  List<Widget> _buildWidgetList(){
    List<Widget> list = [];
    children.forEach((element) {

      list.add(Expanded(
          flex:1,
          child: Container(
              child: element,
              alignment:
              (isFirstLastOnBorder
                ? (
                  element == children.first
                      ? Alignment.centerLeft
                      : (element == children.last
                      ? Alignment.centerRight
                      : Alignment.center
                  )
                )
                : Alignment.center
              )
              ,
          ),
      ));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      children: _buildWidgetList(),
      mainAxisAlignment: mainAlignementAxis,
      crossAxisAlignment: crossAlignementAxis,
    );
  }
}
