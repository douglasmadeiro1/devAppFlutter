import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_app/components/subjectModal.dart';
import 'package:dev_app/models/subjectModel.dart';
import 'package:dev_app/pages/subjectpage.dart';
import 'package:dev_app/services/authentication_service_final.dart';
import 'package:dev_app/services/subject_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});
  final User user;

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SubjectService service = SubjectService();
  bool isDescending = false;

  get subjectModel => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text(
              "App estudos",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(
                    () {
                      isDescending = !isDescending;
                    },
                  );
                },
                icon: const Icon(Icons.sort_by_alpha_rounded),
              ),
              IconButton(
                onPressed: () {
                  showModalSubject(context);
                },
                icon: const Icon(Icons.add),
                color: Colors.white,
              ),
            ],
          )
        ],
        backgroundColor: (Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/profile.png"),
              ),
              accountName: Text((widget.user.displayName != null)
                  ? widget.user.displayName!
                  : ""),
              accountEmail: Text(widget.user.email!),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.logout),
                  title: const Text(
                    "Sair",
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    AuthenticationService().logout();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 251, 131, 45),
                Color.fromARGB(255, 254, 249, 97),
              ],
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: service.connectStreamSubject(isDescending),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.docs.isNotEmpty) {
                List<SubjectModel> subjectList = [];

                for (var doc in snapshot.data!.docs) {
                  subjectList.add(SubjectModel.fromMap(doc.data()));
                }

                return ListView.builder(
                  itemCount: subjectList.length,
                  itemBuilder: (context, index) {
                    SubjectModel subjectModel = subjectList[index];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        // trailing: IconButton(
                        //   icon: const Icon(Icons.edit),
                        //   onPressed: () {
                        //     showModalSubject(context, subject: subjectModel);
                        //   },
                        // ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubjectPage(
                                subjectModel: subjectModel,
                                subjectId: subjectModel.subjectId,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            leading: const CircleAvatar(),
                            title: Text(
                              subjectModel.subject,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    showModalSubject(context,
                                        subject: subjectModel);
                                  },
                                ),
                                IconButton(
                                  onPressed: () {
                                    SnackBar snackBar = SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        "Deseja remover ${subjectModel.subject}?",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      action: SnackBarAction(
                                        label: "Remover",
                                        onPressed: () {
                                          service.deleteSubject(
                                              subjectId:
                                                  subjectModel.subjectId);
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'Nenhum conteudo enviado',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                );
              }
            }
          },
        )
      ]),
    );
  }
}
