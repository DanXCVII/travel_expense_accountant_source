import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp_abrechner/bloc/formular/formular_bloc.dart';
import 'package:flutter_gp_abrechner/document_view.dart';
import 'package:flutter_gp_abrechner/drag.dart';
import 'package:flutter_gp_abrechner/form.dart';
import 'package:flutter_gp_abrechner/util/text_scale.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserInputFormular extends StatefulWidget {
  const UserInputFormular({super.key});

  @override
  State<UserInputFormular> createState() => _UserInputFormularState();
}

class _UserInputFormularState extends State<UserInputFormular> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController zipCityController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController accountHolderController = TextEditingController();
  final TextEditingController ibanController = TextEditingController();
  final TextEditingController bicController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController occasionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController ownContributionController =
      TextEditingController();
  final TextEditingController passengersController = TextEditingController();
  PdfControllerPinch pdfController = PdfControllerPinch(
    document: PdfDocument.openAsset('assets/Fahrtkosten.pdf'),
  );

  final formKey = GlobalKey<FormState>();

  Map<String, TextEditingController> textFields = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 30;
    var infoForm = InfoForm(
      firstNameController: firstNameController,
      lastNameController: lastNameController,
      streetController: streetController,
      zipCityController: zipCityController,
      accountHolderController: accountHolderController,
      ibanController: ibanController,
      bicController: bicController,
      bankController: bankController,
      occasionController: occasionController,
      dateController: dateController,
      destinationController: destinationController,
      ownContributionController: ownContributionController,
      passengersController: passengersController,
      formKey: formKey,
    );
    var documentView = DocumentView(
      firstNameController: firstNameController,
      lastNameController: lastNameController,
      streetController: streetController,
      zipCityController: zipCityController,
      accountHolderController: accountHolderController,
      ibanController: ibanController,
      bicController: bicController,
      bankController: bankController,
      occasionController: occasionController,
      dateController: dateController,
      destinationController: destinationController,
      ownContributionController: ownContributionController,
      passengersController: passengersController,
    );

    if (MediaQuery.of(context).size.width < 600) {
      return SingleChildScrollView(
          child: Column(
        children: [
          infoForm,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(height: 550, child: documentView),
          ),
        ],
      ));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DocumentView(
                firstNameController: firstNameController,
                lastNameController: lastNameController,
                streetController: streetController,
                zipCityController: zipCityController,
                accountHolderController: accountHolderController,
                ibanController: ibanController,
                bicController: bicController,
                bankController: bankController,
                occasionController: occasionController,
                dateController: dateController,
                destinationController: destinationController,
                ownContributionController: ownContributionController,
                passengersController: passengersController,
              )),
        ),
        Expanded(
          child: Container(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: infoForm,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
