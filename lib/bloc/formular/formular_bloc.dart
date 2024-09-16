import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gp_abrechner/main.dart';
import 'package:flutter_gp_abrechner/models/document.dart';
import 'package:meta/meta.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tuple/tuple.dart';
import 'package:image/image.dart' as img;

part 'formular_event.dart';
part 'formular_state.dart';

class FormularBloc extends Bloc<FormularEvent, FormularState> {
  Map<String, Uint8List> invoiceFiles = {};

  FormularBloc() : super(FormularInitial()) {
    on<FormularFilledEvent>(_onFilled);
    on<FormularAddInvoicesEvent>(_onAddInvoices);
    on<FormularDragInvoiceEvent>(_onDragInvoice);
    on<FormularRemoveInvoiceEvent>(_onRemoveInvoice);
    on<FormularPreedited>(_onPreedited);
    on<FormularClearEvent>(_onClear);
  }

  Future<void> _onFilled(
      FormularFilledEvent event, Emitter<FormularState> emit) async {
    emit(FormularProcessing(invoices: invoiceFiles));

    final ByteData bytes = await rootBundle.load('assets/Fahrtkosten.pdf');
    final Uint8List pdfBytes = bytes.buffer.asUint8List();

    print(event.document.firstName);

    // TODO: swap keys with values
    final Map<Tuple2<int, int>, String> pdfText = {
      const Tuple2<int, int>(68, 95):
          "${event.document.firstName} ${event.document.lastName}",
      const Tuple2<int, int>(79, 123): event.document.street,
      const Tuple2<int, int>(32, 151): event.document.zipCity,
      const Tuple2<int, int>(387, 95): event.document.accountHolder,
      const Tuple2<int, int>(387, 123): event.document.iban,
      const Tuple2<int, int>(387, 151): event.document.bic,
      const Tuple2<int, int>(387, 179): event.document.bank,
      const Tuple2<int, int>(32, 237): event.document.occasion,
      const Tuple2<int, int>(75, 265): event.document.destination,
      const Tuple2<int, int>(75, 293): event.document.when,
      const Tuple2<int, int>(396, 293): event.document.ownContribution,
      const Tuple2<int, int>(120, 321): event.document.passengers,
    };

    if (event.document.actionType == ActionType.action) {
      pdfText.addAll({
        const Tuple2<int, int>(385, 213): "X",
      });
    } else if (event.document.actionType == ActionType.recherche) {
      pdfText.addAll({
        const Tuple2<int, int>(446, 213): "X",
      });
    } else if (event.document.actionType == ActionType.seminar) {
      pdfText.addAll({
        const Tuple2<int, int>(385, 241): "X",
      });
    } else if (event.document.actionType == ActionType.other) {
      pdfText.addAll({
        const Tuple2<int, int>(446, 241): "X",
      });
    }

    final PdfDocument document = PdfDocument(inputBytes: pdfBytes);
    for (final entry in pdfText.entries) {
      document.pages[0].graphics.drawString(
        entry.value,
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(
          entry.key.item1.toDouble(),
          entry.key.item2.toDouble(),
          200,
          100,
        ),
      );
    }

    // document.pages[0].

    List<int> pdfFile = await document.save();
    document.dispose();
    Uint8List bytesPdf = Uint8List.fromList(pdfFile);

    List<Uint8List> invoices = invoiceFiles.values.toList();

    // filter out invoices ending with .pdf and add them to the pdfInvoices map
    List<String> pdfInvoiceKeys =
        invoiceFiles.keys.where((element) => element.endsWith(".pdf")).toList();
    Map<String, Uint8List> pdfInvoices = {};
    for (final String pdfI in pdfInvoiceKeys) {
      pdfInvoices.addAll({pdfI: invoiceFiles[pdfI]!});
    }

    Uint8List finalPdf =
        await _combinePDF(pdfInvoices.values.toList()..insert(0, bytesPdf));

    List<String> allowedImageExtensions = [
      '.png',
      '.jpg',
      '.jpeg',
      '.JPEG',
      '.JPG'
    ];
    List<String> imageKeys = [];
    for (String extension in allowedImageExtensions) {
      imageKeys.addAll(invoiceFiles.keys
          .where((element) => element.endsWith(extension))
          .toList());
    }

    Map<String, Uint8List> imageFiles = {};
    for (final String image in imageKeys) {
      imageFiles.addAll({image: invoiceFiles[image]!});
    }

    Uint8List finalPdfWithImages = finalPdf;
    for (final Uint8List image in imageFiles.values) {
      finalPdfWithImages =
          await _addImageToPDF(image, PdfDocument(inputBytes: finalPdf));
    }

    emit(FormularFinished(finalPdfWithImages, event.document, invoiceFiles));
  }

