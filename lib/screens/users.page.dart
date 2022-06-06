import 'package:bitirme_proje/screens/library_of_user_page.dart';
import 'package:bitirme_proje/screens/other_profiles_page.dart';
import 'package:bitirme_proje/services/firebase_auth_services.dart';
import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersPage extends ConsumerStatefulWidget {
  UsersPage({Key? key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  final FirebaseDatabaseService _firebaseDatabaseService =
      FirebaseDatabaseService();
  final FirebaseAuthService _authService = FirebaseAuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Kullanıcılar")),
        body: StreamBuilder(
            stream: _firebaseDatabaseService.fetchUsers(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index) {
                      if (_authService.getCurrentUser()!.uid ==
                          snapshot.data!.docs.elementAt(index).get("userID")) {
                        return Container();
                      } else {
                        return ListTileTheme(
                            contentPadding: EdgeInsets.all(8),
                            selectedColor: Color.fromARGB(255, 19, 2, 2),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => OtherProfilesPage(
                                              elemenAt: snapshot.data!.docs
                                                  .elementAt(index),
                                            )));
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 50,
                                  foregroundImage: NetworkImage(snapshot
                                      .data!.docs
                                      .elementAt(index)
                                      .get("profilImage")),
                                ),
                                title: Text(snapshot.data!.docs
                                    .elementAt(index)
                                    .get('nameSurname')),
                              ),
                            ));
                      }
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                );
              }
            }));
  }
}
