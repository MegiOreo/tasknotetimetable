import 'package:flutter/material.dart';

class TimetableEditorWidget extends StatefulWidget {
  const TimetableEditorWidget({Key? key}) : super(key: key);

  @override
  State<TimetableEditorWidget> createState() => _TimetableEditorWidgetState();
}

class _TimetableEditorWidgetState extends State<TimetableEditorWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Text(
          'Page Title',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Header Row
            // Row(
            //   children: [
            //     Column(
            //       children: [
            //         Container(
            //           width: 100,
            //           height: 100,
            //           decoration: BoxDecoration(
            //             color: Color(0xFFA4A4A4),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),

            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.125,
                    height: 100,
                    decoration: BoxDecoration(
                      //color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.black),
                        bottom: BorderSide(color: Colors.black),

                        //color: Colors.black,
                      ),
                    ),
                  ),
                  containerDay(context, 'Mon'),
                  containerDay(context, 'Tue'),
                  containerDay(context, 'Wed'),
                  containerDay(context, 'Thu'),
                  containerDay(context, 'Fri'),
                  containerDay(context, 'Sat'),
                  containerDay(context, 'Sun'),
                  // Container(
                  //   width: MediaQuery.sizeOf(context).width * 0.125,
                  //   height: 100,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     border: Border(
                  //       top: BorderSide(color: Colors.black),
                  //       right: BorderSide(color: Colors.black),
                  //       bottom: BorderSide(color: Colors.black),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            // Expanded SingleChildScrollView to accommodate content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Adjusted to min
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 1,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.125,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.03,
                                //height: 100,
                                decoration: BoxDecoration(
                                    //color: Colors.white,
                                    // border: Border(
                                    //   right: BorderSide(color: Colors.black),
                                    // ),
                                    ),
                              ),

                              for(int i=6; i<12; i++)
                              timeContainer(context, i,"am"),

                              for(int i=12; i<24; i++)
                              timeContainer(context, i,"pm"),
                            ],
                          ),

                          columnMon(context),
                          columnTue(context),
                          columnWed(context)


                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget columnMon(BuildContext context) {
  return Column(
    children: [
      dummyContainer(context),
      for (int i = 0; i < 8; i++) contentContainer(context),

      // contentContainer(context),
      // contentContainer(context)
    ],
  );
}

Widget columnTue(BuildContext context) {
  return Column(
    children: [
      dummyContainer(context),

      for (int i = 0; i < 8; i++)
      contentContainer(context),
      // contentContainer(context),
      // contentContainer(context)
    ],
  );
}

Widget columnWed(BuildContext context) {
  return Column(
    children: [
      dummyContainer(context),

      for (int i = 0; i < 8; i++)
      contentContainer(context),
      // contentContainer(context),
      // contentContainer(context)
    ],
  );
}

Widget containerDay(BuildContext context, String day) {
  return Container(
    width: MediaQuery.sizeOf(context).width * 0.125,
    height: 100,
    decoration: BoxDecoration(
      //color: Colors.white,
      border: Border(
        top: BorderSide(color: Colors.black),
        left: BorderSide(color: Colors.black),
        bottom: BorderSide(color: Colors.black),
      ),
    ),
    child: Center(
      child: Text(
        day,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ),
  );
}

Widget timeContainer(BuildContext context, int hrs, String time) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.125,
    height: MediaQuery.of(context).size.height * 0.085,
    decoration: BoxDecoration(
        // color: Theme.of(context)
        //     .secondaryHeaderColor, // Use your theme's secondary color
        border: Border(
            //bottom: BorderSide(color: Colors.black),
            //right: BorderSide(color: Colors.black),
            )),
    //child: Center(
    child: Text(
      '$hrs\n$time',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Readex Pro',
        fontSize: 13,
        letterSpacing: 0,
      ),
    ),
    //),
  );
}

Widget dummyContainer(BuildContext context) {
  return Container(
    width: MediaQuery.sizeOf(context).width * 0.125,
    height: MediaQuery.sizeOf(context).height * 0.04,
    decoration: BoxDecoration(
      //color: FlutterFlowTheme.of(context).secondaryBackground,
      border: Border(
        left: BorderSide(color: Colors.black),
        // right: BorderSide(color: Colors.black),
        bottom: BorderSide(color: Colors.black),
      ),
    ),
  );
}

Widget contentContainer(BuildContext context) {
  return Container(
    width: MediaQuery.sizeOf(context).width * 0.125,
    height: MediaQuery.sizeOf(context).height * 0.12,
    decoration: BoxDecoration(
      //color: FlutterFlowTheme.of(context).secondaryBackground,
      border: Border(
          left: BorderSide(color: Colors.black),
          bottom: BorderSide(color: Colors.black)
          //color: Colors.black,
          ),
    ),
  );
}
