import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Ideas/Description/edit_description_page.dart';
import 'package:flutter_application_1/Ideas/Tags/tags.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateEditIdeaPage extends StatefulWidget {
  final QuerySnapshot? data;
  final int? index;
  final bool editing;

  const CreateEditIdeaPage({
    Key? key,
    this.data,
    this.index,
    required this.editing,
  }) : super(key: key);

  @override
  _CreateEditIdeaPageState createState() => _CreateEditIdeaPageState();
}

class _CreateEditIdeaPageState extends State<CreateEditIdeaPage> {
  String? email;
  final controller = Get.put(TagStateController());
  final ideaTitleTextField = TextEditingController();

  var description = '';
  var contacts = [];
  var tags = [];
  final now = new DateTime.now();

  var icons = [
    Icons.email,
    Icons.telegram,
    Icons.whatsapp,
    Icons.facebook,
    Icons.smartphone
  ];
  void initState() {
    super.initState();
    ideaTitleTextField.text = widget.data?.docs[widget.index!]['title'] ?? '';
    description = widget.data?.docs[widget.index!]['description'] ?? '';
    tags = widget.data?.docs[widget.index!]['tags'] ?? [];
    controller.listTags.value = tags.cast<String>();
    contacts = widget.data?.docs[widget.index!]['contacts'] ?? [];
    LoadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference ideas = FirebaseFirestore.instance.collection('ideas');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            widget.editing == true
                ? email == widget.data!.docs[widget.index!]['user_email']
                    ? ideaTitle()
                    : Column(
                        children: [
                          Text(
                            ideaTitleTextField.text,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                : ideaTitle(),
            widget.editing == true
                ? email == widget.data!.docs[widget.index!]['user_email']
                    ? aboutField()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            height: 10,
                            thickness: 1.5,
                            color: Colors.black,
                          ),
                          SizedBox(height: 10),
                          Text(
                            description,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                : aboutField(),
            SizedBox(height: 15),
            Text(
              AppLocalizations.of(context)!.tags,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
            widget.editing == false
                ? Column(children: [SizedBox(height: 35), TagsField()])
                : email == widget.data!.docs[widget.index!]['user_email']
                    ? TagsField()
                    : Wrap(
                        spacing: 8,
                        children: tags
                            .map((element) => Chip(
                                  label: Text(element),
                                ))
                            .toList(),
                      ),
            SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.contacts,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: buildContacts(),
            ),
            widget.editing == false
                ? IconButton(
                    onPressed: (() => setState(() {
                          if (contacts.length < 3) {
                            contacts.add('');
                          }
                        })),
                    icon: Icon(Icons.add))
                : email == widget.data!.docs[widget.index!]['user_email']
                    ? IconButton(
                        onPressed: (() => setState(() {
                              if (contacts.length < 3) {
                                contacts.add('');
                              }
                            })),
                        icon: Icon(Icons.add))
                    : SizedBox.shrink(),
            widget.editing == false
                ? ElevatedButton(
                    onPressed: () {
                      ideaTitleTextField.text.trim().isNotEmpty &&
                              description.trim().isNotEmpty &&
                              controller.listTags.isNotEmpty &&
                              contacts.isNotEmpty
                          ? ideas.add(
                              {
                                'title': ideaTitleTextField.text.trim(),
                                'description': description.trim(),
                                'tags': controller.listTags,
                                'contacts': contacts,
                                'date': DateFormat('dd.MM.yyyy').format(now),
                                // Новое поле для добавления имейла
                                'user_email': email,
                              },
                            ).then(
                              (value) {
                                print('Idea added!');
                                Navigator.of(context).pop(context);
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.success(
                                    message: AppLocalizations.of(context)!
                                        .ideaspublishmessage,
                                  ),
                                );
                              },
                            ).catchError((error) =>
                              AppLocalizations.of(context)!.ideafailedmessage)
                          : showTopSnackBar(
                              context,
                              CustomSnackBar.error(
                                message: AppLocalizations.of(context)!
                                    .warningoffield,
                              ),
                            );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.publish,
                      style: TextStyle(fontSize: 25),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      backgroundColor: Color.fromARGB(255, 102, 192, 105),
                    ),
                  )
                : email == widget.data!.docs[widget.index!]['user_email']
                    ? Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              ideaTitleTextField.text.trim().isNotEmpty &&
                                      description.trim().isNotEmpty &&
                                      controller.listTags.isNotEmpty &&
                                      contacts.isNotEmpty
                                  ? FirebaseFirestore.instance
                                      .collection('ideas')
                                      .doc(widget.data?.docs[widget.index!].id)
                                      .update(
                                      {
                                        'title': ideaTitleTextField.text.trim(),
                                        'description': description.trim(),
                                        'tags': controller.listTags,
                                        'contacts': contacts,
                                        'date': DateFormat('dd.MM.yyyy')
                                            .format(now),
                                      },
                                    ).then(
                                      (value) {
                                        showTopSnackBar(
                                          context,
                                          CustomSnackBar.success(
                                            message:
                                                AppLocalizations.of(context)!
                                                    .warningoffield,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      },
                                    )
                                  : showTopSnackBar(
                                      context,
                                      CustomSnackBar.error(
                                        message: AppLocalizations.of(context)!
                                            .ideaupdatemessage,
                                      ),
                                    );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.save,
                              style: TextStyle(fontSize: 25),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              backgroundColor:
                                  Color.fromARGB(255, 102, 192, 105),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showTopSnackBar(
                                context,
                                CustomSnackBar.info(
                                  message: AppLocalizations.of(context)!
                                      .ideawasdeletedmessage,
                                ),
                              );
                              FirebaseFirestore.instance
                                  .collection('ideas')
                                  .doc(widget.data?.docs[widget.index!].id)
                                  .delete();
                              Navigator.pop(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.delete,
                              style: TextStyle(fontSize: 25),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              backgroundColor:
                                  Color.fromARGB(255, 192, 102, 102),
                            ),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }

  Column ideaTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.ideatitle,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
        ),
        SizedBox(height: 15),
        TextFormField(
          autofocus: false,
          controller: ideaTitleTextField,
          maxLength: 50,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.ideahinttext,
            suffixIcon: IconButton(
              icon: Icon(Icons.clear_rounded),
              onPressed: () => ideaTitleTextField.clear(),
            ),
          ),
        ),
      ],
    );
  }

  InkWell aboutField() {
    return InkWell(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.about,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 35),
            description.isEmpty
                ? Text(
                    AppLocalizations.of(context)!.aboutideahinttext,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  )
                : Text(
                    description,
                    style: TextStyle(fontSize: 16),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
            Divider(
              height: 45,
              thickness: 0.9,
              color: Colors.grey[500],
            ),
          ],
        ),
      ),
      onTap: () async {
        final descriptionVal = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DescriptionPage(description: description),
          ),
        );
        setState(() {
          description = descriptionVal;
        });
      },
    );
  }

  TextFormField contactField(index) {
    return TextFormField(
      initialValue: contacts[index],
      decoration: InputDecoration(
        suffixIcon: IconButton(
          color: Colors.grey,
          icon: Icon(Icons.delete),
          onPressed: () => setState(() {
            contacts.removeAt(index);
          }),
        ),
        prefixIcon: IconButton(
          icon: Icon(icons[0]),
          color: Colors.grey,
          onPressed: () => setState(() {}),
        ),
      ),
      onChanged: (value) {
        contacts[index] = value;
      },
    );
  }

  // Эта функция в реальном времени сохраняет инфу о текущем юзере и берет его имейл
  void LoadCurrentUser() async {
    final currentuser = await FirebaseAuth.instance.currentUser;
    setState(() {
      email = currentuser!.email;
    });
  }

  Widget buildContacts() => ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];

          return Card(
            key: Key(contact),
            elevation: 4,
            child: widget.editing == false
                ? contactField(index)
                : email == widget.data!.docs[widget.index!]['user_email']
                    ? contactField(index)
                    : Padding(
                        padding: EdgeInsets.only(top: 2, bottom: 2, left: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              contacts[index],
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: contacts[index]));
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.info(
                                    message: AppLocalizations.of(context)!
                                        .contactwascopied,
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.copy,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
          );
        },
      );
}
