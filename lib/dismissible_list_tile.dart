import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev; // TODO: remove in production

class DismissibleListTile extends StatefulWidget {
  DismissibleListTile({
    required this.key,
    required this.onDismissed,
    this.title,
    this.hoverColor,
    this.onTap,
    this.onIconTap,
  }) : super(key: key);

  final Key key;
  final void Function(DismissDirection)? onDismissed;
  final Widget? title;
  final Color? hoverColor;
  final void Function()? onTap;
  final void Function()? onIconTap;

  @override
  _DismissibleListTileState createState() => _DismissibleListTileState();
}

class _DismissibleListTileState extends State<DismissibleListTile> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      child: Dismissible(
        key: widget.key, // TODO: does this cause problems?
        // child: Material( // if this is uncommented, it will use the ListTile hover effect instead of the custom one
        child: ListTile(
          hoverColor: widget.hoverColor,
          focusColor: widget.hoverColor,
          selectedTileColor: widget.hoverColor,
          title: widget.title,
          // onTap: widget.onTap,
          onTap: () {
            setState(() {
              isHovering = !isHovering;
            });
            dev.log('ishovering swapped: $isHovering');
          },
          leading: SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              icon: Icon(Icons.drag_handle, size: 24),
              onPressed: widget.onIconTap,
            ),
          ),
          // ),
        ),
        onDismissed: widget.onDismissed,
        background: Container(
          color: Colors.green,
        ),
        secondaryBackground: Container(
          color: Colors.red,
        ),
      ),
      // hoverColor: widget.hoverColor,
      // onHover: (didEnter) {
      //   dev.log('hover triggered $didEnter');
      //   setState(() {
      //     this.isHovering = didEnter;
      //   });
      // },
      duration: Duration(milliseconds: 500),
      // curve: Curves.easeInOut,
      color: isHovering ? Colors.black26 : Colors.transparent,
    );
  }
}
