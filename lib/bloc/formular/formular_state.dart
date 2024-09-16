part of 'formular_bloc.dart';

@immutable
sealed class FormularState {}

final class FormularInitial extends FormularState {}

final class FormularInitialized extends FormularState {
  final Document initializedDocument;
  final List<String> fileNames;

  FormularInitialized({
    this.initializedDocument = const Document(),
    this.fileNames = const [],
  });
}

final class FormularProcessing extends FormularState {
  final Map<String, Uint8List> invoices;

  FormularProcessing({
    this.invoices = const {},
  });
}

final class FormularFinished extends FormularState {
  final Uint8List finalPdf;
  final Document finishedDocument;
  final Map<String, Uint8List> invoices;

  FormularFinished(
    this.finalPdf,
    this.finishedDocument,
    this.invoices,
  );
}
