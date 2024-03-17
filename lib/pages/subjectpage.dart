import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_app/components/contentModal.dart';
import 'package:dev_app/models/contentModel.dart';
import 'package:dev_app/pages/contentpage.dart';
import 'package:dev_app/services/content_service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SubjectPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final subjectModel;

  const SubjectPage({
    super.key,
    required this.subjectModel,
    required String subjectId,
  });

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  final ContentService service = ContentService();

  late Stream<QuerySnapshot> subCollectionStream;

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
                  showModalContent(context,
                      subjectId: widget.subjectModel.subjectId, contentId: '');
                },
                icon: const Icon(Icons.add),
                color: Colors.white,
              ),
            ],
          )
        ],
        backgroundColor: (Colors.black),
      ),
      body: Stack(
        children: [
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
            stream: service.connectStreamContent(
                subjectId: widget.subjectModel.subjectId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.docs.isNotEmpty) {
                  List<ContentModel> contentList = [];

                  for (var doc in snapshot.data!.docs) {
                    contentList.add(ContentModel.fromMap(doc.data()));
                  }

                  return ListView.builder(
                    itemCount: contentList.length,
                    itemBuilder: (context, index) {
                      ContentModel contentModel = contentList[index];
                      return Card(
                        elevation: 10,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContentPage(
                                  subjectModel: null,
                                  subjectId: widget.subjectModel.subjectId,
                                  userId: service.userId,
                                  contentId: contentModel.contentId,
                                  contentTitle: contentModel.contentTitle,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListTile(
                              leading: const CircleAvatar(
                                  // backgroundImage: const NetworkImage(),
                                  ),
                              title: Text(
                                contentModel.contentTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      showModalContent(
                                        context,
                                        subjectId:
                                            widget.subjectModel.subjectId,
                                        content:
                                            contentModel, // Passe o contentModel corretamente
                                        contentId: contentModel
                                            .contentId, // Passe o contentId corretamente
                                      );
                                    },
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      SnackBar snackBar = SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          "Deseja remover ${contentModel.contentTitle}?",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        action: SnackBarAction(
                                          label: "Remover",
                                          onPressed: () {
                                            service.deleteContent(
                                              subjectId:
                                                  widget.subjectModel.subjectId,
                                              contentId: contentModel.contentId,
                                            );
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  );
                }
              }
            },
          )
        ],
      ),
    );
  }
}
