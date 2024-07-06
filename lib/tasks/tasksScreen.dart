import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasknotetimetable/auth.dart';

class TasksListWidget extends StatefulWidget {
  //TasksListWidget({super.key});
  final int displayBack;

  TasksListWidget({Key? key, this.displayBack = 0}) : super(key: key);

  //final int displayBack=0;

  final User? user = Auth().currentUser;
//start remove comment
  @override
  State<TasksListWidget> createState() => _TasksListWidgetState();
}

class _TasksListWidgetState extends State<TasksListWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TimeOfDay _selectedTime = TimeOfDay.now();
  late DateTime _selectedDate = DateTime.now();
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescController = TextEditingController();

  bool _thisWeekBtn=true;

  String selectedWeek = 'This week';
  Widget _sortButton(String week) {
    bool isSelected = week == selectedWeek;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedWeek = week;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.05,
        decoration: BoxDecoration(
          color: isSelected ? (week == 'This week' ? Color.fromARGB(
              255, 228, 106, 106) : Color.fromARGB(255, 229, 176, 95)) : Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              week,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btnDeletePast() {
    return ElevatedButton(
      onPressed: () {
       // _deletePastTasks();
        _confirmDeletePast();
      },
      child: Text('Delete past'),
    );
  }

  void _deletePastTasks() async {
    DateTime now = DateTime.now();

    try {
      await FirebaseFirestore.instance
          .collection('usersTasks')
          .doc(widget.user!.uid)
          .collection('tasks')
          .where('timestamp', isLessThan: Timestamp.fromDate(now))
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Past tasks deleted successfully.'),
        ),
      );
    } catch (e) {
      print('Error deleting past tasks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete past tasks. Please try again.'),
        ),
      );
    }
  }

  Future _confirmDeletePast(){
    //return showDialog(context: context, builder: (BuildContext context))
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm delete all past?"),
            content: Text("This will delete all task that is past the due. This action cannot be undone"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close", style: TextStyle(color: Colors.red),),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green
                ),
                onPressed: () {
                  _deletePastTasks();
                },
                child: Text("Confirm", style: TextStyle(color: Colors.white),),
              )
            ],
          );
        });
  }


  //***********************************function select time & date
