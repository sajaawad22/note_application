// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'Models/NotesPage.dart';
//
//
// class CallFromFirebase extends StatefulWidget {
//   @override
//   _CallFromFirebaseState createState() => _CallFromFirebaseState();
// }
//
// class _CallFromFirebaseState extends State<CallFromFirebase> {
//   late Stream<QuerySnapshot> notesStream;
//
//   @override
//   void initState() {
//     super.initState();
//     // get the notes collection from Firestore and listen for updates
//     notesStream = FirebaseFirestore.instance.collection('notes').snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: notesStream,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}'),
//           );
//         }
//
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//
//         // get the documents from the snapshot and create a list of notes
//         final documents = snapshot.data!.docs;
//         final notes = documents.map((doc) => Note.fromDocument(doc)).toList();
//
//         return notes.isNotEmpty
//             ? buildNotes(notes)
//             : Center(
//           child: Column(
//             children: <Widget>[
//               Spacer(),
//               Image(
//                 image: AssetImage('assets/note3.png'),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                     left: 80, top: 80, bottom: 80, right: 80),
//                 child: Text(
//                   'Add Notes<3',
//                   style: TextStyle(
//                       fontSize: 17, fontWeight: FontWeight.w700),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget buildNotes(List<Note> notes) {
//     return ListView.builder(
//       itemCount: notes.length,
//       itemBuilder: (BuildContext context, int index) {
//         final note = notes[index];
//
//         return Dismissible(
//           key: Key(note.id),
//           onDismissed: (_) async {
//             await deleteNoteFromFirebase(note);
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Note deleted'),
//                 duration: Duration(seconds: 2),
//               ),
//             );
//           },
//           child: ListTile(
//             title: Text(note.noteHeading),
//             subtitle: Text(note.noteDescription),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> deleteNoteFromFirebase(Note note) async {
//     await FirebaseFirestore.instance
//         .collection('notes')
//         .doc(note.id)
//         .delete();
//   }
// }
