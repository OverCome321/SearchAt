import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DescriptionPage extends StatefulWidget {
  final String description;

  DescriptionPage({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  final _descrtiptionController = TextEditingController();
  late Color clearBtnColor;

  @override
  void initState() {
    _descrtiptionController.text = widget.description;
    _descrtiptionController.text.isNotEmpty
        ? setState(() => clearBtnColor = Colors.blue)
        : setState(() => clearBtnColor = Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.about,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.grey[50],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(context);
          },
          icon: Icon(
            Icons.close,
            size: 30,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Center(
              child: InkWell(
                child: Text(
                  AppLocalizations.of(context)!.clear,
                  style: TextStyle(
                    fontSize: 20,
                    color: clearBtnColor,
                  ),
                ),
                onTap: () {
                  if (_descrtiptionController.text.isNotEmpty) {
                    NAlertDialog(
                      dialogStyle: DialogStyle(titleDivider: true),
                      title: Text(AppLocalizations.of(context)!.clearall),
                      content: Text(
                        AppLocalizations.of(context)!.canceldescriptionmessage,
                      ),
                      actions: [
                        TextButton(
                          onPressed: (() {
                            _descrtiptionController.clear();
                            setState(() {
                              clearBtnColor = Colors.grey;
                            });
                            Navigator.pop(context);
                          }),
                          child: Text(
                            AppLocalizations.of(context)!.ok,
                          ),
                        ),
                        TextButton(
                          onPressed: (() {
                            Navigator.pop(context);
                          }),
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                          ),
                        ),
                      ],
                    ).show(context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: _descrtiptionController,
              maxLines: 20,
              autofocus: true,
              decoration: InputDecoration.collapsed(
                hintText: AppLocalizations.of(context)!.moreaboutideahinttext,
              ),
              onChanged: (value) {
                _descrtiptionController.text.isNotEmpty
                    ? setState(() => clearBtnColor = Colors.blue)
                    : setState(() => clearBtnColor = Colors.grey);
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(_descrtiptionController.text);
              },
              child: Text(
                AppLocalizations.of(context)!.save,
                style: TextStyle(fontSize: 24),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
                backgroundColor: Colors.green,
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
    );
  }
}
