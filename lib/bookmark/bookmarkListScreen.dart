// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tasknotetimetable/auth.dart';
// import 'package:favicon/favicon.dart';

// class BookmarkListScreenWidget extends StatefulWidget {
//   BookmarkListScreenWidget({super.key});

//   final User? user = FirebaseAuth.instance.currentUser;

//   @override
//   State<BookmarkListScreenWidget> createState() => _BookmarkListScreenWidgetState();
// }

// class _BookmarkListScreenWidgetState extends State<BookmarkListScreenWidget> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   Map<String, String?> _favicons = {};

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> _fetchFavicon(String url) async {
//     if (url.isNotEmpty && !_favicons.containsKey(url)) {
//       try {
//         final icon = await FaviconFinder.getBest(url);
//         setState(() {
//           _favicons[url] = icon?.url;
//         });
//       } catch (e) {
//         setState(() {
//           _favicons[url] = null;
//         });
//         print('Error fetching favicon: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       backgroundColor: Color(0xFFF1F4F8),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           print('FloatingActionButton pressed ...');
//           _addBookmark(context);
//         },
//         backgroundColor: Colors.black,
//         elevation: 8,
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//           size: 24,
//         ),
//       ),
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Page Title',
//           style: GoogleFonts.nunito(
//             textStyle: TextStyle(
//               color: Colors.white,
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         actions: [],
//         centerTitle: false,
//         elevation: 2,
//       ),
//       body: SafeArea(
//         top: true,
//         child: Column(
//           children: [
//             Padding(
//                 padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height * 0.05,
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF1F4F8),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
//                         child: Text(
//                           'Bookmarks',
//                           style: TextStyle(
//                             fontFamily: 'Readex Pro',
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
//                         child: TextButton(
//                           onPressed: () {
//                             print('Button pressed ...');
//                           },
//                           child: Text(
//                             'Edit links',
//                             style: TextStyle(
//                               fontFamily: 'Readex Pro',
//                               color: Colors.black,
//                               fontSize: 16,
//                             ),
//                           ),
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                               Color(0xFFF8F5F5),
//                             ),
//                             padding: MaterialStateProperty.all<EdgeInsets>(
//                               EdgeInsets.fromLTRB(24, 0, 24, 0),
//                             ),
//                             elevation: MaterialStateProperty.all<double>(3),
//                             side: MaterialStateProperty.all<BorderSide>(
//                               BorderSide(
//                                 color: Colors.black,
//                                 width: 1,
//                               ),
//                             ),
//                             shape: MaterialStateProperty.all<OutlinedBorder>(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Divider(
//                 thickness: 2,
//                 indent: 16,
//                 endIndent: 16,
//                 color: Color(0xEF4A4A4A),
//               ),
//             StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(widget.user!.uid)
//                   .collection('bookmarks')
//                   .snapshots(),
//               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 }

//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height * 0.5,
//                     decoration: BoxDecoration(),
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
//                       child: Text(
//                         'No bookmark yet...',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontFamily: 'Readex Pro',
//                           color: Color(0x8414181B),
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   );
//                 }

//                 return ListView(
//                   padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   children: snapshot.data!.docs.map((DocumentSnapshot document) {
//                     return _BookmarkContainer(document);
//                   }).toList(),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _BookmarkContainer(DocumentSnapshot bookmarkSnapshot) {
//     Map<String, dynamic> data = bookmarkSnapshot.data() as Map<String, dynamic>;
//     String name = data['name'] ?? '';
//     String url = data['url'] ?? '';

//     // Fetch favicon in the background
//     _fetchFavicon(url);

