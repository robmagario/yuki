import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studentNameProvider = StateProvider<String>((ref) => '');
final studentGenderProvider = StateProvider<String>((ref) => 'M');
final studentDOBProvider = StateProvider<String>((ref) => '');

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

  //@override
 // _FirstScreenState createState() {
//    return _FirstScreenState();
//  }
//}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FirstScreen());
  }
}

class FirstScreen extends ConsumerWidget {

  // this allows us to access the TextField text
  TextEditingController textFieldController = TextEditingController();
  DateTime? _selectedDate;
  DateTime selectedDate = DateTime.now();


  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
     // setState(() {
        selectedDate = picked;
    //  });
  }


  @override
  Widget build(BuildContext context,  ScopedReader watch) {

    final studentName = watch(studentNameProvider).state;
    final studentGender =  watch(studentGenderProvider).state;
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
            "${selectedDate.toLocal()}".split(' ')[0],
            style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context), // Refer step 3
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
  String text = "";

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
            )],
        )

    );
  }
}