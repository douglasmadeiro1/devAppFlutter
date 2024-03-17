


// // ignore: file_names
// import 'package:dev_app/components/decoration_auth.dart';
// import 'package:dev_app/models/contentModel.dart';
// import 'package:dev_app/services/content_service.dart';
// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';

// showModalContent(BuildContext context,
//     {required String subjectId,
//     ContentModel? content,
//     required String contentId}) {
//   showModalBottomSheet(
//     context: context,
//     backgroundColor: const Color.fromARGB(255, 174, 245, 192),
//     isDismissible: true,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(
//         top: Radius.circular(20),
//       ),
//     ),
//     builder: (context) {
//       return ContentModal(
//         contentModel: content,
//         subjectId: subjectId,
//       );
//     },
//   );
// }

// class ContentModal extends StatefulWidget {
//   final ContentModel? contentModel;
//   final String subjectId;
//   const ContentModal({super.key, this.contentModel, required this.subjectId});

//   @override
//   State<ContentModal> createState() => _ContentModalState();
// }

// class _ContentModalState extends State<ContentModal> {
//   final TextEditingController _contentController = TextEditingController();
//   final TextEditingController _contentTitleController = TextEditingController();

//   bool isLoading = false;

//   final ContentService _contentService = ContentService();

//   @override
//   void initState() {
//     if (widget.contentModel != null) {
//       _contentController.text = widget.contentModel!.content;
//       _contentTitleController.text = widget.contentModel!.contentTitle;
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         (widget.contentModel != null)
//                             ? "Editar ${widget.contentModel!.content}"
//                             : "Adicionar Novo assunto:",
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: const Icon(
//                           Icons.close_rounded,
//                           color: Color.fromARGB(255, 10, 10, 10),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Divider(color: Color.fromARGB(255, 1, 1, 1)),
//                   Column(
//                     children: [
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         maxLines: null,
//                         controller: _contentTitleController,
//                         decoration: getAuthenticationInputDecoration(
//                           "Titulo",
//                           icon: const Icon(Icons.abc),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         maxLines: null,
//                         controller: _contentController,
//                         decoration: getAuthenticationInputDecoration(
//                           "Conteudo",
//                           icon: const Icon(Icons.abc),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                     ],
//                   ),
//                 ],
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   sendClicked();
//                 },
//                 child: (isLoading)
//                     ? const SizedBox(
//                         height: 16,
//                         width: 16,
//                         child: CircularProgressIndicator(
//                           color: Color.fromARGB(255, 4, 87, 212),
//                         ),
//                       )
//                     : Text(widget.contentModel != null
//                         ? "Salvar edição"
//                         : "Adicionar"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   sendClicked() {
//     setState(() {
//       isLoading = true;
//     });
//     String contentName = _contentController.text;
//     String contentTitle = _contentTitleController.text;

//     if (widget.contentModel != null) {
//       // Cria um novo ContentModel com os valores atualizados
//       ContentModel updatedContent = ContentModel(
//         contentId: widget.contentModel!.contentId, // Mantém o mesmo contentId
//         contentTitle: contentTitle,
//         content: contentName,
//       );

//       // Chama o método de atualização
//       _contentService
//           .updateContent(
//               subjectId: widget.subjectId, contentModel: updatedContent)
//           .then((value) {
//         setState(() {
//           isLoading = false;
//           Navigator.pop(context);
//         });
//       });
//     } else {
//       // Gera um novo contentId para um novo conteúdo
//       ContentModel newContent = ContentModel(
//         contentId: const Uuid().v1(),
//         contentTitle: contentTitle,
//         content: contentName,
//       );

//       // Chama o método para adicionar um novo conteúdo
//       _contentService
//           .addContent(subjectId: widget.subjectId, contentModel: newContent)
//           .then((value) {
//         setState(() {
//           isLoading = false;
//           Navigator.pop(context);
//         });
//       });
//     }
//   }
// }
