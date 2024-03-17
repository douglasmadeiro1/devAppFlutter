// ignore: file_names

import 'package:dev_app/components/decoration_auth.dart';
import 'package:dev_app/models/subjectModel.dart';
import 'package:dev_app/services/subject_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

showModalSubject(BuildContext context, {SubjectModel? subject}) {
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
      return SubjectModal(
        subjectModel: subject,
      );
    },
  );
}

class SubjectModal extends StatefulWidget {
  final SubjectModel? subjectModel;
  const SubjectModal({super.key, this.subjectModel});

  @override
  State<SubjectModal> createState() => _SubjectModalState();
}

class _SubjectModalState extends State<SubjectModal> {
  final TextEditingController _subjectCtlr = TextEditingController();

  bool isLoading = false;

  final SubjectService _subjectService = SubjectService();

  @override
  void initState() {
    if (widget.subjectModel != null) {
      _subjectCtlr.text = widget.subjectModel!.subject;
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
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (widget.subjectModel != null)
                              ? "Editar ${widget.subjectModel!.subject}"
                              : "Adicionar Novo assunto:",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Color.fromARGB(255, 10, 10, 10),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color.fromARGB(255, 1, 1, 1)),
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        TextFormField(
                          maxLines: null,
                          controller: _subjectCtlr,
                          decoration: getAuthenticationInputDecoration(
                            "Assunto",
                            icon: const Icon(Icons.abc),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ],
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
                      : Text(widget.subjectModel != null
                          ? "Salvar edição"
                          : "Adicionar"),
                ),
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

    String subjectName = _subjectCtlr.text;

    SubjectModel subject = SubjectModel(
      subjectId: const Uuid().v1(),
      subject: subjectName,
    );
    if (widget.subjectModel != null) {
      subject.subjectId = widget.subjectModel!.subjectId;
    }
    _subjectService.addSubject(subject).then(
      (value) {
        setState(
          () {
            isLoading = false;
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
