// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:todo_list/controller/task_controller.dart';
//
// import '../firebase/firebase.dart';
//
// class TaskList extends StatelessWidget {
//   const TaskList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final taskController = Get.put(TaskController());
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.greenAccent,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Text('10 task per day',
//               style: TextStyle(fontWeight: FontWeight.bold),),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: taskController.task1,
//                 decoration: InputDecoration(
//                     labelText: '1'
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: taskController.task2,
//                 decoration: InputDecoration(
//                     labelText: '2'
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: taskController.task3,
//                 decoration: InputDecoration(
//                     labelText: '3'
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: taskController.task4,
//                 decoration: InputDecoration(
//                     labelText: '4'
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: taskController.task5,
//                 decoration: InputDecoration(
//                     labelText: '5'
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: taskController.task6,
//                 decoration: InputDecoration(
//                     labelText: '6'
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: taskController.task7,
//                 decoration: InputDecoration(
//                     labelText: '7'
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: taskController.task8,
//                 decoration: InputDecoration(
//                     labelText: '8'
//                 ),
//               ),
//             ),
//
//
//             Center(child: Container(
//                 width: MediaQuery
//                     .of(context)
//                     .size
//                     .width * .8,
//                 child: ElevatedButton(onPressed: () {
//                   createUserData(
//                     taskController.task1.text,
//                     taskController.task2.text,
//                     taskController.task3.text,
//                     taskController.task4.text,
//                     taskController.task5.text,
//                     taskController.task6.text,
//                     taskController.task7.text,
//                     taskController.task8.text
//
//
//                   );
//                 }, child: Text('click to finish')))),
//             SizedBox(
//               height: MediaQuery
//                   .of(context)
//                   .size
//                   .height * .1,
//             ),
//
//
//           ],
//         ),
//       ),
//     );
//   }
// }