  Future<Uint8List> _combinePDF(List<Uint8List> files) async {
    // Create a new PDF document.
    PdfDocument newDocument = PdfDocument();
    PdfSection? section;
    for (Uint8List file in files) {
      // Load the PDF document.
      PdfDocument loadedDocument = PdfDocument(inputBytes: file);
      // Export the pages to the new document.
      for (int index = 0; index < loadedDocument.pages.count; index++) {
        // Get the page template.
        PdfTemplate template = loadedDocument.pages[index].createTemplate();
        // Create a new section if the page settings are different.
        if (section == null || section.pageSettings.size != template.size) {
          section = newDocument.sections!.add();
          section.pageSettings.size = template.size;
          section.pageSettings.margins.all = 0;
        }

        // Draw the page template to the new document.
        section.pages
            .add()
            .graphics
            .drawPdfTemplate(template, const Offset(0, 0));
      }

      // Dispose the loaded document.
      loadedDocument.dispose();
    }
    //Save the document.
    List<int> bytes = await newDocument.save();
    //Disposes the document
    newDocument.dispose();
    //Save the file and launch/download.

    return Uint8List.fromList(bytes);
  }

  Future<void> _onPreedited(
      FormularPreedited event, Emitter<FormularState> emit) async {
    Document preeditedDocument = Document(
      firstName: event.document.firstName,
      lastName: event.document.lastName,
      street: event.document.street,
      zipCity: event.document.zipCity,
      accountHolder: event.document.accountHolder,
      iban: event.document.iban,
      bic: event.document.bic,
      bank: event.document.bank,
      occasion: event.document.occasion,
      when: event.document.when,
      destination: event.document.destination,
      ownContribution: event.document.ownContribution,
      passengers: event.document.passengers,
      actionType: event.document.actionType,
    );

    emit(
      FormularInitialized(
        fileNames: const [],
        initializedDocument: preeditedDocument,
      ),
    );
  }

  Future<void> _onAddInvoices(
      FormularAddInvoicesEvent event, Emitter<FormularState> emit) async {
    _addInvoice(event.invoices, event.fileNames);

    emit(FormularProcessing(invoices: invoiceFiles));
  }

  Future<void> _onDragInvoice(
      FormularDragInvoiceEvent event, Emitter<FormularState> emit) async {
    List<Uint8List> invoices = [];
    for (final file in event.invoices) {
      invoices.add(await file.readAsBytes());
    }

    _addInvoice(invoices, event.fileNames);

    emit(FormularProcessing(invoices: invoiceFiles));
  }

  void _addInvoice(List<Uint8List> invoices, List<String> fileNames) {
    for (int i = 0, len = invoices.length; i < len; i++) {
      String fileName = fileNames[i];
      if (invoiceFiles.containsKey(fileNames[i])) {
        fileName = fileName.replaceAll(".pdf", "_1.pdf");
      }
      invoiceFiles.addAll({fileName: invoices[i]});
    }
  }

  Future<void> _onClear(
      FormularClearEvent event, Emitter<FormularState> emit) async {
    invoiceFiles.clear();
    emit(FormularInitialized());
  }

  Future<void> _onRemoveInvoice(
      FormularRemoveInvoiceEvent event, Emitter<FormularState> emit) async {
    invoiceFiles.removeWhere((key, value) => key == event.fileName);

    emit(FormularProcessing(invoices: invoiceFiles));
  }

  Future<Uint8List> _addImageToPDF(
      Uint8List image, PdfDocument document) async {
    img.Image? imageData = img.decodeImage(image);

    if (imageData == null) {
      throw Exception("Image data is null");
    }

    //Create a new PDF document
    //Add a page to the document
    PdfPage page = document.pages.add();

    PdfGraphicsState state = page.graphics.save();

    List<int> imageList = image.cast<int>();
    PdfBitmap bImage = PdfBitmap(image);

    Map<String, double> imageDimensions = _calculateFitDimensions(
      containerWidth: page.getClientSize().width,
      containerHeight: page.getClientSize().height,
      imageWidth: imageData.width.toDouble(),
      imageHeight: imageData.height.toDouble(),
    );

    page.graphics.drawImage(
      bImage,
      Rect.fromLTWH(
          0, 0, imageDimensions['width']!, imageDimensions['height']!),
    );

    page.graphics.restore(state);

    List<int> finalDoc = await document.save();
    document.dispose();

    return Uint8List.fromList(finalDoc);
  }

  Map<String, double> _calculateFitDimensions({
    required double containerWidth,
    required double containerHeight,
    required double imageWidth,
    required double imageHeight,
  }) {
    double containerAspectRatio = containerWidth / containerHeight;
    double imageAspectRatio = imageWidth / imageHeight;

    late double fitWidth;
    late double fitHeight;

    if (imageAspectRatio > containerAspectRatio) {
      // Image is wider than the container relative to their heights
      fitWidth = containerWidth;
      fitHeight = containerWidth / imageAspectRatio;
    } else {
      // Image is taller than the container relative to their widths
      fitHeight = containerHeight;
      fitWidth = containerHeight * imageAspectRatio;
    }

    return {
      'width': fitWidth,
      'height': fitHeight,
    };
  }
}
