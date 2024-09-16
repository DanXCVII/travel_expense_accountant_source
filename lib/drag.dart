import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp_abrechner/bloc/formular/formular_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gp_abrechner/util/custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExampleDragTarget extends StatefulWidget {
  const ExampleDragTarget({super.key});

  @override
  State<ExampleDragTarget> createState() => _ExampleDragTargetState();
}

class _ExampleDragTargetState extends State<ExampleDragTarget> {
  bool _dragging = false;

  Future<void> pickFile(context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'JPEG', 'JPG']);
      if (result != null) {
        // File picked successfully
        List<Uint8List?> invoices =
            result.files.map((file) => file.bytes).toList();
        List<String> names = result.files.map((file) => file.name).toList();

        // get all indexes of null values of invoices
        List<Uint8List> invoicesNonNull = [];
        for (var i = invoices.length - 1; i >= 0; i--) {
          if (invoices[i] == null) {
            names.removeAt(i);
          } else {
            invoicesNonNull.add(invoices[i]!);
          }
        }

        List<String> allowedImageExtensions = [
          '.png',
          '.jpg',
          '.jpeg',
          '.JPEG',
          '.JPG'
        ];

        BlocProvider.of<FormularBloc>(context)
            .add(FormularAddInvoicesEvent(invoicesNonNull, names));
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return DropTarget(
      onDragDone: (detail) {
        List<String> allowedImageExtensions = [
          '.pdf',
          '.png',
          '.jpg',
          '.jpeg',
          '.JPEG',
          '.JPG'
        ];
        List<String> names = detail.files.map((file) => file.name).toList();
        Set<String> namesFileExtensions =
            names.map((e) => e.substring(e.lastIndexOf('.'), e.length)).toSet();

        for (String extension in allowedImageExtensions) {
          namesFileExtensions.remove(extension);
        }
        if (namesFileExtensions.isNotEmpty) {
          Fluttertoast.showToast(
            msg: "Only .pdf, .png, .jpg, .jpeg, .JPEG, .JPG files are allowed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            webBgColor: "#000000",
            // backgroundColor: Colors.red,
            // textColor: Colors.white,
            fontSize: 16.0,
          );
        }

        List<XFile> allowedFiles = [];
        for (String extension in allowedImageExtensions) {
          allowedFiles.addAll(detail.files
              .where((file) => file.name.endsWith(extension))
              .toList());
        }
        BlocProvider.of<FormularBloc>(context).add(FormularDragInvoiceEvent(
          allowedFiles,
          allowedFiles.map((file) => file.name).toList(),
        ));
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
        });
      },
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(189, 189, 189, 1),
                width: 1,
              ),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              color: _dragging
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.white.withOpacity(0.1),
            ),
            child: BlocBuilder<FormularBloc, FormularState>(
              bloc: BlocProvider.of<FormularBloc>(context),
              builder: (context, state) {
                List<String> _list = [];
                if (state is FormularProcessing) {
                  _list = state.invoices.keys.toList();
                } else if (state is FormularFinished) {
                  _list = state.invoices.keys.toList();
                }
                return _list.isEmpty
                    ? Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Text(
                              textAlign: TextAlign.center,
                              AppLocalizations.of(context)!.dropFilesHere),
                        ),
                      )
                    : GridView.count(
                        crossAxisCount: deviceWidth > 600
                            ? (deviceWidth / 2) ~/ 190
                            : deviceWidth ~/ 150,
                        childAspectRatio: (1 / 0.5),
                        children: List.generate(
                          _list.length,
                          (index) => Stack(
                            children: [
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    )
                                  ],
                                  color:
                                      const Color.fromARGB(255, 106, 100, 133),
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 10, 9, 9),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                margin: const EdgeInsets.all(8),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.picture_as_pdf),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          _list[index],
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    BlocProvider.of<FormularBloc>(context).add(
                                        FormularRemoveInvoiceEvent(
                                            _list[index]));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CustomRoundedRectangleBorder(
                  bottomLeftRadius: 8,
                  bottomRightRadius: 8,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: () {
                pickFile(context);
              },
              child: Text(AppLocalizations.of(context)!.selectInvoice),
            ),
          ),
        ],
      ),
    );
  }
}
