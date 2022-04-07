import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  const CustomRow({Key? key,  required this.children}) : super(key: key);
  final List<Widget> children;

  List<Widget> _buildWidgetList(){
    List<Widget> list = [];
    children.forEach((element) {
      list.add(Expanded(
          flex:1,
          child:element));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildWidgetList(),
    );
  }
}
