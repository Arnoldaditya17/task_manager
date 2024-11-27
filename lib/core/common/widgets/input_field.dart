import 'package:flutter/material.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:task_manager/core/theme/theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {super.key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget});

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TAppTheme.titleStyle,
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 14),
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                    child:TextFormField(
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      readOnly: widget==null?false:true,
                      autofocus: false,
                      cursorColor: Colors.grey,
                      controller: controller,
                      style: TAppTheme.subTitleStyle,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TAppTheme.subTitleStyle,
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black87,
                            width: 0

                          )
                        ),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black87,
                                width: 0

                            )
                        ),
                      ),

                    ),
                ),
                widget==null?Container():Container(child: widget,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