//start
  Widget _taskContainer(String name, String description, DateTime dueDate, TimeOfDay dueTime) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Task Options'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text('Edit Task'),
                    onTap: () {
                      Navigator.pop(context); // Close current dialog
                      _editTaskDialog(name, description, dueDate, dueTime);
                    },
                  ),
                  ListTile(
                    title: Text('Delete Task'),
                    onTap: () async {
                      Navigator.pop(context); // Close current dialog
                      bool confirmDelete = await _confirmDeleteDialog();
                      if (confirmDelete) {
                        _deleteTask(name); // Implement delete function
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.18,
          decoration: BoxDecoration(
            color: selectedWeek=='This week' ? Color.fromARGB(255, 228, 106, 106) : Color.fromARGB(
                255, 229, 176, 95),//Colors.redAccent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.32,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          dueTime.format(context),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.32,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${dueDate.day} ${_getMonthName(dueDate.month)} ${dueDate.year}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.53,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          description,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editTaskDialog(String name, String description, DateTime dueDate, TimeOfDay dueTime) {
    taskNameController.text = name;
    taskDescController.text = description;
    _selectedTime = dueTime;
    _selectedDate = dueDate;
    TextEditingController timeController =
    TextEditingController(text: dueTime.format(context));
    TextEditingController dateController = TextEditingController(
        text: '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 500.0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: taskNameController,
                    decoration: InputDecoration(
                      labelText: 'Name your task',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 3),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    maxLines: 5,
                    minLines: 1,
                    controller: taskDescController,
                    decoration: InputDecoration(
                      labelText: 'Describe your task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Due Time:'),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: timeController,
                          enabled: false,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                          );
                          if (pickedTime != null) {
                            setState(() {
                              _selectedTime = pickedTime;
                              timeController.text =
                                  _selectedTime.format(context);
                            });
                          }
                        },
                        child: const Text('Select Time'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Due Date:'),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: dateController,
                          enabled: false,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                              dateController.text =
                              '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
                            });
                          }
                        },
                        child: const Text('Select Date'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Implement update task logic in Firebase Firestore
                String newName = taskNameController.text;
                String newDesc = taskDescController.text;

                DateTime newDateTime = DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  _selectedDate.day,
                  _selectedTime.hour,
                  _selectedTime.minute,
                );

                Timestamp newTimestamp = Timestamp.fromDate(newDateTime);

                // Get the document ID of the task to update
                String taskId = await FirebaseFirestore.instance
                    .collection('usersTasks')
                    .doc(widget.user!.uid)
                    .collection('tasks')
                    .where('name', isEqualTo: name)
                    .get()
                    .then((querySnapshot) {
                  return querySnapshot.docs.first.id;
                });

                // Update the task document
                try {
                  await FirebaseFirestore.instance
                      .collection('usersTasks')
                      .doc(widget.user!.uid)
                      .collection('tasks')
                      .doc(taskId)
                      .update({
                    'name': newName,
                    'description': newDesc,
                    'timestamp': newTimestamp,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Task updated successfully.'),
                    ),
                  );
                } catch (e) {
                  print('Error updating task: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update task. Please try again.'),
                    ),
                  );
                }

                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }


  Future _confirmDeleteDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false on cancel
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true on confirmation
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(String name) async {
    try {
      await FirebaseFirestore.instance
          .collection('usersTasks')
          .doc(widget.user!.uid)
          .collection('tasks')
          .where('name', isEqualTo: name)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task deleted successfully.'),
        ),
      );
    } catch (e) {
      print('Error deleting task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete task. Please try again.'),
        ),
      );
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF1F4F8),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('FloatingActionButton pressed ...');
          //_addBookmark(context);

          taskNameController.text = ''; // Clear task name controller
          taskDescController.text = '';
          _addTask(context);
        },
        backgroundColor: Colors.black,
        elevation: 8,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 24,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 205, 93, 93),
        title: Text(
          'Tasks',
          style: GoogleFonts.nunito(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: widget.displayBack == 1
            ? IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        )
            : null,
        actions: [_btnDeletePast()],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sortButton('This week'),
                  _sortButton('Others'),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('usersTasks')
                    .doc(widget.user!.uid)
                    .collection('tasks')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // Sort tasks by timestamp closest to the current system time
                  final tasks = snapshot.data!.docs;
                  tasks.sort((a, b) {
                    final aTimestamp = a['timestamp'] as Timestamp;
                    final bTimestamp = b['timestamp'] as Timestamp;
                    final aDueDate = aTimestamp.toDate();
                    final bDueDate = bTimestamp.toDate();
                    final now = DateTime.now();
                    final aDifference = aDueDate.difference(now).abs();
                    final bDifference = bDueDate.difference(now).abs();
                    return aDifference.compareTo(bDifference);
                  });

                  if (tasks.isEmpty) {
                    return Center(child: Text('No tasks found for $selectedWeek'));
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final name = task['name'];
                      final description = task['description'];
                      final timestamp = task['timestamp'] as Timestamp;
                      final dueDate = timestamp.toDate();
                      final dueTime = TimeOfDay.fromDateTime(dueDate);

                      return _taskContainer(name, description, dueDate, dueTime);
                    },
                  );
                },
              ),
            ),



            //start
          ],
        ),
      ),
    );
  }

  void _addTask(BuildContext context) {
    TextEditingController timeController =
        TextEditingController(text: _selectedTime.format(context));
    TextEditingController dateController = TextEditingController(
        text:
            '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'New task',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 500.0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: taskNameController,
                    decoration: const InputDecoration(
                      labelText: 'Name your task',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    maxLines: 5,
                    minLines: 1,
                    controller: taskDescController,
                    decoration: const InputDecoration(
                      labelText: 'Describe your task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Due Time:'),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: timeController,
                          enabled: false,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                          );
                          if (pickedTime != null) {
                            setState(() {
                              _selectedTime = pickedTime;
                              timeController.text =
                                  _selectedTime.format(context);
                            });
                          }
                        },
                        child: const Text('Select Time'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Due Date:'),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: dateController,
                          enabled: false,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                              dateController.text =
                                  '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
                            });
                          }
                        },
                        child: const Text('Select Date'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                taskNameController.clear();
                taskDescController.clear();
                timeController.text = TimeOfDay.now().format(context);
                dateController.text =
                    '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String taskName = taskNameController.text;
                String taskDesc = taskDescController.text;

                DateTime selectedDateTime = DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  _selectedDate.day,
                  _selectedTime.hour,
                  _selectedTime.minute,
                );

                Timestamp taskTimestamp = Timestamp.fromDate(selectedDateTime);

                if (taskName.isNotEmpty && taskDesc.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('usersTasks')
                        .doc(widget.user!.uid)
                        .collection('tasks')
                        .add({
                      'name': taskName,
                      'description': taskDesc,
                      'timestamp': taskTimestamp,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Task added successfully.'),
                      ),
                    );
                  } catch (e) {
                    print('Error adding task: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to add task. Please try again.'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All fields must be filled out.'),
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }


}

Widget _taskCard(BuildContext context) {
  return Container(
    width: MediaQuery.sizeOf(context).width * 1,
    height: MediaQuery.sizeOf(context).height * 0.1,
    decoration: BoxDecoration(
        color: Colors.blue, borderRadius: BorderRadius.circular(16)),
  );
}

Widget _thisWeekContainer(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.93,
    height: MediaQuery.of(context).size.height * 0.3,
    decoration: BoxDecoration(
        color: Color.fromARGB(255, 230, 179, 179),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ]),
    child: ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _taskCard(context),
              )
            ],
          );
        }),
  );
}

Widget _beyondWeekContainer(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.93,
    height: MediaQuery.of(context).size.height * 0.3,
    decoration: BoxDecoration(
        color: Color.fromARGB(255, 217, 217, 217),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ]),
    child: const Padding(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: Text(
        'Tasks is empty\n:)',
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
