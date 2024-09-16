import 'dart:typed_data';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp_abrechner/bloc/formular/formular_bloc.dart';
import 'package:flutter_gp_abrechner/util/text_scale.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentView extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController streetController;
  final TextEditingController zipCityController;
  final TextEditingController accountHolderController;
  final TextEditingController ibanController;
  final TextEditingController bicController;
  final TextEditingController bankController;
  final TextEditingController occasionController;
  final TextEditingController dateController;
  final TextEditingController destinationController;
  final TextEditingController ownContributionController;
  final TextEditingController passengersController;

  const DocumentView({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.streetController,
    required this.zipCityController,
    required this.accountHolderController,
    required this.ibanController,
    required this.bicController,
    required this.bankController,
    required this.occasionController,
    required this.dateController,
    required this.destinationController,
    required this.ownContributionController,
    required this.passengersController,
  });

  @override
  State<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {
  PdfControllerPinch pdfController = PdfControllerPinch(
    document: PdfDocument.openAsset('assets/Fahrtkosten.pdf'),
  );
  UniqueKey pdfKey = UniqueKey();
  Uint8List pdfBytes = Uint8List(0);
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  void initState() {
    super.initState();
    pdfKey = UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 30;

    return BlocListener(
      bloc: BlocProvider.of<FormularBloc>(context),
      listener: (context, state) {
        if (state is FormularInitialized) {
          widget.firstNameController.text = state.initializedDocument.firstName;
          widget.lastNameController.text = state.initializedDocument.lastName;
          widget.streetController.text = state.initializedDocument.street;
          widget.zipCityController.text = state.initializedDocument.zipCity;
          widget.accountHolderController.text =
              state.initializedDocument.accountHolder;
          widget.ibanController.text = state.initializedDocument.iban;
          widget.bicController.text = state.initializedDocument.bic;
          widget.bankController.text = state.initializedDocument.bank;
          widget.occasionController.text = state.initializedDocument.occasion;
          widget.dateController.text = state.initializedDocument.when;
          widget.destinationController.text =
              state.initializedDocument.destination;
          widget.ownContributionController.text =
              state.initializedDocument.ownContribution;
          widget.passengersController.text =
              state.initializedDocument.passengers;
        } else if (state is FormularFinished) {
          pdfController = PdfControllerPinch(
            document: PdfDocument.openData(
              Uint8List.fromList(state.finalPdf),
            ),
            viewportFraction: 0.8,
          );
          pdfBytes = Uint8List.fromList(state.finalPdf);
          setState(() {
            pdfKey = UniqueKey();
          });
        }
      },
      child: BlocBuilder(
        bloc: BlocProvider.of<FormularBloc>(context),
        builder: (context, state) {
          if (state is FormularFinished) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 32,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  bottomRight: Radius.circular(borderRadius),
                ),
                child:
                    // SfPdfViewer.memory(key: pdfKey, pdfBytes)

                    PdfViewPinch(
                  key: pdfKey,
                  padding: 2,
                  backgroundDecoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color.fromRGBO(117, 117, 117, 1),
                    Color.fromRGBO(238, 238, 238, 1),
                  ])),
                  controller: pdfController,
                  scrollDirection: Axis.vertical,
                  onDocumentError: (error) => print("error: $error"),
                  onPageChanged: (page) {},
                ),
              ),
            );
          } else {
            // return Stack(
            //   children: [
            //     SfPdfViewer.asset(
            //       'assets/Fahrtkosten.pdf',
            //       controller: _pdfViewerController,
            //     ),
            //     FloatingActionButton(onPressed: () {
            //       print(_pdfViewerController
            //           .getFormFields()
            //           .map((elem) => elem.name)
            //           .toList());

            //       final List<PdfFormField> formFields =
            //           _pdfViewerController.getFormFields();
            //       final PdfTextFormField textbox = formFields.singleWhere(
            //               (PdfFormField formField) =>
            //                   formField.name == 'Eigenbeitrag_Mirror')
            //           as PdfTextFormField;
            //       print(textbox.readOnly);
            //       textbox.readOnly = false;
            //       textbox.text = '10';
            //     })
            //   ],
            // );
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height - 32,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    bottomRight: Radius.circular(borderRadius),
                  ),
                ),
                child: AnimateGradient(
                  duration: const Duration(seconds: 6),
                  primaryColors: const [
                    Color.fromARGB(255, 84, 71, 158),
                    Color.fromARGB(255, 29, 18, 93)
                  ],
                  secondaryColors: const [
                    Color.fromARGB(255, 32, 25, 47),
                    Color.fromARGB(255, 70, 60, 77)
                  ],
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              textScaler: TextScaler.linear(
                                  ScaleSize.textScaleFactor(context)),
                              AppLocalizations.of(context)!.pdfPreview,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          textScaler: TextScaler.linear(
                              ScaleSize.textScaleFactor(context)),
                          AppLocalizations.of(context)!.documentUseExplanation,
                          style: const TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 13,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            textScaler: TextScaler.linear(
                                ScaleSize.textScaleFactor(context)),
                            AppLocalizations.of(context)!.tipp,
                            style: const TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ),
                        Text(
                          textScaler: TextScaler.linear(
                              ScaleSize.textScaleFactor(context)),
                          AppLocalizations.of(context)!.tipDesc,
                          style: const TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 13,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
