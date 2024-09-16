part of 'formular_bloc.dart';

@immutable
sealed class FormularEvent {}

class FormularInitialEvent extends FormularEvent {}

class FormularPreedited extends FormularEvent {
  final Document document;

  FormularPreedited({
    this.document = const Document(),
  });
}

class FormularFilledEvent extends FormularEvent {
  final Document document;

  FormularFilledEvent({this.document = const Document()});
}

class FormularAddInvoicesEvent extends FormularEvent {
  final List<Uint8List> invoices;
  final List<String> fileNames;

  FormularAddInvoicesEvent(
    this.invoices,
    this.fileNames,
  );
}

class FormularDragInvoiceEvent extends FormularEvent {
  final List<XFile> invoices;
  final List<String> fileNames;

  FormularDragInvoiceEvent(this.invoices, this.fileNames);
}

class FormularRemoveInvoiceEvent extends FormularEvent {
  final String fileName;

  FormularRemoveInvoiceEvent(this.fileName);
}

class FormularClearEvent extends FormularEvent {}
