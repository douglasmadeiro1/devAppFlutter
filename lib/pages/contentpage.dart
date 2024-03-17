import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_app/components/contentModal.dart';
import 'package:dev_app/models/contentModel.dart';
import 'package:dev_app/services/content_service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ContentPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final subjectModel;
  final String subjectId;
  final String userId;
  final String contentId;
  final String contentTitle;

  const ContentPage({
    super.key,
    required this.subjectModel,
    required this.subjectId,
    required this.userId,
    required this.contentId,
    required this.contentTitle,
  });

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  late final ContentService service;

  @override
  void initState() {
    super.initState();
    service = ContentService();
  }

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
          FutureBuilder<DocumentSnapshot>(
            future: service.getContent(
              subjectId: widget.subjectId,
              contentId: widget.contentId,
            ),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Erro ao carregar o conteúdo');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (widget.subjectId.isEmpty) {
                throw Exception('O subjectId não pode ser vazio.');
              }

              // Verifica se o documento existe
              if (snapshot.data?.exists ?? false) {
                // Converte o documento em um objeto ContentModel
                ContentModel contentModel = ContentModel.fromMap(
                    snapshot.data!.data() as Map<String, dynamic>);
                // Exibe o conteúdo sem formatação
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      height: 1000,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 5, 5, 5),
                      ),
                      child: Column(
                        children: [
                          Text(
                            contentModel.content,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Text('Conteúdo não encontrado');
              }
            },
          )
        ],
      ),
    );
  }
}
