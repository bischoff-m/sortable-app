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

  FastReorderableList.builder({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    // required this.onReorder,
  }) : super(key: key);

  int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  _FastReorderableListState createState() => _FastReorderableListState();
}

class _FastReorderableListState extends State<FastReorderableList> {
  // this list keeps track of which separator between the items is expanded
  late List<bool> _expanded;
  int _curExpanded = 0;

  @override
  void initState() {
    super.initState();
    _expanded = List<bool>.filled(widget.itemCount + 1, false);
    _expanded[_curExpanded] = true;
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final int halfIndex = index ~/ 2;
    if (index.isOdd) {
      // place list items on all odd indices
      final Widget item = widget.itemBuilder(context, halfIndex);
      return GestureDetector(
        child: item,
        onDoubleTap: () {
          dev.log('Animating change');
          setState(() {
            _expanded[_curExpanded] = false;
            _curExpanded = (_curExpanded + 1) % _expanded.length;
            _expanded[_curExpanded] = true;
          });
        },
      );
    } else {
      // place spacer on all even indices
      // dev.log('is eval');
      return AnimatedContainer(
        height: _expanded[halfIndex] ? 96 : 0,
        color: _expanded[halfIndex] ? Colors.red : Colors.blue,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        child: Container(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    dev.log('Item Count: ${widget.itemCount}');
    return ListView.builder(
      itemCount: widget.itemCount * 2 + 1,
      itemBuilder: _itemBuilder,
      dragStartBehavior: DragStartBehavior.down,
      // TODO: add padding on top and botton, so user can insert item there
      // padding: EdgeInsets.fromLTRB(0, 100, 0, 200),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   dev.log('Item Count: ${widget.itemCount}');
  //   return ListView.builder(
  //     itemCount: widget.itemCount * 2 + 1,
  //     itemBuilder: _itemBuilder,
  //     dragStartBehavior: DragStartBehavior.down,
  //     // TODO: add padding on top and botton, so user can insert item there
  //     // padding: EdgeInsets.fromLTRB(0, 100, 0, 200),
  //   );
  // }
}

// TODO: grab global coordinates of listtile from here
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
