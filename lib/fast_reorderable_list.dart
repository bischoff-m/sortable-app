import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev; // TODO: remove in production

/*
NOTE: 
Modifiying the number of items in the list while
in reordering mode causes inconsitency.
No bug fix is implemented because its not relevant for my use case.
*/

/*
- override IndexedWidgetBuilder with {context, index, callback}
- update itemBuilder and _itemBuilder
- update at FastReorderableList.builder()
*/

typedef _ListItemBuilder = Widget Function(
    BuildContext context, int index, Function(int index) startReorder);

class FastReorderableList extends StatefulWidget {
  FastReorderableList.builder({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    // required this.onReorderDone,
  }) : super(key: key);

  final int itemCount;
  final _ListItemBuilder itemBuilder;

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
    /*
    TODO:
    - wrap item in inkwell with onHover handler
    - track hover status for each item
    - apply color if hover
    - wrap item in animatedcontainer to get color animation
    - outsource row with icon and item
    - handle onPressed of button using function that gets called
    */
    final Widget item = widget.itemBuilder(context, index, (itemIndex) {
      dev.log('Animating change. Item clicked: $itemIndex');
      setState(() {
        _expanded[_curExpanded] = false;
        _curExpanded = (_curExpanded + 1) % _expanded.length;
        _expanded[_curExpanded] = true;
      });
    });
    return item;
    // return Row(
    //   children: [
    //     SizedBox(
    //       width: 48,
    //       height: 48,
    //       child: IconButton(
    //         icon: Icon(Icons.drag_handle, size: 24),
    //         onPressed: () {
    //           dev.log('Animating change');
    //           setState(() {
    //             _expanded[_curExpanded] = false;
    //             _curExpanded = (_curExpanded + 1) % _expanded.length;
    //             _expanded[_curExpanded] = true;
    //           });
    //         },
    //       ),
    //     ),
    //     Expanded(child: item)
    //   ],
    // );
  }

  Widget _spacerBuilder(BuildContext context, int index) {
    return AnimatedContainer(
      height: _expanded[index] ? 96 : 0,
      color: _expanded[index] ? Colors.red : Colors.blue,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.itemCount * 2 + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index.isOdd)
          return _itemBuilder(context, index ~/ 2);
        else
          return _spacerBuilder(context, index ~/ 2);
      },
      dragStartBehavior: DragStartBehavior.down,
      // TODO: add padding on top and botton, so user can insert item there
      // padding: EdgeInsets.fromLTRB(0, 100, 0, 200),
    );
  }
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
