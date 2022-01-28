import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/Page/add_todo.dart';
import 'package:todo/Page/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo/Page/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ShowElementPage extends StatefulWidget {
  const ShowElementPage({Key? key}) : super(key: key);

  @override
  _ShowElementPageState createState() => _ShowElementPageState();
}

class _ShowElementPageState extends State<ShowElementPage> {
  final user = FirebaseAuth.instance.currentUser;

  TextEditingController shareController = TextEditingController();

  List titleList = [];
  List dateList = [];
  List descriptionList = [];
  int counter = 0;

  final StreamController _myStreamCtrl = StreamController.broadcast();
  Stream get onVariableChanged => _myStreamCtrl.stream;
  void updateMyUI() => _myStreamCtrl.sink.add(titleList.length);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _myStreamCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do'),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
              child: GestureDetector(
                onTap: () {
                  _showAlertDialog(
                    context,
                    'Effettuare il logout?',
                    'Annulla',
                    'Logout',
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user!.photoURL!),
                ),
              )),
        ],
      ),
      body: StreamBuilder(
        stream: onVariableChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            updateMyUI();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //return Text(snapshot.data.toString());
          return _returnToDo();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddElementPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _returnTitle() {
    final user = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');

    late String element;

    Map<String, dynamic> collection = {'email': '${user!.email}'};

    List finalTitle = [];

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

      secondCollectionReference.snapshots().listen((event) {
        List temp = [];
        List firstTitle = [];

        for (int i = 0; i < event.docs.length; i++) {
          temp.add(event.docs[i].data().toString());
        }

        for (int i = 0; i < temp.length; i++) {
          String tempString = temp[i].toString().trim();
          List temporaryList = tempString.split(', ');
          firstTitle.add(temporaryList[3]
              .toString()
              .substring(0, temporaryList[3].toString().length - 1));
        }

        for (int i = 0; i < firstTitle.length; i++) {
          String tempString = firstTitle[i].toString().trim();
          List temporaryList = tempString.split(': ');
          finalTitle.add(temporaryList[1].toString().trim());
        }

        setState(() {
          titleList.clear();
          for (String s in finalTitle) {
            titleList.add(s);
          }
        });
      });
    });
  }

  Future<void> _deleteToDo(int index) async {
    final user = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');

    DateFormat formatter = DateFormat();
    late String element;

    Map<String, dynamic> collection = {'email': '${user!.email}'};

    Map<String, dynamic> secondCollection = {
      'date': Timestamp.fromDate(dateList[index]),
      'description': descriptionList[index],
      'title': titleList[index],
    };

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

      secondCollectionReference.snapshots().listen((event) {
        for (int i = 0; i < event.docs.length; i++) {
          if (event.docs[i].data().toString() == secondCollection.toString()) {
            secondCollectionReference.doc(event.docs[i].id).delete();
          }
        }
      });
    });
  }

  void _returnDate() {
    late Timestamp date;
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    late String finalStringDate;

    final user = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');

    late String element;

    Map<String, dynamic> collection = {'email': '${user!.email}'};

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

      secondCollectionReference.snapshots().listen((event) {
        List temp = [];
        List firstDate = [];
        List finalDate = [];
        List settingsList = [];

        for (int i = 0; i < event.docs.length; i++) {
          temp.add(event.docs[i].data().toString());
        }

        for (int i = 0; i < temp.length; i++) {
          String tempString = temp[i].toString().trim();
          List temporaryList = tempString.split(', d');
          firstDate.add(temporaryList[0]
              .substring(1, temporaryList[0].toString().length));
        }

        for (int i = 0; i < firstDate.length; i++) {
          String tempString = firstDate[i];
          List temporaryList = tempString.split(': ');
          finalDate.add(temporaryList[1]
              .toString()
              .substring(9, temporaryList[1].toString().length));
        }

        for (int i = 0; i < finalDate.length; i++) {
          String temp = finalDate[i].toString().trim();
          List temporaryList = temp.split(', ');
          List seconds = temporaryList[0].toString().split('=');
          List nanoseconds = temporaryList[1].toString().split('=');
          String settings = seconds[1].toString().trim() +
              ':' +
              nanoseconds[1]
                  .toString()
                  .substring(0, nanoseconds[1].toString().length - 1)
                  .trim();
          settingsList.add(settings);
        }

        setState(() {
          for (int i = 0; i < settingsList.length; i++) {
            List returnDate = settingsList[i].toString().split(':');
            date =
                Timestamp(int.parse(returnDate[0]), int.parse(returnDate[1]));
            dateList.add(date.toDate());
          }
        });
      });
    });
  }

  void _returnDescription() {
    final user = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');

    late String element;

    Map<String, dynamic> collection = {'email': '${user!.email}'};

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

      secondCollectionReference.snapshots().listen((event) {
        List temp = [];
        List firstDescription = [];
        List finalDescription = [];

        for (int i = 0; i < event.docs.length; i++) {
          temp.add(event.docs[i].data().toString());
        }

        for (int i = 0; i < temp.length; i++) {
          String tempString = temp[i].toString().trim();
          List temporaryList = tempString.split(', ');
          firstDescription.add(temporaryList[2].toString().trim());
        }

        for (int i = 0; i < firstDescription.length; i++) {
          String tempString = firstDescription[i].toString().trim();
          List temporaryList = tempString.split(': ');
          finalDescription.add(temporaryList[1].toString().trim());
        }

        for (String s in finalDescription) {
          if (!descriptionList.contains(s)) {
            descriptionList.add(s);
          }
        }
      });
    });
  }

  Widget _returnToDo() {
    _returnTitle();
    _returnDate();
    _returnDescription();
    //String title = titleList[index];
    //DateTime date = dateList[index];
    //String description = descriptionList[index];

    DateFormat format = DateFormat('dd-MM-yyyy');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: const Color(0xFFE0E0E0),
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _deleteDialog(context, index);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline),
                            const Padding(
                                padding: EdgeInsets.only(left: 8, right: 8)),
                            Text(titleList[index])
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _shareDialog(context, index);
                        },
                        child: Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(format.format(dateList[index])),
                            const Padding(
                                padding: EdgeInsets.only(left: 8, right: 8)),
                            const Icon(Icons.group_add_rounded),
                          ],
                        )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                    child: Text(descriptionList[index]),
                  )
                ],
              ),
            ),
          );
        },
        itemCount: titleList.length,
      ),
    );
  }

  void _shareDialog(context, index) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Enter the email with whom you want to share it'),
              TextField(
                controller: shareController,
              ),
            ],
          ),
          //content: new Text('Alert Dialog body'),
          actions: [
            TextButton(
              onPressed: () {
                _shareElement(index);
              },
              child: const Text(
                'Share',
                style: TextStyle(
                  color: Color(0xff4285F4),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  _shareElement(index) {
    final user = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');

    late String element;

    Map<String, dynamic> collection = {'email': shareController.text.trim()};

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
        'title': titleList[index],
        'date': dateList[index],
        'description':
            descriptionList[index].isEmpty ? 'null' : descriptionList[index],
      };

      secondCollectionReference.add(todo);
    });

    Navigator.of(context).pop();
  }

  void _deleteDialog(context, index) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          title: const Text('Do you want to delete it?'),
          //content: new Text('Alert Dialog body'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(
                  color: Color(0xff4285F4),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _deleteToDo(index);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Color(0xff4285F4),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog(context, String title, String action1, String action2) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          title: Text(title),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                action1,
                style: const TextStyle(
                  color: Color(0xff4285F4),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(
                action2,
                style: const TextStyle(
                  color: Color(0xff4285F4),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
