import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:developer' as dev; // TODO: remove in production
import 'fast_reorderable_list.dart';

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

  List<String> _items = List<String>.generate(20, (index) => '$index');

  // use to determine the margin of the input text field to the scaffold
  double getTopMargin(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return max(0, min(_marginList, (screenWidth - _maxWidthMainList) / 2));
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
                                dev.log('iiiiiih');
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
                  child: FastReorderableList.builder(
                      itemCount: _items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          key: ValueKey<String>(_items[index]),
                          child: Material(
                            child: ListTile(
                              hoverColor: Colors.black26,
                              title: Text('Item ${_items[index]}'),
                              onTap: () {
                                // TODO: add tap event for items
                                dev.log('You clicked item ${_items[index]}');
                              },
                            ),
                            color: Colors.white,
                          ),
                          background: Container(
                            color: Colors.green,
                          ),
                          onDismissed: (DismissDirection direction) {
                            setState(() {
                              _items.remove(index);
                            });
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
