import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp_abrechner/bloc/formular/formular_bloc.dart';
import 'package:flutter_gp_abrechner/drag.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gp_abrechner/main.dart';
import 'package:flutter_gp_abrechner/models/document.dart';
import 'package:flutter_gp_abrechner/util/custom_button.dart';
import 'package:flutter_gp_abrechner/util/text_scale.dart';
import 'package:go_router/go_router.dart';

class InfoForm extends StatefulWidget {
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
  final GlobalKey<FormState> formKey;

  const InfoForm({
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
    required this.formKey,
  });

  @override
  State<InfoForm> createState() => _InfoFormState();
}

class _InfoFormState extends State<InfoForm> {
  Map<String, Map<String, TextEditingController>> textFields = {};
  ActionType actionType = ActionType.notSelected;
  TextEditingController fileNameController = TextEditingController();

  @override
  void initState() {
    textFields = {
      'General Info': {
        'First name': widget.firstNameController,
        'Last name': widget.lastNameController,
        'Street': widget.streetController,
        'ZIP city': widget.zipCityController
      },
      'Bank Details': {
        'Account holder': widget.accountHolderController,
        'IBAN': widget.ibanController,
        'BIC': widget.bicController,
        'Bank': widget.bankController
      },
      'Occasion': {
        'Occasion': widget.occasionController,
        'Date': widget.dateController,
        'Destination': widget.destinationController
      },
      'Additional Info': {
        'Personal contribution': widget.ownContributionController,
        'Passengers': widget.passengersController,
      }
    };
    fileNameController.text = "Fahrtkosten";

    super.initState();
  }

