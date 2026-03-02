import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/app_widgets/app_input_decoration.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_text_style.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String Function(T item) labelBuilder;
  final void Function(T?)? onChanged;
  final String? hint;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: inputDecoration(hint ?? ""),
      style: appTextStyle(fontSize: 12),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: textWidget(text: labelBuilder(item), fontSize: 12),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
