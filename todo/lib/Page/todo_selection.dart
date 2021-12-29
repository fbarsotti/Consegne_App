import 'package:flutter/material.dart';
import 'package:todo/Page/show_element.dart';

class ToDoSelection extends StatefulWidget {
  const ToDoSelection({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ToDoSelectionState();
  }
}

class _ToDoSelectionState extends State<ToDoSelection> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _selectedIndex = newIndex;
          });
        },
        children: const [
          ShowElementPage(),
          Center(child: Text("Index: 2")),
          //Center(child: Text("Index: 3")),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.check_rounded), label: "To do"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          /*BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),*/
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
      ),
    );
  }
}
