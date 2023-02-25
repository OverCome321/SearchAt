import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

var suggestTag = [
  "Unity",
  "Flutter",
  "Dart",
  "C#",
  "Java",
  "JavaScript",
  "Python",
  "SQL",
  "DataBases",
  "Web",
  "Sites",
  "Mobile",
  "Applications",
  "Art",
  "Drawing",
  "SoundDesign",
  "GameDesign",
  "C++",
];

class TagStateController extends GetxController {
  var listTags = List<String>.empty(growable: true).obs;
}

class TagsField extends StatefulWidget {
  @override
  _TagsFieldState createState() => _TagsFieldState();
}

class _TagsFieldState extends State<TagsField> {
  final controller = Get.put(TagStateController());
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: textController,
            onEditingComplete: () {
              if (!controller.listTags.contains(textController.text) &&
                  controller.listTags.length < 5) {
                controller.listTags.add(textController.text);
              }
              textController.clear();
            },
            autofocus: false,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.tags,
            ),
          ),
          suggestionsCallback: (String pattern) {
            return suggestTag.where((element) =>
                element.toLowerCase().contains(pattern.toLowerCase()));
          },
          onSuggestionSelected: (String suggestion) {
            if (!controller.listTags.contains(suggestion) &&
                controller.listTags.length < 5) {
              controller.listTags.add(suggestion);
            }
            textController.clear();
          },
          itemBuilder: (context, itemData) {
            return ListTile(
              leading: Icon(Icons.tag),
              title: Text(itemData),
            );
          },
        ),
        SizedBox(height: 10),
        Obx(() => controller.listTags.isEmpty
            ? Center(
                child: Text(AppLocalizations.of(context)!.hinttags),
              )
            : Wrap(
                children: controller.listTags
                    .map(
                      (element) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Chip(
                          label: Text(element),
                          deleteIcon: Icon(Icons.clear),
                          onDeleted: () => controller.listTags.remove(element),
                        ),
                      ),
                    )
                    .toList(),
              ))
      ],
    );
  }
}
