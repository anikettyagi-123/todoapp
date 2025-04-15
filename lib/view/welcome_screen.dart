import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_list/controller/task_controller.dart';
import '../controller/notification.dart';
import '../firebase/firebase.dart';
import 'loginScreem.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.put(TaskController());
    taskController.fetchTask();


    final auth = FirebaseAuth.instance;

    String getCurrentTime() {
      DateTime now = DateTime.now();
      String formattedTime = DateFormat('hh:mm a').format(now);
      return formattedTime;
    }

    final String time = getCurrentTime();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text('Todo List'),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                auth.signOut().then(
                      (value) {
                    Get.deleteAll();
                    Get.offAll(() => LoginScreen());
                  },
                );
              },
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Lottie.asset('animation/what.json',
                          width: MediaQuery.of(context).size.width * .5),
                      Flexible(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(
                              "What's up for today?",
                              textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Obx(() {
                    if (taskController.isloading.value) {
                      return Center(
                          child: Lottie.asset('animation/empty.json'));
                    } else if (taskController.taskList.isEmpty) {
                      return Center(
                          child: Lottie.asset('animation/empty.json'));
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: taskController.taskList.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> taskList =
                            taskController.taskList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 8.0),
                              child: GestureDetector(
                                onLongPress: (){
                                  Get.defaultDialog(
                                    title: "Delete Task",
                                    middleText: "Are you sure you want to delete this task?",
                                    textConfirm: "Delete",
                                    textCancel: "Cancel",
                                    confirmTextColor: Colors.white,
                                    onConfirm: () {
                                      deleteTaskk(taskList['id']);  // Call delete function
                                      Navigator.of(context).pop();  // Close the dialog
                                    },
                                    onCancel: () {
                                      Navigator.of(context).pop();  // Close the dialog if cancel is pressed
                                    },
                                  );
                                },
                                onTap: () {
                                  updateTask(
                                      taskList['newTask'], taskList['id'], time);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade700,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        taskList['time'] == null
                                            ? Icons.circle_outlined
                                            : Icons.check_circle_rounded,
                                        color: taskList['time'] == null
                                            ? Colors.white
                                            : Colors.white60,
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          taskList['newTask'],
                                          style: TextStyle(
                                            color: taskList['time'] == null
                                                ? Colors.white
                                                : Colors.white60,
                                            fontSize: 15,
                                            fontWeight: taskList['time'] == null
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            decoration: taskList['time'] != null
                                                ? TextDecoration.lineThrough
                                                : null,
                                            decorationColor: Colors.white60,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        taskList['time'] ?? '',
                                        style: TextStyle(
                                          color: taskList['time'] == null
                                              ? Colors.white
                                              : Colors.white60,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),


                                    ],

                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }),
                  GestureDetector(
                    onTap: () {
                      showDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 250.0, bottom: 150),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .1,
                        width: MediaQuery.of(context).size.width * .2,
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, size: 40),
                      ),
                    ),
                  ),



                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//
// void showDailog(context) {
//   final taskController = Get.put(TaskController());
//   Get.defaultDialog(
//     backgroundColor: Colors.greenAccent,
//     title: "Add today's task",
//     content: Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextFormField(controller: taskController.task),
//         ),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.black, foregroundColor: Colors.white),
//           onPressed: () {
//             addTask(taskController.task.text);
//             Navigator.of(context).pop();
//             taskController.task.clear();
//           },
//           child: const Text('Add'),
//         )
//       ],
//     ),
//   );
// }
void showDialog(BuildContext context) {
  final taskController = Get.put(TaskController());
  DateTime? selectedTime; // Variable to hold the selected time

  Get.defaultDialog(
    backgroundColor: Colors.greenAccent,
    title: "Add today's task",
    content: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: taskController.task,
            decoration: InputDecoration(
              labelText: 'Enter your task',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        // Time Picker Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            TimeOfDay? time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (time != null) {
              final now = DateTime.now();
              selectedTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
              // Show confirmation of selected time
              Get.snackbar('Time Selected', 'Task will be reminded at ${selectedTime!.hour}:${selectedTime!.minute}');
            }
          },
          child: const Text('Select Time'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if (taskController.task.text.isNotEmpty && selectedTime != null) {
              adddTask(taskController.task.text, selectedTime!); // Pass the selected time
              Navigator.of(context).pop();
              taskController.task.clear();
            } else {
              Get.snackbar('Error', 'Please enter a task and select a time');
            }
          },
          child: const Text('Add'),
        ),
      ],
    ),
  );
}
