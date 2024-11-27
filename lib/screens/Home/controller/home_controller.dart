import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isChecked = false.obs;
  var selectedDate = DateTime.now().obs;

  void toggleCheckbox(bool value) {
    isChecked.value = value;
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }
}
