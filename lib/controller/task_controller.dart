import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:todo_list/firebase/firebase.dart';
import 'notification.dart';

class TaskController extends GetxController {
  final task = TextEditingController();
  var isloading = true.obs;
  var taskList = <Map<String, dynamic>>[].obs;


  @override
  void onClose() {
    task.dispose();
    super.onClose();
  }



  void fetchTask() async {
    try {
      isloading(true);
      List<Map<String, dynamic>>? fetch = await fetchingTask();
      if (fetch != null && fetch.isNotEmpty) {
        taskList.value = fetch;
      } else {
        taskList.clear();
      }
    } catch (error) {
      // Handle error if needed
    } finally {
      isloading(false);
    }
  }
}
