import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Models/NotesPage.dart';

class NotesPage extends StatefulWidget {
  NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  var _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final noteHeadingController = TextEditingController();
  final noteDescriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    notesDescriptionMaxLenth =
        notesDescriptionMaxLines * notesDescriptionMaxLines;
  }

  @override
  void dispose() {
    noteDescriptionController.dispose();
    noteHeadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepPurpleAccent
            //color set to purple or set your own color
            ));

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('notesUsers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          if (documents.isEmpty) {
            return Center(
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Image(image: AssetImage('assets/note3.png')),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 80, top: 80, bottom: 80, right: 80),
                    child: Text(
                      'Add Notes<3',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            );
          }

          return buildNotes(documents
              // itemCount: documents.length,
              // itemBuilder: (BuildContext context, int index) {
              //   final Map<String, dynamic> data =
              //       documents[index].data() as Map<String, dynamic>;
              //
              //   return NoteCard(
              //     // a custom widget that displays the note data
              //     title: data['noteHeading'],
              //     subtitle: data['noteDescription'],
              //   );
              // },
              );
        },
      ),
      floatingActionButton: FloatingActionButton(
        mini: false,
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildNotes(List<DocumentSnapshot<Object?>> documents) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
      child: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, int index) {
          final Map<String, dynamic> data =
              documents[index].data() as Map<String, dynamic>;
          final String noteHeading = data['noteHeading'];
          final String noteDescription = data['noteDescription'];
          return Dismissible(
            key: Key(documents[index].id),
            onDismissed: (direction) async {
              if (direction == DismissDirection.endToStart) {
                // Perform update operation
                await FirebaseFirestore.instance
                    .collection('notesUsers')
                    .doc(documents[index].id)
                    .delete();
              } else if (direction == DismissDirection.startToEnd) {
                // Perform delete operation
                await FirebaseFirestore.instance
                    .collection('notesUsers')
                    .doc(documents[index].id)
                    .delete();
              } else if (direction == DismissDirection.up) {
                // Perform a task for swipe up
                // ...
                print('Swiped up');
              } else if (direction == DismissDirection.down) {
                // Perform a task for swipe down
                // ...
                print('Swiped down');
              }
            },
            background: Container(
              color: Colors.red,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: noteList(
              index: index,
              noteHeading: noteHeading,
              noteDescription: noteDescription,
            ),
          );
        },
      ),
    );
  }

  Widget noteList({
    required int index,
    required String noteHeading,
    required String noteDescription,
  }) {
    return ClipRRect(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: noteColor[(index % noteColor.length).floor()],
        ),
        height: 100,
        child: Center(
          child: Row(
            children: [
              new Container(
                color:
                    noteMarginColor[(index % noteMarginColor.length).floor()],
                width: 3.5,
                height: double.infinity,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Text(
                          noteHeading,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20.00,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.5,
                      ),
                      Flexible(
                        child: Container(
                          height: double.infinity,
                          child: AutoSizeText(
                            noteDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.00,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 50,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext bc) {
        return Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (MediaQuery.of(context).size.height),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 250, top: 50),
                  child: new Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "New Note",
                            style: TextStyle(
                              fontSize: 20.00,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  noteHeading.add(noteHeadingController.text);
                                  noteDescription
                                      .add(noteDescriptionController.text);
                                  // noteHeadingController.clear();
                                  // noteDescriptionController.clear();
                                });

                                // Save noteHeading to Firestore
                                await FirebaseFirestore.instance
                                    .collection('notesUsers')
                                    .add({
                                  'noteHeading': noteHeadingController.text,
                                  'noteDescription':
                                      noteDescriptionController.text,
                                });

                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                  Container(
                                    child: Icon(
                                      Icons.more_vert,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.deepPurpleAccent,
                        thickness: 2.5,
                      ),
                      TextFormField(
                        maxLength: notesHeaderMaxLenth,
                        controller: noteHeadingController,
                        decoration: InputDecoration(
                          hintText: "Note Heading",
                          hintStyle: TextStyle(
                            fontSize: 15.00,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                        validator: (String? noteHeading) {
                          if (noteHeading!.isEmpty) {
                            return "Please enter Note Heading";
                          } else if (noteHeading.startsWith(" ")) {
                            return "Please avoid whitespaces";
                          }
                        },
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context)
                              .requestFocus(textSecondFocusNode);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          margin: EdgeInsets.all(1),
                          height: 5 * 24.0,
                          child: TextFormField(
                            focusNode: textSecondFocusNode,
                            maxLines: notesDescriptionMaxLines,
                            maxLength: notesDescriptionMaxLenth,
                            controller: noteDescriptionController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Description',
                              hintStyle: TextStyle(
                                fontSize: 15.00,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            validator: (String? noteDescription) {
                              if (noteDescription!.isEmpty) {
                                return "Please enter Note Desc";
                              } else if (noteDescription.startsWith(" ")) {
                                return "Please avoid whitespaces";
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NoteCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const NoteCard({Key? key, required this.title, required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
