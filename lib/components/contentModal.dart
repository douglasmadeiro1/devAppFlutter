// ignore: file_names
import 'package:dev_app/models/contentModel.dart';
import 'package:dev_app/services/content_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

showModalContent(BuildContext context,
    {required String subjectId,
    ContentModel? content,
    required String contentId}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color.fromARGB(255, 174, 245, 192),
    isDismissible: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return ContentModal(
        contentModel: content,
        subjectId: subjectId,
        contentId: contentId,
      );
    },
  );
}

class ContentModal extends StatefulWidget {
  final ContentModel? contentModel;
  final String subjectId;
  final String contentId;
  const ContentModal({
    super.key,
    this.contentModel,
    required this.subjectId,
    required this.contentId,
  });

  @override
  State<ContentModal> createState() => _ContentModalState();
}

class _ContentModalState extends State<ContentModal> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _contentTitleController = TextEditingController();

  bool isLoading = false;

  final ContentService _contentService = ContentService();

  @override
  void initState() {
    if (widget.contentModel != null) {
      _contentController.text = widget.contentModel!.content;
      _contentTitleController.text = widget.contentModel!.contentTitle;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // : Text(widget.contentModel != null
                //               ? "Salvar edição"
                //               : "Adicionar"),

                Text(
                  (widget.contentModel != null)
                      ? "Editar ${widget.contentModel?.contentTitle}?"
                      : 'Qual o conteudo a ser adicionado a ${widget.subjectId}',
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  maxLines: null,
                  controller: _contentTitleController,
                  decoration: const InputDecoration(
                    labelText: 'Titulo',
                  ),
                ),
                TextFormField(
                  maxLines: null,
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Conteudo',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        sendClicked();
                      },
                      child: (isLoading)
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 4, 87, 212),
                              ),
                            )
                          : Text(widget.contentModel != null
                              ? "Salvar edição"
                              : "Adicionar"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendClicked() {
    setState(() {
      isLoading = true;
    });
    String contentName = _contentController.text;
    String contentTitle = _contentTitleController.text;

    ContentModel content = ContentModel(
      contentId: const Uuid().v1(),
      content: contentName,
      contentTitle: contentTitle,
    );

    if (widget.contentModel != null) {
      content.contentId = widget.contentModel!.contentId;
      _contentService
          .updateContent(
              subjectId: widget.subjectId,
              contentId: widget.contentId,
              contentModel: content)
          .then((value) {
        setState(() {
          isLoading = false;
          Navigator.pop(context);
        });
      });
    } else {
      // Caso contrário, estamos adicionando um novo conteúdo
      _contentService
          .addContent(subjectId: widget.subjectId, contentModel: content)
          .then((value) {
        setState(() {
          isLoading = false;
          Navigator.pop(context);
        });
      });
    }
  }
}
