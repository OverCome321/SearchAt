import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Ideas/Create%20Ideas/create_edit_idea.dart';
import 'package:flutter_application_1/Ideas/Idea%20card/idea_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyIdeasScreen extends StatefulWidget {
  @override
  _MyIdeasScreenCreateState createState() => _MyIdeasScreenCreateState();
}

class _MyIdeasScreenCreateState extends State<MyIdeasScreen> {
  final currentUsser = FirebaseAuth.instance.currentUser;
  _email() async {
    if (currentUsser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUsser!.email)
          .get()
          .then((value) {})
          .catchError((e) {
        print(e);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          (AppLocalizations.of(context)!.myideas),
          style: TextStyle(
            color: Colors.black,
          ),
        ),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ideas')
            .where('user_email', isEqualTo: currentUsser!.email)
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;
          return ListView.builder(
            itemCount: data.size,
            itemBuilder: ((context, index) {
              return GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateEditIdeaPage(
                        data: data,
                        index: index,
                        editing: true,
                      ),
                    ),
                  );
                },
                child: IdeaCard(data: data, index: index),
              );
            }),
          );
        }),
      ),
    );
  }
}
