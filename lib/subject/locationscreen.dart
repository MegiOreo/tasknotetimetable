import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasknotetimetable/auth.dart';

class LocationScreen extends StatefulWidget {
  final Function(String) onLocationSelected;

  LocationScreen({super.key, required this.onLocationSelected});

  final User? user = Auth().currentUser;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String selectedLocation = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLocationDialog(context);
        },
        backgroundColor: Colors.black,
        elevation: 8,
        child: Icon(
          Icons.add,
          color: Colors.white, // Change to your desired color
          size: 24,
        ),
      ),
      appBar: AppBar(
        title: Text("Locations",
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
                .collection('usersLocation')
                .doc(widget.user!.uid)
                .collection('locations')
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
                      String location = data['location'];
                      String documentId = document.id;
                      return _locationCard(location, documentId);
                    }).toList(),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _locationCard(String location, String documentId) {
    bool isSelected = location == selectedLocation;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedLocation = ''; // Deselect the location if it's already selected
          } else {
            selectedLocation = location;
            widget.onLocationSelected(selectedLocation);
            Navigator.pop(context);
          }
        });
      },
      onLongPress: () {
        _showEditDeleteDialog(location, documentId);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.07,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              location,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _locationCard(String location) {
  //   bool isSelected = location == selectedLocation;
  //
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         if (isSelected) {
  //           selectedLocation =
  //               ''; // Deselect the location if it's already selected
  //         } else {
  //           selectedLocation = location;
  //           widget.onLocationSelected(selectedLocation);
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
  //             location,
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
  void _showEditDeleteDialog(String location, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Options for $location"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Edit"),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    _editLocation(location, documentId);
                  },
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                GestureDetector(
                  child: Text("Delete"),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    _deleteLocation(documentId);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editLocation(String location, String documentId) {
    TextEditingController _locationNameController = TextEditingController();
    _locationNameController.text = location;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Location"),
          content: TextFormField(
            controller: _locationNameController,
            decoration: const InputDecoration(
              labelText: 'Location',
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
                String updatedLocation = _locationNameController.text.trim();

                if (updatedLocation.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('usersLocation')
                        .doc(widget.user!.uid)
                        .collection('locations')
                        .doc(documentId)
                        .update({'location': updatedLocation});

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Location updated successfully.'),
                    ));
                  } catch (e) {
                    print('Error updating location: $e');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                      Text('Failed to update location. Please try again.'),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Location cannot be empty.'),
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

  void _deleteLocation(String documentId) {
    FirebaseFirestore.instance
        .collection('usersLocation')
        .doc(widget.user!.uid)
        .collection('locations')
        .doc(documentId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Location deleted successfully.'),
      ));
    }).catchError((error) {
      print("Failed to delete location: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete location. Please try again.'),
      ));
    });
  }

  void _showAddLocationDialog(BuildContext context) {
    TextEditingController _locationNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Location"),
          content: TextFormField(
            controller: _locationNameController,
            decoration: const InputDecoration(
              labelText: 'Location',
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
                String location = _locationNameController.text;

                if (location.isNotEmpty) {
                  bool exists = await _checkIfLocationExists(location);
                  if (exists) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Location already exists.'),
                    ));
                  } else {
                    try {
                      // Save location under the user's collection
                      await FirebaseFirestore.instance
                          .collection('usersLocation')
                          .doc(widget.user!.uid)
                          .collection('locations')
                          .add({
                        'location': location,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Location added successfully.'),
                      ));
                    } catch (e) {
                      print('Error adding location: $e');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Failed to add location. Please try again.'),
                      ));
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Location cannot be empty.'),
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

  Future<bool> _checkIfLocationExists(String location) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('usersLocation')
        .doc(widget.user!.uid)
        .collection('locations')
        .where('location', isEqualTo: location)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
}
