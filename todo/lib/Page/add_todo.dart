import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/Page/account_file.dart';
import 'package:todo/Page/show_element.dart';

class AddElementPage extends StatefulWidget {
  const AddElementPage({Key? key}) : super(key: key);

  @override
  _AddElementPageState createState() => _AddElementPageState();
}

class _AddElementPageState extends State<AddElementPage> {
  TextEditingController txt_title = TextEditingController();
  String initialTitle = "Title";
  bool _isTitleEditable = false;

  TextEditingController txt_date = TextEditingController();
  DateTime _dateTime = DateTime.now();
  DateFormat formatter = DateFormat('dd-MM-yyyy');

  TextEditingController txt_note = TextEditingController();
  String initialNote = "Insert your note there...";
  bool _isNoteEditable = false;

  _saveElementToDo() {
    final user = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');

    late String element;

    Map<String, dynamic> collection = {"email": "${user!.email}"};

    collectionReference.snapshots().listen((snapshot) {
      for (int i = 0; i < snapshot.docs.length; i++) {
        if (snapshot.docs[i]
            .data()
            .toString()
            .contains(collection.toString())) {
          element = snapshot.docs[i].id;
        }
      }

      CollectionReference secondCollectionReference = FirebaseFirestore.instance
          .collection('users')
          .doc(element)
          .collection('todo');

      Map<String, dynamic> todo = {
        "title": initialTitle,
        "date": _dateTime,
        "description": txt_note.text.isEmpty ? "null" : txt_note.text,
      };

      secondCollectionReference.add(todo);
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ShowElementPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Element"),
        actions: [
          ElevatedButton(onPressed: _saveElementToDo, child: Text("Save"))
        ],
      ),
      body: Column(
        children: [
          const Divider(
            height: 10,
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: _editableTitle(),
              ),
            ),
          ),
          const Divider(
            height: 10,
            thickness: 2,
          ),
          Expanded(
            flex: 1,
            child: Container(
                color: Colors.transparent,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2001),
                        lastDate: DateTime(2222),
                      ).then((date) {
                        setState(() {
                          _dateTime = date as DateTime;
                          txt_date.text = formatter.format(_dateTime);
                        });
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.calendar_today_rounded),
                        ),
                        Text(formatter.format(_dateTime)),
                      ],
                    ),
                  ),
                )),
          ),
          const Divider(
            height: 10,
            thickness: 2,
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: txt_note,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _editableTitle() {
    if (_isTitleEditable) {
      return Center(
        child: TextField(
          onSubmitted: (value) {
            setState(() {
              if (value != "") {
                setState(() {
                  initialTitle = value;
                  _isTitleEditable = false;
                });
              } else if (value == "") {
                setState(() {
                  initialTitle = "Title";
                  _isTitleEditable = false;
                });
              }
            });
          },
          style: const TextStyle(fontSize: 40),
          autofocus: true,
          controller: txt_title,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          decoration: const InputDecoration.collapsed(hintText: ''),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          setState(() {
            _isTitleEditable = true;
          });
        },
        child: Text(
          initialTitle,
          style: const TextStyle(
            //color: Colors.white,
            fontSize: 40,
          ),
        ),
      );
    }
  }
}