//     return Container(
//       padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
//       width: 100,
//       height: 100,
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Color.fromARGB(254, 89, 89, 89), width: 1),
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width * 0.14,
//             height: MediaQuery.of(context).size.width * 0.14,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               image: _favicons[url] != null
//                   ? DecorationImage(
//                       fit: BoxFit.cover,
//                       image: NetworkImage(_favicons[url]!),
//                     )
//                   : null,
//             ),
//             child: _favicons[url] == null
//                 ? Center(child: CircularProgressIndicator())
//                 : null,
//           ),
//           Padding(
//             padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 // SizedBox(height: 10),
//                 // Text(
//                 //   url,
//                 //   style: TextStyle(color: Colors.grey),
//                 // ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _addBookmark(BuildContext context) {
//     TextEditingController _linkNameController = TextEditingController();
//     TextEditingController _linkUrlController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Bookmark Link',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: SizedBox(
//             width: MediaQuery.of(context).size.width * 0.9,
//             height: 500.0,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextFormField(
//                       controller: _linkNameController,
//                       autofocus: true,
//                       decoration: const InputDecoration(
//                         labelText: 'Link Name',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextFormField(
//                       controller: _linkUrlController,
//                       autofocus: true,
//                       decoration: const InputDecoration(
//                         labelText: 'Link URL',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 await FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(widget.user!.uid)
//                     .collection('bookmarks')
//                     .add({
//                   'name': _linkNameController.text,
//                   'url': _linkUrlController.text,
//                 });
//                 _fetchFavicon(_linkUrlController.text);
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

//latesttttt
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasknotetimetable/auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BookmarkListScreenWidget extends StatefulWidget {
  BookmarkListScreenWidget({super.key});

  final User? user = Auth().currentUser;

  @override
  State<BookmarkListScreenWidget> createState() =>
      _BookmarkListScreenWidgetState();
}

