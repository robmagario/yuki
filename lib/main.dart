import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final studentNameProvider = StateProvider<String>((ref) => '');
final studentGenderProvider = StateProvider<String>((ref) => 'M');
String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
final studentDOBProvider = StateProvider<String>((ref) => now);

void main() {
 // runApp(MaterialApp(
 //   title: 'Flutter',
 //   home: FirstScreen(),
//  ));
  runApp(
    // Adding ProviderScope enables Riverpod for the entire project
    const ProviderScope(child: MyApp()),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FirstScreen());
  }
}

class FirstScreen extends ConsumerWidget {

  // this allows us to access the TextField text
  TextEditingController textFieldController = TextEditingController();
  DateTime selectedDate = DateTime.now();


  @override
  Widget build(BuildContext context,  ScopedReader watch) {

    final studentDOB =  watch(studentDOBProvider).state;
    DateTime selectedDate = DateTime.now();

    String val = "M";
    return Scaffold(
      appBar: AppBar(title: Text('First screen')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.all(06.0),
            child: TextField(
              controller: textFieldController,
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Input student name'
              ),
            ),
          ),
          Column(
            children: [ListTile(
              title: Text("Male"),
              leading: Radio(
                value: "M",
                groupValue: watch(studentGenderProvider).state,
                onChanged: (value) {

                  watch(studentGenderProvider).state = value.toString();

                },
                activeColor: Colors.green,
              ),
            ),
              ListTile(
                title: Text("Female"),
                leading: Radio(
                  value: "F",
                  groupValue: watch(studentGenderProvider).state,
                  onChanged: (value) {
                    watch(studentGenderProvider).state = value.toString();
                  },
                  activeColor: Colors.green,
                ),
              ),],
          ),
          Text(
            studentDOB.toString(),
            style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),

          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: ()  async {
              await showDatePicker(
                  context: context,
                  initialDate: selectedDate, // Refer step 1
                  firstDate: DateTime(2000),
              lastDate: DateTime(2025),
              ).then((pickedDate) {
                if (pickedDate!=null) {
                  String newPickedDate = DateFormat("yyyy-MM-dd").format(pickedDate);
                  context
                      .read(studentDOBProvider)
                      .state = newPickedDate;
                }
              });
    },
            child: Text(
              'Select date',
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          //  color: Colors.greenAccent,
          ),
          ElevatedButton(
            child: Text(
              'Go to second screen',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: () {
              context.read(studentNameProvider).state = textFieldController.text;

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondScreen()),
              );
            },
          )

        ],
      ),
    );
  }



}

class SecondScreen extends ConsumerWidget {
  final String text = "";

  // receive data from the FirstScreen as a parameter
  SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,  ScopedReader watch) {

    return Scaffold(
      appBar: AppBar(title: Text('Second screen')),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text(
            context.read(studentNameProvider).state.toString(),
            style: TextStyle(fontSize: 24),
          ),
            Padding(padding: const EdgeInsets.all(16.0), child: Text(

              context.read(studentGenderProvider).state.toString()=="M"? "Male":"Female",
              style: TextStyle(fontSize: 24),
            ),
            ),
            Padding(padding: const EdgeInsets.all(16.0), child: Text(

              context.read(studentDOBProvider).state.toString(),
              style: TextStyle(fontSize: 24),
            ),
            ),
          ],
        )

    );
  }
}