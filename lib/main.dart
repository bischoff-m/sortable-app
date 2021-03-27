import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:developer' as dev; // TODO: remove in production

void main() {
  runApp(SortableApp());
}

class SortableApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sortable',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _textInputController = TextEditingController();
  FocusNode _textInputFocusNode = FocusNode();

  // style constants TODO: what is best practice to store layout constants?
  final double marginList = 20;
  final double maxWidthMainList = 600;
  // TODO: use this to set color scheme
  // final ColorScheme colorScheme = Theme.of(context).colorScheme;

  List<int> _items = List<int>.generate(20, (index) => index);

  double getTopMargin(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return max(0, min(marginList, (screenWidth - maxWidthMainList) / 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Hier der Name der Liste'),
      ),
      body: Center(
        child: ConstrainedBox(
          // main container with width constraint
          constraints: BoxConstraints(maxWidth: maxWidthMainList),
          child: Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: getTopMargin(context)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        // input text field to enter items
                        controller: _textInputController,
                        focusNode: _textInputFocusNode,
                        autofocus: true,
                        onSubmitted: (itemName) {
                          // TODO: implement add function
                          dev.log(itemName);
                          _textInputController.clear();
                          _textInputFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'Add Item',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(0, 18, 0, 12),
                          prefixIcon: SizedBox(
                            width: 50,
                            height: 50,
                            child: IconButton(
                              // TODO: implement add function
                              onPressed: _textInputController.clear,
                              icon: Icon(Icons.add),
                            ),
                          ),
                          suffixIcon: SizedBox(
                            width: 50,
                            height: 50,
                            child: IconButton(
                              onPressed: _textInputController.clear,
                              icon: Icon(Icons.clear),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.black,
                ),
                Expanded(
                  child: ReorderableListView(
                    // TODO: set font size
                    buildDefaultDragHandles: false,
                    dragStartBehavior: DragStartBehavior.down,
                    children: new Iterable<int>.generate(10).map((index) {
                      if (index == 5) {
                        return Divider(
                          key: ValueKey<int>(_items[index]),
                          height: 128,
                          thickness: 128,
                          color: Colors.black,
                        );
                      } else {
                        return Dismissible(
                          background: Container(
                            color: Colors.green,
                          ),
                          key: ValueKey<int>(_items[index]),
                          onDismissed: (DismissDirection direction) {
                            setState(() {
                              _items.remove(index);
                            });
                          },
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: ReorderableDragStartListener(
                                    index: index,
                                    child: Icon(Icons.drag_handle, size: 30),
                                  ),
                                ),
                                Text('Item ${_items[index]}'),
                              ],
                            ),
                          ),
                        );
                      }
                    }).toList(),
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final int item = _items.removeAt(oldIndex);
                        _items.insert(newIndex, item);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
