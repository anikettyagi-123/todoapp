

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import '../controller/notification.dart';
import '../controller/task_controller.dart';

Future<void>addTask(
    String task
    )async{

  User? user = FirebaseAuth.instance.currentUser;
  if(user != null){
    CollectionReference users = FirebaseFirestore.instance.collection('userTask');
    CollectionReference tasks = users.doc(user.uid).collection('tasks');
    try{
      await tasks.add({
        'newTask': task,
        'createdAt': FieldValue.serverTimestamp(),



      });
      await users.doc(user.uid).set({
        'lastUpdateDate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      Get.snackbar('Success', 'Task uploaded successfully',
          snackPosition: SnackPosition.BOTTOM);

    }catch(e){

    }

  }

}
Future<List<Map<String, dynamic>>?> fetchingTask() async {
  User? user = FirebaseAuth.instance.currentUser; // Get the current user
  if (user != null) {
    // Reference the user's specific task collection
    CollectionReference tasks = FirebaseFirestore.instance
        .collection('userTask')
        .doc(user.uid)
        .collection('tasks');

    QuerySnapshot newQuery = await tasks.orderBy('createdAt', descending: false).get(); // Fetch the tasks from the user's sub-collection

    if (newQuery.docs.isNotEmpty) {
      List<Map<String, dynamic>> taskList = newQuery.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data; // Return task data

      }).toList();
      return taskList;
    } else {
      return null; // No tasks found
    }
  } else {
    // Handle the case when the user is not logged in
    return null;
  }
}
Future<void> deleteTask() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('userTask').doc(user.uid).get();
    Timestamp? lastUpdateDate = userDoc['lastUpdateDate'];

    DateTime now = DateTime.now();
    DateTime lastUpdate = lastUpdateDate?.toDate() ?? DateTime.now().subtract(Duration(days: 1));

    if (lastUpdate.year != now.year || lastUpdate.month != now.month || lastUpdate.day != now.day) {
      // Clear tasks if it's a new day
      await FirebaseFirestore.instance.collection('userTask').doc(user.uid).collection('tasks').get().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    }
  }
}

Future<void> updateTask(
    String task,
    String id,
    String time
    ) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    CollectionReference users = FirebaseFirestore.instance.collection('userTask');
    CollectionReference tasks = users.doc(user.uid).collection('tasks');

    try {
      // Fetch the document snapshot
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await tasks.doc(id).get() as DocumentSnapshot<Map<String, dynamic>>;

      // Check if the document exists
      if (documentSnapshot.exists) {
        String? existingTime = documentSnapshot.data()?['time'];
        if(existingTime== null || existingTime.isEmpty){
        await tasks.doc(id).update({
          'newTask': task, // `task` variable (correct lowercase)
          'time': time,
        });
        }else{
          await tasks.doc(id).update({
            'newTask': task, // Only update task text
          });
        }

        final taskController = Get.find<TaskController>();
        taskController.fetchTask();

        // Show success message
        Get.snackbar('Well done ', 'Keep the moral high',
            snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.greenAccent.shade400
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
Future<void> deleteTaskk(String id) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    CollectionReference users = FirebaseFirestore.instance.collection('userTask');
    CollectionReference tasks = users.doc(user.uid).collection('tasks');

    try {
      // Delete the document with the provided id
      await tasks.doc(id).delete();

      final taskController = Get.find<TaskController>();
      taskController.fetchTask();

      // Show success message
      Get.snackbar('Task Deleted', 'The task was successfully deleted',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent.shade400
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete task: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
Future<void> adddTask(String task, DateTime notificationTime) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    CollectionReference users = FirebaseFirestore.instance.collection('userTask');
    CollectionReference tasks = users.doc(user.uid).collection('tasks');

    try {
      DocumentReference newTask = await tasks.add({
        'newTask': task,
        'createdAt': FieldValue.serverTimestamp(),
        'notificationTime': notificationTime.toIso8601String(),
      });

      int notificationId = newTask.id.hashCode;

      await Get.find<NotificationService>().scheduleNotification(
        notificationId,
        'Task Reminder',
        'Don\'t forget: $task',
        notificationTime,
      );

      Get.snackbar('Success', 'Task uploaded and notification scheduled successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print('Error adding task: $e');
      Get.snackbar('Error', 'Failed to upload task',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
