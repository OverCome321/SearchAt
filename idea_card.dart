import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IdeaCard extends StatelessWidget {
  final data;
  final int index;

  IdeaCard({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUsser = FirebaseAuth.instance.currentUser;
    CollectionReference favorites =
        FirebaseFirestore.instance.collection('favorites');

    List tags = data.docs[index]['tags'];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
      child: Padding(
        padding: EdgeInsets.only(left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    '${data.docs[index]['title']}',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('${data.docs[index]['user_email']}'),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${data.docs[index]['description']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    spacing: 8,
                    children: tags
                        .map((element) => Chip(
                              label: Text(element),
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${data.docs[index]['date']}',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            // IconButton(
            //   onPressed: () {
            //     favorites.add({
            //       'user_email': currentUsser!.email,
            //       'idea_id': data.docs[index].id,
            //     });
            //   },
            //   splashColor: Colors.transparent,
            //   icon: Icon(
            //     Icons.favorite_border,
            //     size: 30,
            //     color: Colors.grey,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
