import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev; // TODO: remove in production

class FastReorderableList extends StatefulWidget {
  FastReorderableList({
    Key? key,
    required List<Widget> children,
  })   : assert(children.every((Widget w) => w.key != null),
            'All children of this widget must have a key.'),
        itemCount = children.length,
        itemBuilder = ((BuildContext context, int index) => children[index]),
        super(key: key);

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  _FastReorderableListState createState() => _FastReorderableListState();
}

class _FastReorderableListState extends State<FastReorderableList>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;
  late List<GlobalKey> _items;

  @override
  void initState() {
    super.initState();
    _controllers =
        List<AnimationController>.generate(widget.itemCount, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );
    });
    _animations = List<Animation<Offset>>.generate(widget.itemCount, (index) {
      return Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0.0, 2.0),
      ).animate(CurvedAnimation(
        parent: _controllers[index],
        curve: Curves.easeInOut,
      ));
    });
    _items = List<GlobalKey>.generate(widget.itemCount, (index) => GlobalKey());
  }

  @override
  void dispose() {
    super.dispose();
    _controllers.forEach((c) {
      c.dispose();
    });
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final Widget item = widget.itemBuilder(context, index);

    return SlideTransition(
        position: _animations[index],
        child: GestureDetector(
          onTap: () {
            print("Container clicked");
          },
          child: item,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.itemCount,
      itemBuilder: _itemBuilder,
      dragStartBehavior: DragStartBehavior.down,
    );
  }
}

// Dismissible(
//         child: Material(
//           child: ListTile(
//             hoverColor: Colors.black26,
//             title: Text('Item $index'),
//             onTap: () {
//               RenderBox rb = _items[index]
//                   .currentContext!
//                   .findRenderObject() as RenderBox;
//               Offset test = rb.localToGlobal(Offset.zero);
//               dev.log("$test.dx $test.dy");
//             }, // TODO: add tap event for items
//           ),
//           color: Colors.white,
//         ),
//         background: Container(
//           color: Colors.green,
//         ),
//         key: _items[index],
//         onDismissed: (DismissDirection direction) {
//           setState(() {
//             _items.remove(index);
//           });
//         },
//       ),

// return Divider(
//   key: _items[index],
//   height: 96,
//   thickness: 96,
//   color: Colors.transparent,
// );
