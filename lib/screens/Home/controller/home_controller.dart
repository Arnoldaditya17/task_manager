import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  final RxMap<String, RxBool> taskCheckStates = <String, RxBool>{}.obs;

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  void initializeCheckboxStates(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> tasks) {
    for (var task in tasks) {
      final taskId = task.id;

      final isCompleted = task.data().containsKey('isCompleted')
          ? task['isCompleted'] as bool
          : false;

      if (!taskCheckStates.containsKey(taskId)) {
        taskCheckStates[taskId] = RxBool(isCompleted);
      }
    }
  }

  void toggleTaskCheckbox(String taskId, bool isChecked) {
    if (taskCheckStates.containsKey(taskId)) {
      taskCheckStates[taskId]?.value = isChecked;
      FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .update({'isCompleted': isChecked});
    }
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }
}
