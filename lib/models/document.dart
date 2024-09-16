import 'package:flutter_gp_abrechner/main.dart';

class Document {
  final String firstName;
  final String lastName;
  final String street;
  final String zipCity;
  final String accountHolder;
  final String iban;
  final String bic;
  final String bank;
  final String occasion;
  final String when;
  final String destination;
  final String ownContribution;
  final String passengers;
  final ActionType actionType;

  const Document({
    this.firstName = '',
    this.lastName = '',
    this.street = '',
    this.zipCity = '',
    this.accountHolder = '',
    this.iban = '',
    this.bic = '',
    this.bank = '',
    this.occasion = '',
    this.when = '',
    this.destination = '',
    this.ownContribution = '',
    this.passengers = '',
    this.actionType = ActionType.notSelected,
  });

  String toURL() {
    return '''firstName=${Uri.encodeComponent(firstName..replaceAll(" ", "^"))}&
    lastName=${Uri.encodeComponent(lastName..replaceAll(" ", "^"))}&
    street=${Uri.encodeComponent(street..replaceAll(" ", "^"))}&
    zipCity=${Uri.encodeComponent(zipCity..replaceAll(" ", "^"))}&
    accountHolder=${Uri.encodeComponent(accountHolder..replaceAll(" ", "^"))}&
    iban=${Uri.encodeComponent(iban..replaceAll(" ", "^"))}&
    bic=${Uri.encodeComponent(bic..replaceAll(" ", "^"))}&
    bank=${Uri.encodeComponent(bank..replaceAll(" ", "^"))}&
    occasion=${Uri.encodeComponent(occasion..replaceAll(" ", "^"))}&
    when=${Uri.encodeComponent(when..replaceAll(" ", "^"))}&
    destination=${Uri.encodeComponent(destination..replaceAll(" ", "^"))}&
    ownContribution=${Uri.encodeComponent(ownContribution..replaceAll(" ", "^"))}&
    passengers=${Uri.encodeComponent(passengers..replaceAll(" ", "^"))}&
    actionType=${Uri.encodeComponent(actionType.toString())}''';
  }

  static Document fromURL(String encodedString) {
    print(encodedString);
    // Split the string into key-value pairs
    final pairs = encodedString.split('&');
    final map = <String, String>{};

    // Parse each key-value pair
    for (var pair in pairs) {
      final parts = pair.trim().split('=');
      if (parts.length == 2) {
        final key = parts[0].trim();
        parts[1] = Uri.encodeComponent(parts[1]);
        final value = Uri.decodeComponent(parts[1].trim());
        map[key] = value;
      }
    }

    // Create a new Document instance with the decoded values
    return Document(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      street: map['street'] ?? '',
      zipCity: map['zipCity'] ?? '',
      accountHolder: map['accountHolder'] ?? '',
      iban: map['iban'] ?? '',
      bic: map['bic'] ?? '',
      bank: map['bank'] ?? '',
      occasion: map['occasion'] ?? '',
      when: map['when'] ?? '',
      destination: map['destination'] ?? '',
      ownContribution: map['ownContribution'] ?? '',
      passengers: map['passengers'] ?? '',
      actionType: _parseActionType(map['actionType']),
    );
  }

  static ActionType _parseActionType(String? value) {
    if (value == null) return ActionType.notSelected;
    return ActionType.values.firstWhere(
      (type) => type.toString() == value,
      orElse: () => ActionType.notSelected,
    );
  }
}