  @override
  void dispose() {
    // textFields.forEach((key, value) {
    //   value.forEach((key, value) {
    //     value.dispose();
    //   });
    // });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    reqValidator(String? value) {
      if (value!.isEmpty) {
        return AppLocalizations.of(context)!.fieldMustBeFilled;
      } else {
        return null;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
          child: FittedBox(
            child: Text(
              AppLocalizations.of(context)!.travelExpenseAccountant,
              textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(AppLocalizations.of(context)!.personalInfo,
                      style: const TextStyle(color: Colors.white)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: reqValidator,
                        controller: widget.firstNameController,
                        decoration: InputDecoration(
                          filled: true,
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(56, 255, 255, 255)),
                          labelText: AppLocalizations.of(context)!.firstName,
                          fillColor: const Color.fromARGB(255, 58, 54, 74),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        validator: reqValidator,
                        controller: widget.lastNameController,
                        decoration: InputDecoration(
                          filled: true,
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(56, 255, 255, 255)),
                          labelText: AppLocalizations.of(context)!.lastName,
                          fillColor: const Color.fromARGB(255, 58, 54, 74),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  validator: reqValidator,
                  controller: widget.streetController,
                  decoration: InputDecoration(
                    filled: true,
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(56, 255, 255, 255)),
                    labelText: AppLocalizations.of(context)!.street,
                    fillColor: const Color.fromARGB(255, 58, 54, 74),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  validator: reqValidator,
                  controller: widget.zipCityController,
                  decoration: InputDecoration(
                    filled: true,
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(56, 255, 255, 255)),
                    labelText: AppLocalizations.of(context)!.zipCity,
                    fillColor: const Color.fromARGB(255, 58, 54, 74),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(AppLocalizations.of(context)!.bankDetails,
                      style: const TextStyle(color: Colors.white)),
                ),
                TextFormField(
                  validator: reqValidator,
                  controller: widget.accountHolderController,
                  decoration: InputDecoration(
                    filled: true,
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(56, 255, 255, 255)),
                    labelText: AppLocalizations.of(context)!.accountHolder,
                    fillColor: const Color.fromARGB(255, 58, 54, 74),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  validator: reqValidator,
                  controller: widget.ibanController,
                  decoration: InputDecoration(
                    filled: true,
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(56, 255, 255, 255)),
                    labelText: AppLocalizations.of(context)!.iban,
                    fillColor: const Color.fromARGB(255, 58, 54, 74),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: widget.bicController,
                  decoration: InputDecoration(
                    filled: true,
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(56, 255, 255, 255)),
                    labelText: AppLocalizations.of(context)!.bic,
                    fillColor: const Color.fromARGB(255, 58, 54, 74),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: widget.bankController,
                  decoration: InputDecoration(
                    filled: true,
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(56, 255, 255, 255)),
                    labelText: AppLocalizations.of(context)!.bank,
                    fillColor: const Color.fromARGB(255, 58, 54, 74),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(AppLocalizations.of(context)!.occasion,
                      style: const TextStyle(color: Colors.white)),
                ),
                TextFormField(
                  controller: widget.occasionController,
                  decoration: InputDecoration(
                    filled: true,
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(56, 255, 255, 255)),
                    labelText: AppLocalizations.of(context)!.occasionDrive,
                    fillColor: const Color.fromARGB(255, 58, 54, 74),
                  ),
                ),
                Container(height: 12),
                TextFormField(
                  controller: widget.dateController,
                  decoration: InputDecoration(
                    filled: true,
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(56, 255, 255, 255)),
                    labelText: AppLocalizations.of(context)!.when,
                    fillColor: const Color.fromARGB(255, 58, 54, 74),
                  ),
                ),
                Container(height: 12),
                TextFormField(
                  controller: widget.destinationController,
                  decoration: InputDecoration(
                    filled: true,
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(56, 255, 255, 255)),
                    labelText: AppLocalizations.of(context)!.where,
                    fillColor: const Color.fromARGB(255, 58, 54, 74),
                  ),
                ),
                Container(height: 12),
                DropdownButton(
                    isExpanded: true,
                    value: actionType,
                    items: [
                      DropdownMenuItem(
                          value: ActionType.action,
                          child: Text(AppLocalizations.of(context)!.action)),
                      DropdownMenuItem(
                          value: ActionType.recherche,
                          child: Text(AppLocalizations.of(context)!.recherche)),
                      DropdownMenuItem(
                          value: ActionType.seminar,
                          child: Text(AppLocalizations.of(context)!.seminar)),
                      DropdownMenuItem(
                          value: ActionType.other,
                          child: Text(AppLocalizations.of(context)!.other)),
                      DropdownMenuItem(
                        value: ActionType.notSelected,
                        child: Text(AppLocalizations.of(context)!.nonSelected),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        actionType = value as ActionType;
                      });
                    }),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                      AppLocalizations.of(context)!.additionalInformation,
                      style: const TextStyle(color: Colors.white)),
                ),
                TextFormField(
                  controller: widget.ownContributionController,
                  decoration: InputDecoration(
                    filled: true,
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(56, 255, 255, 255)),
                    labelText:
                        AppLocalizations.of(context)!.personalContribution,
                    fillColor: const Color.fromARGB(255, 58, 54, 74),
                  ),
                ),
                Container(height: 12),
                TextFormField(
                  controller: widget.passengersController,
                  decoration: InputDecoration(
                    filled: true,
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(56, 255, 255, 255)),
                    labelText: AppLocalizations.of(context)!.passenger,
                    fillColor: const Color.fromARGB(255, 58, 54, 74),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(AppLocalizations.of(context)!.invoices,
                      style: const TextStyle(color: Colors.white)),
                ),
                const ExampleDragTarget(),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          // backgroundColor: Colors.yellow[200],
                          shape: const CustomRoundedRectangleBorder(
                            topLeftRadius: 20,
                            bottomLeftRadius: 20,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        onPressed: () {
                          Document document = Document(
                            firstName: widget.firstNameController.text,
                            lastName: widget.lastNameController.text,
                            street: widget.streetController.text,
                            zipCity: widget.zipCityController.text,
                            accountHolder: widget.accountHolderController.text,
                            iban: widget.ibanController.text,
                            bic: widget.bicController.text,
                            bank: widget.bankController.text,
                            occasion: widget.occasionController.text,
                            when: widget.dateController.text,
                            destination: widget.destinationController.text,
                            ownContribution:
                                widget.ownContributionController.text,
                            passengers: widget.passengersController.text,
                            actionType: actionType,
                          );
                          String urlDocument = document.toURL();

                          var fullUri = Uri.base;

                          context.go('/form/$urlDocument');
                          Clipboard.setData(
                            ClipboardData(
                              text: fullUri.toString()!,
                            ),
                          );
                        },
                        child: FittedBox(
                            child: Text(
                          "Vorlage in URL speichern",
                          style: TextStyle(
                            color: Colors.yellow[200],
                          ),
                        )),
                      ),
                    ),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          // backgroundColor: Colors.green[200],
                          shape: const CustomRoundedRectangleBorder(
                            topRightRadius: 20,
                            bottomRightRadius: 20,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        onPressed: () {
                          if (widget.formKey.currentState!.validate()) {
                            String occasionFileName = widget
                                .occasionController.text
                                .replaceAll(".", "_")
                                .replaceAll(" ", "");
                            String dateFileName = widget.dateController.text
                                .replaceAll(".", "_")
                                .replaceAll(" ", "");
                            String fileName = "Fahrtkosten";
                            if (occasionFileName.isNotEmpty) {
                              fileName = "${fileName}_$occasionFileName";
                            }
                            if (dateFileName.isNotEmpty) {
                              fileName = "${fileName}_$dateFileName";
                            }
                            fileNameController.text = fileName;
                            BlocProvider.of<FormularBloc>(context).add(
                              FormularFilledEvent(
                                document: Document(
                                  firstName: widget.firstNameController.text,
                                  lastName: widget.lastNameController.text,
                                  street: widget.streetController.text,
                                  zipCity: widget.zipCityController.text,
                                  accountHolder:
                                      widget.accountHolderController.text,
                                  occasion: widget.occasionController.text,
                                  when: widget.dateController.text,
                                  destination:
                                      widget.destinationController.text,
                                  ownContribution:
                                      widget.ownContributionController.text,
                                  passengers: widget.passengersController.text,
                                  iban: widget.ibanController.text,
                                  bic: widget.bicController.text,
                                  bank: widget.bankController.text,
                                  actionType: actionType,
                                ),
                              ),
                            );
                          }
                        },
                        child: FittedBox(
                          child: Text(
                            AppLocalizations.of(context)!.generateDocument,
                            style: TextStyle(
                              color: Colors.green[200],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                BlocBuilder(
                    bloc: BlocProvider.of<FormularBloc>(context),
                    builder: (context, state) {
                      if (state is FormularFinished) {
                        return Column(
                          children: [
                            TextFormField(
                              controller: fileNameController,
                              decoration: InputDecoration(
                                filled: true,
                                labelStyle: const TextStyle(
                                    color: Color.fromARGB(56, 255, 255, 255)),
                                labelText:
                                    AppLocalizations.of(context)!.fileName,
                                fillColor:
                                    const Color.fromARGB(255, 58, 54, 74),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: const CustomRoundedRectangleBorder(
                                    bottomLeftRadius: 20,
                                    bottomRightRadius: 20,
                                  ),
                                  // backgroundColor: Colors.blue[200],
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                ),
                                onPressed: () {
                                  String filename = fileNameController.text;
                                  if (filename.isEmpty) {
                                    filename = AppLocalizations.of(context)!
                                        .travelExpense;
                                  }
                                  FileSaver.instance.saveFile(
                                    name: "$filename.pdf",
                                    bytes: state.finalPdf,
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .downloadDocument,
                                  style: TextStyle(color: Colors.blue[200]),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),
                SizedBox(
                  width: double.infinity,
                  child: Builder(builder: (BuildContext builderContext) {
                    return OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const CustomRoundedRectangleBorder(
                          bottomLeftRadius: 20,
                          bottomRightRadius: 20,
                          topLeftRadius: 20,
                          topRightRadius: 20,
                        ),
                        // backgroundColor: Colors.red[200],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                      onPressed: () {
                        showDialog(
                          context: builderContext,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(AppLocalizations.of(context)!
                                  .confirmClearTitle),
                              content: Text(AppLocalizations.of(context)!
                                  .confirmClearMessage),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                      AppLocalizations.of(context)!.cancel),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                      AppLocalizations.of(context)!.confirm),
                                  onPressed: () {
                                    // Close the dialog
                                    Navigator.of(context).pop();
                                    // Perform the clear action
                                    BlocProvider.of<FormularBloc>(
                                            builderContext)
                                        .add(FormularClearEvent());
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.clearDocument,
                        style: TextStyle(color: Colors.red[200]),
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
