import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasknotetimetable/auth.dart';

class SubjectScreen extends StatefulWidget {
  final Function(String) onSubjectSelected;
  
  SubjectScreen({super.key, required this.onSubjectSelected});

  final User? user = Auth().currentUser;

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}


class _SubjectScreenState extends State<SubjectScreen> {
  String selectedSubject = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSubjectDialog(context);
        },
        backgroundColor: Colors.black,
        elevation: 8,
        child: Icon(
          Icons.add,
          color: Colors.white, // Change to your desired color
          size: 24,
        ),
      ),
      // appBar: AppBar(
      //   title: Text("Subjects"),
      // ),
      appBar: AppBar(
        title: Text("Subjects",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        backgroundColor: Color.fromARGB(255, 81, 151, 190),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        // actions: [
        //   onPressed: (){}
        // ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('usersSubject')
                .doc(widget.user!.uid)
                .collection('subjects')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      String subject = data['subject'];
                      String documentId = document.id; // Get the document ID
                      return _subjectCard(subject, documentId); // Pass both subject and documentId
                    }).toList(),
                  );

              //   ListView(
                  //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  //     Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  //     String subject = data['subject'];
                  //     return _subjectCard(subject);
                  //   }).toList(),
                  // );
                }
              }
            },
          ),
        ),
      ),
    );
  }
  Widget _subjectCard(String subject, String documentId) {
    bool isSelected = subject == selectedSubject;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedSubject = ''; // Deselect the subject if it's already selected
          } else {
            selectedSubject = subject;
            widget.onSubjectSelected(selectedSubject);
            Navigator.pop(context);
          }
        });
      },
      onLongPress: () {
        _showEditDeleteDialog(subject, documentId);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.07,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Color.fromARGB(255, 92, 92, 92),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              subject,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
//old 1
//   Widget _subjectCard(String subject) {
//   bool isSelected = subject == selectedSubject;
//
//   return GestureDetector(
//     onTap: () {
//       setState(() {
//         if (isSelected) {
//           selectedSubject = '';
//         } else {
//           selectedSubject = subject;
//           widget.onSubjectSelected(selectedSubject);
//           Navigator.pop(context);
//         }
//       });
//     },
//     child: Padding(
//       padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 1,
//         height: MediaQuery.of(context).size.height * 0.07,
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue : Colors.black,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Center(
//           child: Text(
//             subject,
//             style: TextStyle(
//               color: isSelected ? Colors.white : Colors.white70,
//               fontSize: 16,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }


  // Widget _subjectCard(String subject) {
  //   bool isSelected = subject == selectedSubject;

  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         if (isSelected) {
  //           selectedSubject =
  //               ''; // Deselect the subject if it's already selected
  //         } else {
  //           selectedSubject = subject;
  //         }
  //       });
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
  //       child: Container(
  //         width: MediaQuery.of(context).size.width * 1,
  //         height: MediaQuery.of(context).size.height * 0.07,
  //         decoration: BoxDecoration(
  //           color: isSelected ? Colors.blue : Colors.black,
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: Center(
  //           child: Text(
  //             subject,
  //             style: TextStyle(
  //               color: isSelected ? Colors.white : Colors.white70,
  //               fontSize: 16,
  //               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _showEditDeleteDialog(String subject, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Options for $subject"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Edit"),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    _editSubject(subject, documentId);
                  },
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                GestureDetector(
                  child: Text("Delete"),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    _deleteSubject(documentId);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editSubject(String subject, String documentId) {
    TextEditingController _subjectNameController = TextEditingController();
    _subjectNameController.text = subject;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Subject"),
          content: TextFormField(
            controller: _subjectNameController,
            decoration: const InputDecoration(
              labelText: 'Subject',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () async {
                String updatedSubject = _subjectNameController.text.trim();

                if (updatedSubject.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('usersSubject')
                        .doc(widget.user!.uid)
                        .collection('subjects')
                        .doc(documentId)
                        .update({'subject': updatedSubject});

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Subject updated successfully.'),
                    ));
                  } catch (e) {
                    print('Error updating subject: $e');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                      Text('Failed to update subject. Please try again.'),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Subject cannot be empty.'),
                  ));
                }

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteSubject(String documentId) {
    FirebaseFirestore.instance
        .collection('usersSubject')
        .doc(widget.user!.uid)
        .collection('subjects')
        .doc(documentId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Subject deleted successfully.'),
      ));
    }).catchError((error) {
      print("Failed to delete subject: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete subject. Please try again.'),
      ));
    });
  }

  void _showAddSubjectDialog(BuildContext context) {
    TextEditingController _subjectNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Subject"),
          content: TextFormField(
            controller: _subjectNameController,
            decoration: const InputDecoration(
              labelText: 'Subject',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Add"),
              onPressed: () async {
                String subject = _subjectNameController.text;

                if (subject.isNotEmpty) {
                  bool exists = await _checkIfSubjectExists(subject);
                  if (exists) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Subject already exists.'),
                    ));
                  } else {
                    try {
                      // Save bookmark under the user's collection
                      await FirebaseFirestore.instance
                          .collection('usersSubject')
                          .doc(widget.user!.uid)
                          .collection('subjects')
                          .add({
                        'subject': subject,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Subject added successfully.'),
                      ));
                    } catch (e) {
                      print('Error adding subject: $e');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Failed to add subject. Please try again.'),
                      ));
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Subject cannot be empty.'),
                  ));
                }
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _checkIfSubjectExists(String subject) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('usersSubject')
        .doc(widget.user!.uid)
        .collection('subjects')
        .where('subject', isEqualTo: subject)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
}
