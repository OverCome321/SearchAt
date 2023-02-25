import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Ideas/Create%20Ideas/create_edit_idea.dart';
import 'package:flutter_application_1/Ideas/Idea%20card/idea_card.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenCreateState createState() => _FavoritesScreenCreateState();
}

class _FavoritesScreenCreateState extends State<FavoritesScreen> {
  final currentUsser = FirebaseAuth.instance.currentUser;
  _email() async {
    if (currentUsser != null)
      await FirebaseFirestore.instance
          .collection('favorites')
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
          'Favorites',
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
            .collection('favorites')
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
          return SizedBox();
        }),
      ),
    );
  }
}
