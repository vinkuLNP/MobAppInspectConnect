import 'package:flutter/material.dart';
import '../../../utils/text_editor_controller.dart';
import '../../client/widgets/input_fields.dart';

Future<List<T>> showMultiSelectSearchDialog<T>({
  required BuildContext context,
  required List<T> items,
  required String Function(T) itemAsString,
  required String title,
  required List<T> initiallySelected,
}) async {
  List<T> filtered = List.from(items);
  List<T> selectedItems = List.from(initiallySelected);

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: double.maxFinite,
              height: 450,
              child: Column(
                children: [
                  AppInputField(
                    label: "Search Cities",
                    hint: "Search Cities",
                    controller: inspCountrySearchCtrl,
                    onChanged: (value) {
                      setState(() {
                        filtered = items
                            .where(
                              (item) => itemAsString(
                                item,
                              ).toLowerCase().contains(value!.toLowerCase()),
                            )
                            .toList();
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, index) {
                        final item = filtered[index];
                        final label = itemAsString(item);
                        final isSelected = selectedItems.contains(item);

                        return CheckboxListTile(
                          title: Text(label),
                          value: isSelected,
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                selectedItems.add(item);
                              } else {
                                selectedItems.remove(item);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  inspCountrySearchCtrl.clear();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, selectedItems);
                  inspCountrySearchCtrl.clear();
                },
                child: const Text("Done"),
              ),
            ],
          );
        },
      );
    },
  );

  return selectedItems;
}

Future<T?> showSearchableListDialog<T>({
  required BuildContext context,
  required List<T> items,
  required String Function(T) itemAsString,
  required String title,
}) {
  List<T> filtered = List.from(items);

  return showDialog<T>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  AppInputField(
                    label: "Search $title",
                    hint: "Search $title",
                    controller: inspCountrySearchCtrl,
                    onChanged: (value) {
                      setState(() {
                        filtered = items
                            .where(
                              (item) => itemAsString(
                                item,
                              ).toLowerCase().contains(value!.toLowerCase()),
                            )
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return ListTile(
                          title: Text(itemAsString(item)),
                          onTap: () {
                            Navigator.pop(context, item);
                            inspCountrySearchCtrl.clear();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
