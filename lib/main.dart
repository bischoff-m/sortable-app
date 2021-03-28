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
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TextEditingController _textInputController = TextEditingController();
  FocusNode _textInputFocusNode = FocusNode();

  // style constants TODO: what is best practice to store layout constants?
  final double _marginList = 20;
  final double _maxWidthMainList = 600;
  // TODO: use this to set color scheme
  // final ColorScheme colorScheme = Theme.of(context).colorScheme;

  final int _numItems = 20;
  late List<GlobalKey> _items =
      List<GlobalKey>.generate(_numItems, (index) => GlobalKey());

  double getTopMargin(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return max(0, min(_marginList, (screenWidth - _maxWidthMainList) / 2));
  }

  late List<AnimationController> _controllers =
      List<AnimationController>.generate(_numItems, (index) {
    return AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  });

  late List<Animation<Offset>> _animations =
      List<Animation<Offset>>.generate(_numItems, (index) {
    return Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 2.0),
    ).animate(CurvedAnimation(
      parent: _controllers[index],
      curve: Curves.easeInOut,
    ));
  });

  @override
  void dispose() {
    super.dispose();
    _controllers.forEach((c) {
      c.dispose();
    });
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
          constraints: BoxConstraints(maxWidth: _maxWidthMainList),
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
                          contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                          prefixIcon: SizedBox(
                            width: 50,
                            height: 50,
                            child: IconButton(
                              // TODO: implement add function
                              // onPressed: _textInputController.clear,
                              onPressed: () {
                                if (_controllers[4].status ==
                                    AnimationStatus.completed)
                                  _controllers[4].reverse();
                                else
                                  _controllers[4].forward();
                              },
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
                  child: ListView(
                    // TODO: set font size
                    dragStartBehavior: DragStartBehavior.down,
                    children: new List<Widget>.generate(_items.length, (index) {
                      if (index == 5) {
                        return Divider(
                          key: _items[index],
                          height: 96,
                          thickness: 96,
                          color: Colors.transparent,
                        );
                      } else {
                        return SlideTransition(
                          position: _animations[index],
                          child: Dismissible(
                            child: Material(
                              child: ListTile(
                                hoverColor: Colors.black26,
                                title: Text('Item $index'),
                                onTap: () {
                                  RenderBox rb = _items[index]
                                      .currentContext!
                                      .findRenderObject() as RenderBox;
                                  Offset test = rb.localToGlobal(Offset.zero);
                                  dev.log("$test.dx $test.dy");
                                }, // TODO: add tap event for items
                              ),
                              color: Colors.white,
                            ),
                            background: Container(
                              color: Colors.green,
                            ),
                            key: _items[index],
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                _items.remove(index);
                              });
                            },
                          ),
                        );
                      }
                    }),
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