class _BookmarkListScreenWidgetState extends State<BookmarkListScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Set<DocumentSnapshot> _selectedBookmarks = {};

  bool get _selectionMode => _selectedBookmarks.isNotEmpty;

  @override
  void initState() {
    super.initState();
  }

  void _toggleBookmarkSelection(DocumentSnapshot bookmark) {
  setState(() {
    // Check if the bookmark ID is already in the selected bookmarks set
    if (_selectedBookmarks.any((snapshot) => snapshot.id == bookmark.id)) {
      // If yes, remove it
      _selectedBookmarks.removeWhere((snapshot) => snapshot.id == bookmark.id);
    } else {
      // If not, add it
      _selectedBookmarks.add(bookmark);
    }
  });
}


  void _deleteSelectedBookmarks() {
    for (var bookmark in _selectedBookmarks) {
      bookmark.reference.delete();
    }
    setState(() {
      _selectedBookmarks.clear();
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedBookmarks.clear();
    });
  }

  Widget _highlightSelected(){
    return Container(
      width: MediaQuery.of(context).size.width*1,
      height: MediaQuery.of(context).size.height*0.1,
      decoration: BoxDecoration(
        color: Colors.green
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF1F4F8),
      appBar: _selectionMode ? _buildSelectionAppBar() : _buildDefaultAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addBookmark(context);
        },
        backgroundColor: Colors.black,
        elevation: 8,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 24,
        ),
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Padding(
            //   padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height * 0.05,
            //     decoration: BoxDecoration(
            //       color: Color(0xFFF1F4F8),
            //     ),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.max,
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Padding(
            //           padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
            //           child: Text(
            //             'Bookmarks',
            //             style: TextStyle(
            //               fontFamily: 'Readex Pro',
            //               fontSize: 24,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //         Padding(
            //           padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
            //           child: TextButton(
            //             onPressed: () {
            //               print('Button pressed ...');
            //             },
            //             child: Text(
            //               'Edit links',
            //               style: TextStyle(
            //                 fontFamily: 'Readex Pro',
            //                 color: Colors.black,
            //                 fontSize: 16,
            //               ),
            //             ),
            //             style: ButtonStyle(
            //               backgroundColor: MaterialStateProperty.all<Color>(
            //                 Color(0xFFF8F5F5),
            //               ),
            //               padding: MaterialStateProperty.all<EdgeInsets>(
            //                 EdgeInsets.fromLTRB(24, 0, 24, 0),
            //               ),
            //               elevation: MaterialStateProperty.all<double>(3),
            //               side: MaterialStateProperty.all<BorderSide>(
            //                 BorderSide(
            //                   color: Colors.black,
            //                   width: 1,
            //                 ),
            //               ),
            //               shape: MaterialStateProperty.all<OutlinedBorder>(
            //                 RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(8),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),//start
            const Divider(
              thickness: 2,
              indent: 16,
              endIndent: 16,
              color: Color(0xEF4A4A4A),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('usersBookmarks')
                    .doc(widget.user!.uid)
                    .collection('bookmarks')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: Text(
                          'No bookmark yet...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            color: Color(0x8414181B),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 100),
                    scrollDirection: Axis.vertical,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _BookmarkContainer(document),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildDefaultAppBar() {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 78, 189, 136),
      title: Text(
        'Bookmarks',
        style: GoogleFonts.nunito(
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }//start

  AppBar _buildSelectionAppBar() {
  return AppBar(
    //backgroundColor: Colors.blue,
    leading: IconButton(
      icon: Icon(Icons.clear),
      onPressed: _clearSelection,
    ),
    title: Text('${_selectedBookmarks.length} selected'),
    actions: [
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: _deleteSelectedBookmarks,
      ),
      IconButton(
        icon: Icon(Icons.select_all),
        onPressed: () {
          _selectAllBookmarks();
        },
      ),
      // IconButton(
      //   icon: Icon(Icons.select_off),
      //   onPressed: () {
      //     _clearSelection();
      //   },
      // ),
    ],
  );
}

void _selectAllBookmarks() async {
  final bookmarks = await FirebaseFirestore.instance
    .collection('usersBookmarks')
    .doc(widget.user!.uid)
    .collection('bookmarks')
    .get();
    final allBookmarksSelected = bookmarks.docs.every((bookmark) =>
      _selectedBookmarks.any((selected) => selected.id == bookmark.id));

  setState(() {
    if (allBookmarksSelected) {
      _selectedBookmarks.clear();
    } else {
      _selectedBookmarks.clear();
      _selectedBookmarks.addAll(bookmarks.docs);
    }
  });
  // setState(() {
  //   _selectedBookmarks.clear();
  //   // Add all bookmarks to the selected set
  //   _selectedBookmarks.addAll(bookmarks.docs);
  // });
}




  Widget _BookmarkContainer(DocumentSnapshot? bookmarkSnapshot) {
  if (bookmarkSnapshot == null || bookmarkSnapshot.data() == null) {
    return SizedBox();
  }

  Map<String, dynamic> data = bookmarkSnapshot.data() as Map<String, dynamic>;
  String name = data['name'] ?? '';
  String url = data['url'] ?? '';

  bool isSelected = _selectedBookmarks.any((snapshot) => snapshot.id == bookmarkSnapshot.id);

  return GestureDetector(
    onLongPress: () {
      _toggleBookmarkSelection(bookmarkSnapshot);
    },
    onTap: () {
      if (_selectionMode) {
        _toggleBookmarkSelection(bookmarkSnapshot);
      } else {
        _launchURL(url);
      }
    },
    child: Container(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        color: isSelected ? const Color.fromARGB(255, 103, 197, 154) : Color.fromARGB(
            255, 67, 139, 104),
        // border: Border(
        //   bottom: BorderSide(color: Color.fromARGB(164, 0, 0, 0), width: 1),
        // ),
        borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  void _launchURL(String url) async {
    if (await launchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _addBookmark(BuildContext context) {
  TextEditingController _linkNameController = TextEditingController();
  TextEditingController _linkUrlController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Bookmark Link',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 500.0,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    children: [
                      // Text(
                      //   'Display Name',
                      //   style: TextStyle(fontWeight: FontWeight.bold),
                      //   textAlign: TextAlign.left,
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: TextFormField(
                    controller: _linkNameController,
                    decoration: const InputDecoration(
                      labelText: 'Name your link',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                //   child: Row(
                //     children: [
                //       Text(
                //         'Link URL',
                //         style: TextStyle(fontWeight: FontWeight.bold),
                //         textAlign: TextAlign.left,
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: TextFormField(
                    controller: _linkUrlController,
                    decoration: const InputDecoration(
                      labelText: 'www.urlink.com',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              String name = _linkNameController.text;
              String url = _linkUrlController.text;

              if (name.isNotEmpty && url.isNotEmpty) {
                try {
                  // Add the bookmark to Firestore
                  DocumentReference docRef = await FirebaseFirestore.instance
                      .collection('usersBookmarks')
                      .doc(widget.user!.uid)
                      .collection('bookmarks')
                      .add({
                    'name': name,
                    'url': url,
                  });

                  // Retrieve the ID generated by Firestore
                  String bookmarkId = docRef.id;

                  // Update the document with the ID
                  await docRef.update({'id': bookmarkId});

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Bookmark added successfully.'),
                  ));
                } catch (e) {
                  print('Error adding bookmark: $e');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to add bookmark. Please try again.'),
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Name and URL cannot be empty.'),
                ));
              }
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Save', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green
            ),
          ),
        ],
      );
    },
  );
}

}

// ////2nd one.. takda favicon********************************************************
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tasknotetimetable/auth.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// //import 'package:favicon/favicon.dart';

// class BookmarkListScreenWidget extends StatefulWidget {
//   BookmarkListScreenWidget({super.key});

//   final User? user = Auth().currentUser;

//   @override
//   State<BookmarkListScreenWidget> createState() =>
//       _BookmarkListScreenWidgetState();
// }

// class _BookmarkListScreenWidgetState extends State<BookmarkListScreenWidget> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       backgroundColor: Color(0xFFF1F4F8),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           print('FloatingActionButton pressed ...');
//           _addBookmark(context);
//         },
//         backgroundColor: Colors.black,
//         elevation: 8,
//         child: Icon(
//           Icons.add,
//           color: Colors.white, // Change to your desired color
//           size: 24,
//         ),
//       ),
//       // appBar: AppBar(
//       //   backgroundColor: Colors.blue, // Change to your desired color
//       //   automaticallyImplyLeading: false,
//       //   title: Text(
//       //     'Page Title',
//       //     style: GoogleFonts.nunito(
//       //       textStyle: TextStyle(
//       //         color: Colors.white,
//       //         fontSize: 22,
//       //         fontWeight: FontWeight.bold,
//       //       ),
//       //     ),
//       //   ),
//       //   actions: [],
//       //   centerTitle: false,
//       //   elevation: 2,
//       // ),
//       body: SafeArea(
//         top: true,
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Padding(
//               padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height * 0.05,
//                 decoration: BoxDecoration(
//                   color: Color(0xFFF1F4F8),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
//                       child: Text(
//                         'Bookmarks',
//                         style: TextStyle(
//                           fontFamily: 'Readex Pro',
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
//                       child: TextButton(
//                         onPressed: () {
//                           print('Button pressed ...');
//                         },
//                         child: Text(
//                           'Edit links',
//                           style: TextStyle(
//                             fontFamily: 'Readex Pro',
//                             color: Colors.black,
//                             fontSize: 16,
//                           ),
//                         ),
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all<Color>(
//                             Color(0xFFF8F5F5),
//                           ),
//                           padding: MaterialStateProperty.all<EdgeInsets>(
//                             EdgeInsets.fromLTRB(24, 0, 24, 0),
//                           ),
//                           elevation: MaterialStateProperty.all<double>(3),
//                           side: MaterialStateProperty.all<BorderSide>(
//                             BorderSide(
//                               color: Colors.black,
//                               width: 1,
//                             ),
//                           ),
//                           shape: MaterialStateProperty.all<OutlinedBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Divider(
//               thickness: 2,
//               indent: 16,
//               endIndent: 16,
//               color: Color(0xEF4A4A4A),
//             ),

//             //displaybookmark***********************************
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(widget.user!.uid)
//                     .collection('bookmarks')
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   }

//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   }

//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height * 0.5,
//                       decoration: BoxDecoration(),
//                       child: Padding(
//                         padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
//                         child: Text(
//                           'No bookmark yet...',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontFamily: 'Readex Pro',
//                             color: Color(0x8414181B),
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     );
//                   }

//                   return ListView(
//                     padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
//                     //shrinkWrap: true,
//                     scrollDirection: Axis.vertical,
//                     children:
//                         snapshot.data!.docs.map((DocumentSnapshot document) {
//                       return _BookmarkContainer(document);
//                     }).toList(),
//                   );
//                 },
//               ),
//             ),
// //start
//             // ListView(
//             //   //padding: EdgeInsets.zero,
//             //   padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
//             //   shrinkWrap: true,
//             //   scrollDirection: Axis.vertical,
//             //   children: [_BookmarkContainer()],
//             // ),
//             // Container(
//             //   width: MediaQuery.of(context).size.width,
//             //   height: MediaQuery.of(context).size.height * 0.5,
//             //   decoration: BoxDecoration(),
//             //   child: Padding(
//             //     padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
//             //     child: Text(
//             //       'No bookmark yet...',
//             //       textAlign: TextAlign.center,
//             //       style: TextStyle(
//             //         fontFamily: 'Readex Pro',
//             //         color: Color(0x8414181B),
//             //         fontSize: 18,
//             //         fontWeight: FontWeight.w500,
//             //       ),
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Fav icon display *****************************************************8

// //   String? _faviconUrl;

// //   Future<void> _fetchFavicon(String url) async {
// //   if (url.isNotEmpty) {
// //     try {
// //       final icon = await FaviconFinder.getBest(url);
// //       setState(() {
// //         _faviconUrl = icon?.url;
// //       });
// //     } catch (e) {
// //       setState(() {
// //         _faviconUrl = null;
// //       });
// //       print('Error fetching favicon: $e');
// //     }
// //   }
// // }

// // Widget _BookmarkContainer(DocumentSnapshot? bookmarkSnapshot) {
// //   if (bookmarkSnapshot == null || bookmarkSnapshot.data() == null) {
// //     // Handle null snapshot or data
// //     return SizedBox();
// //   }

// //   Map<String, dynamic> data = bookmarkSnapshot.data() as Map<String, dynamic>;
// //   String name = data['name'] ?? '';
// //   String url = data['url'] ?? '';

// //   return FutureBuilder<void>(
// //     future: _fetchFavicon(url),
// //     builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
// //       return Container(
// //         width: 100,
// //         height: 100,
// //         decoration: BoxDecoration(
// //           border: Border(
// //             bottom: BorderSide(color: Color.fromARGB(164, 0, 0, 0), width: 1),
// //           ),
// //         ),
// //         child: Row(
// //           mainAxisSize: MainAxisSize.max,
// //           children: [
// //             Container(
// //               width: MediaQuery.of(context).size.width * 0.14,
// //               height: MediaQuery.of(context).size.width * 0.14,
// //               decoration: BoxDecoration(
// //                 color: Color(0xFF480909),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: _faviconUrl != null
// //                   ? Image.network(
// //                       _faviconUrl!,
// //                       fit: BoxFit.cover,
// //                     )
// //                   : SizedBox(), // Placeholder or empty if faviconUrl is null
// //             ),
// //             Padding(
// //               padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.max,
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     name,
// //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //                   ),
// //                   SizedBox(height: 10),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       );
// //     },
// //   );
// // }
//   Widget _BookmarkContainer(DocumentSnapshot? bookmarkSnapshot) {
//     if (bookmarkSnapshot == null || bookmarkSnapshot.data() == null) {
//       // Handle null snapshot or data
//       return SizedBox();
//     }

//     Map<String, dynamic> data = bookmarkSnapshot.data() as Map<String, dynamic>;
//     String name = data['name'] ?? '';
//     String url = data['url'] ?? '';

//     return GestureDetector(
//       onTap: () {
//         _launchURL(url);
//       },
//       child: Container(
//         width: 100,
//         height: 100,
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(color: Color.fromARGB(164, 0, 0, 0), width: 1),
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Padding(
//               padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: 300, // Adjust width as needed
//                     child: Text(
//                       name,
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// // Method to launch URL
//   void _launchURL(String url) async {
//     if (await launchUrlString(url)) {
//       await launchUrlString(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

// //   Widget _BookmarkContainer(DocumentSnapshot? bookmarkSnapshot) {
// //   if (bookmarkSnapshot == null || bookmarkSnapshot.data() == null) {
// //     // Handle null snapshot or data
// //     return SizedBox();
// //   }

// //   Map<String, dynamic> data = bookmarkSnapshot.data() as Map<String, dynamic>;
// //   String name = data['name'] ?? '';
// //   String url = data['url'] ?? '';

// //   return Container(
// //     width: 100,
// //     height: 100,
// //     decoration: BoxDecoration(
// //         border: Border(
// //             bottom: BorderSide(color: Color.fromARGB(164, 0, 0, 0), width: 1))),
// //     child: Row(
// //       mainAxisSize: MainAxisSize.max,
// //       children: [
// //         Container(
// //           width: MediaQuery.of(context).size.width * 0.14,
// //           height: MediaQuery.of(context).size.width * 0.14,
// //           decoration: BoxDecoration(
// //             color: Color(0xFF480909),
// //             image: DecorationImage(
// //                       fit: BoxFit.cover,
// //                       image: NetworkImage(display the favicon here),
// //                     ),
// //             shape: BoxShape.circle,
// //           ),
// //         ),
// //         Padding(
// //           padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.max,
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 name,
// //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //               ),
// //               SizedBox(height: 10),
// //               // Text(
// //               //   url,
// //               // ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     ),
// //   );
// // }

// //yang first********************************
//   // Widget _BookmarkContainer() {
//   //   return Container(
//   //     width: 100,
//   //     height: 100,
//   //     decoration: BoxDecoration(
//   //         border: Border(
//   //             bottom:
//   //                 BorderSide(color: Color.fromARGB(164, 0, 0, 0), width: 1))),
//   //     child: Row(
//   //       mainAxisSize: MainAxisSize.max,
//   //       children: [
//   //         Container(
//   //           width: MediaQuery.of(context).size.width * 0.14,
//   //           height: MediaQuery.of(context).size.width * 0.14,
//   //           decoration: BoxDecoration(
//   //             color: Color(0xFF480909),
//   //             shape: BoxShape.circle,
//   //           ),
//   //         ),
//   //         Padding(
//   //           padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
//   //           child: Column(
//   //             mainAxisSize: MainAxisSize.max,
//   //             mainAxisAlignment: MainAxisAlignment.center,
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: [
//   //               Text('Link Name',
//   //                   style:
//   //                       TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//   //               SizedBox(height: 10),
//   //               Text(
//   //                 'Hello World',
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   void _addBookmark(BuildContext context) {
//     TextEditingController _linkNameController = TextEditingController();
//     TextEditingController _linkUrlController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Bookmark Link',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: SizedBox(
//             width: MediaQuery.of(context).size.width * 0.9,
//             height: 500.0,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                     child: Row(
//                       children: [
//                         Text(
//                           'Display Name',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                           textAlign: TextAlign.left,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
//                     child: TextFormField(
//                       controller: _linkNameController,
//                       decoration: const InputDecoration(
//                         labelText: 'Name your link',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
//                     child: Row(
//                       children: [
//                         Text(
//                           'Link URL',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                           textAlign: TextAlign.left,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
//                     child: TextFormField(
//                       controller: _linkUrlController,
//                       decoration: const InputDecoration(
//                         labelText: 'www.urlink.com',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 String name = _linkNameController.text;
//                 String url = _linkUrlController.text;

//                 if (name.isNotEmpty && url.isNotEmpty) {
//                   try {
//                     // Save bookmark under the user's collection
//                     await FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(widget.user!.uid)
//                         .collection('bookmarks')
//                         .add({
//                       'name': name,
//                       'url': url,
//                     });
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       content: Text('Bookmark added successfully.'),
//                     ));
//                   } catch (e) {
//                     print('Error adding bookmark: $e');
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       content:
//                           Text('Failed to add bookmark. Please try again.'),
//                     ));
//                   }
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text('Name and URL cannot be empty.'),
//                   ));
//                 }
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   } //start
// }


////first one*********************************************************************
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tasknotetimetable/auth.dart';
// //import 'package:sampleproject1/bookmark/bookmarks.dart';
// //import 'package:shared_preferences/shared_preferences.dart';
// //import 'dart:convert';

// //import 'package:provider/provider.dart';

// // import 'bookmark_list_screen_model.dart';
// // export 'bookmark_list_screen_model.dart';

// class BookmarkListScreenWidget extends StatefulWidget {
//   BookmarkListScreenWidget({super.key});

//   final User? user = Auth().currentUser;

//   @override
//   State<BookmarkListScreenWidget> createState() =>
//       _BookmarkListScreenWidgetState();
// }

// class _BookmarkListScreenWidgetState extends State<BookmarkListScreenWidget> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   //List<Bookmark> bookmarks = [];

//   @override
//   void initState() {
//     super.initState();
//     //_loadBookmarks();
//   }

//   // @override
//   // void dispose() {
//   //   _model.dispose();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       backgroundColor: Color(0xFFF1F4F8),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           print('FloatingActionButton pressed ...');
//           _addBookmark(context);
//         },
//         backgroundColor: Colors.black,
//         elevation: 8,
//         child: Icon(
//           Icons.add,
//           color: Colors.white, // Change to your desired color
//           size: 24,
//         ),
//       ),
//       appBar: AppBar(
//         backgroundColor: Colors.blue, // Change to your desired color
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Page Title',
//           style: GoogleFonts.nunito(
//             textStyle: TextStyle(
//               color: Colors.white,
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         actions: [],
//         centerTitle: false,
//         elevation: 2,
//       ),
//       body: SafeArea(
//         top: true,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Padding(
//                 padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height * 0.05,
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF1F4F8),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
//                         child: Text(
//                           'Bookmarks',
//                           style: TextStyle(
//                             fontFamily: 'Readex Pro',
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
//                         child: TextButton(
//                           onPressed: () {
//                             print('Button pressed ...');
//                           },
//                           child: Text(
//                             'Edit links',
//                             style: TextStyle(
//                               fontFamily: 'Readex Pro',
//                               color: Colors.black,
//                               fontSize: 16,
//                             ),
//                           ),
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                               Color(0xFFF8F5F5),
//                             ),
//                             padding: MaterialStateProperty.all<EdgeInsets>(
//                               EdgeInsets.fromLTRB(24, 0, 24, 0),
//                             ),
//                             elevation: MaterialStateProperty.all<double>(3),
//                             side: MaterialStateProperty.all<BorderSide>(
//                               BorderSide(
//                                 color: Colors.black,
//                                 width: 1,
//                               ),
//                             ),
//                             shape: MaterialStateProperty.all<OutlinedBorder>(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Divider(
//                 thickness: 2,
//                 indent: 16,
//                 endIndent: 16,
//                 color: Color(0xEF4A4A4A),
//               ),

//               // ListView.builder(
//               //   shrinkWrap: true,
//               //   itemCount: 3, // Replace with your actual item count
//               //   itemBuilder: (context, index) {
//               //     return ListTile(
//               //       title: Text("data"),
//               //       subtitle: Text("gtr"),
//               //     );
//               //   },
//               // ),

//               // ListView.builder(
//               //   shrinkWrap: true,
//               //   itemCount: bookmarks.length,
//               //   itemBuilder: (context, index) {
//               //     return ListTile(
//               //       title: Text(bookmarks[index].linkName),
//               //       subtitle: Text(bookmarks[index].link),
//               //     );
//               //   },
//               // ),

//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height * 0.5,
//                 decoration: BoxDecoration(),
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
//                   child: Text(
//                     'No bookmark yet...',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontFamily: 'Readex Pro',
//                       color: Color(0x8414181B),
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // String? _validateUrl(String? value) {
//   //   if (value == null || value.isEmpty) {
//   //     return 'Please enter a URL';
//   //   }
//   //   final validUrlPattern = RegExp(
//   //       r'^https?:\/\/(?:www\.)?[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?$');
//   //   if (!validUrlPattern.hasMatch(value)) {
//   //     return 'Please enter a valid URL';
//   //   }
//   //   return null;
//   // }

//   // keyboardType: TextInputType.url,
//   // validator: _validateUrl,

//   void _addBookmark(BuildContext context) {
//     TextEditingController _linkNameController = TextEditingController();
//     TextEditingController _linkUrlController = TextEditingController();

//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text(
//               'Bookmark Link',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             content: SizedBox(
//               width: MediaQuery.of(context).size.width * 0.9,
//               height: 500.0,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                       child: Row(
//                         children: [
//                           Text(
//                             'Display Name',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                             textAlign: TextAlign.left,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
//                       child: TextFormField(
//                         controller: _linkNameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Name your link',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ),

//                     //link url********************************************************

//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
//                       child: Row(
//                         children: [
//                           Text(
//                             'Link URL',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                             textAlign: TextAlign.left,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
//                       child: TextFormField(
//                         controller: _linkUrlController,
//                         decoration: const InputDecoration(
//                           labelText: 'www.urlink.com',
//                           border: OutlineInputBorder(),
//                         ),
//                         // letak sini 2 tu
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               String name = _linkNameController.text;
//               String url = _linkUrlController.text;

//               // Save logic goes here
//               if (name.isNotEmpty && url.isNotEmpty) {
//                 // Access Firebase Firestore and add the data
//                 try {
//                   await FirebaseFirestore.instance.collection('bookmarks').add({
//                     'name': name,
//                     'url': url,
//                   });
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text('Bookmark added successfully.'),
//                   ));
//                 } catch (e) {
//                   print('Error adding bookmark: $e');
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text('Failed to add bookmark. Please try again.'),
//                   ));
//                 }
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Text('Name and URL cannot be empty.'),
//                 ));
//               }
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             child: Text('Save'),
//           ),
//         ],


//             // actions: [
//             //   TextButton(
//             //     onPressed: () {
//             //       Navigator.of(context).pop(); // Close the dialog
//             //     },
//             //     child: Text('Cancel'),
//             //   ),
//             //   ElevatedButton(
//             //     onPressed: () {
//             //       // Save logic goes here
//             //       // You can access the entered values using _linkNameController.text and _linkUrlController.text
//             //       // For example:
//             //       // String name = _linkNameController.text;
//             //       // String url = _linkUrlController.text;
//             //       // Perform your save operation here
//             //       Navigator.of(context).pop(); // Close the dialog
//             //     },
//             //     child: Text('Save'),
//             //   ),
//             // ],
//           );
//         });
//   }

//   // Future<void> _addBookmark(BuildContext context) async {
//   //   final TextEditingController linkNameController = TextEditingController();
//   //   final TextEditingController linkController = TextEditingController();

//   //   return showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         title: const Text('Add Bookmark'),
//   //         content: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             TextField(
//   //               controller: linkNameController,
//   //               decoration: const InputDecoration(labelText: 'Link Name'),
//   //             ),
//   //             TextField(
//   //               controller: linkController,
//   //               decoration: const InputDecoration(labelText: 'Link URL'),
//   //             ),
//   //           ],
//   //         ),
//   //         actions: [
//   //           TextButton(
//   //             onPressed: () {
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: const Text('Cancel'),
//   //           ),
//   //           TextButton(
//   //             onPressed: () {
//   //               setState(() {
//   //                 bookmarks.add(Bookmark(
//   //                   linkNameController.text,
//   //                   linkController.text,
//   //                 ));
//   //                 _saveBookmarks();
//   //               });
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: const Text('Save'),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }

//   // Future<void> _loadBookmarks() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   final List<String>? bookmarkStrings = prefs.getStringList('bookmarks');
//   //   if (bookmarkStrings != null) {
//   //     setState(() {
//   //       bookmarks = bookmarkStrings
//   //           .map((bookmarkString) =>
//   //               Bookmark.fromJson(json.decode(bookmarkString)))
//   //           .toList();
//   //     });
//   //   }
//   // }

//   // Future<void> _saveBookmarks() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   final List<String> bookmarkStrings =
//   //       bookmarks.map((bookmark) => bookmark.toJson()).cast<String>().toList();
//   //   prefs.setStringList('bookmarks', bookmarkStrings);
//   // }
// }
