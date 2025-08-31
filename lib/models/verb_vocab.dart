part of 'vocab.dart';

@HiveType(typeId: 6)
class VerbVocab extends Vocab {
  @HiveField(4)
  VerbForm plainVerb;
  @HiveField(5)
  Map<String, VerbForm> verbForms;

  late TextEditingController _plainVerbWordController;
  late TextEditingController _plainVerbReadingController;
  late TextEditingController _plainVerbMeaningController;

  // TODO: Add controllers for verbForms if they are to be made editable in this form
  VerbVocab({required this.plainVerb, required this.verbForms})
    : super(type: VocabType.verb) {
    _plainVerbWordController = TextEditingController(text: plainVerb.verbWord);
    _plainVerbReadingController = TextEditingController(
      text: plainVerb.reading,
    );
    _plainVerbMeaningController = TextEditingController(
      text: plainVerb.meaning,
    );
  }

  // TODO: Implement a more comprehensive form for verbForms if needed.
  // This could involve dynamically adding/removing fields for each VerbForm in the HashMap.
  // For now, only plainVerb is directly editable.
  @override
  List<Widget> buildFormFields(StateSetter setState) {
    List<Widget> formWidgets = [
      _LabeledField('Plain Verb Word (e.g., 食べる)', _plainVerbWordController),
      const SizedBox(height: 10),
      _LabeledField(
        'Plain Verb Reading (e.g., たべる)',
        _plainVerbReadingController,
      ),
      const SizedBox(height: 10),
      _LabeledField(
        'Plain Verb Meaning (e.g., to eat)',
        _plainVerbMeaningController,
      ),
      const SizedBox(height: 10),
      const Text('Verb Forms:', style: TextStyle(fontWeight: FontWeight.bold)),
      // Display existing verb forms (read-only in this basic implementation)
      // A more complex UI would be needed to edit these directly here.
    ];

    verbForms.forEach((key, verbForm) {
      formWidgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
          child: Text('$key: ${verbForm.displaySummary()}'),
        ),
      );
    });
    formWidgets.add(const SizedBox(height: 10));

    return formWidgets;
  }

  @override
  String displayTitle() {
    return plainVerb.displayTitle();
  }

  @override
  String displaySubtext() {
    String plainVerbSubtext = plainVerb.displaySubtext();
    if (plainVerbSubtext.isEmpty) {
      return 'Forms: ${verbForms.length}';
    }
    return '${plainVerb.displaySubtext()} | Forms: ${verbForms.length}';
  }

  @override
  String displaySummary() {
    return 'Verb: ${plainVerb.displaySummary()}\nForms: ${verbForms.length}\n${super.displaySummary()}';
  }

  @override
  Future<void> save() async {
    plainVerb.verbWord = _plainVerbWordController.text;
    plainVerb.reading = _plainVerbReadingController.text;
    plainVerb.meaning = _plainVerbMeaningController.text;
    // TODO: Implement saving logic for verbForms if they are made editable.
    // This might involve parsing new/updated forms from controllers.
    await super.save();
  }

  @override
  String toString() {
    return 'VerbVocab{plainVerb: $plainVerb, verbForms: $verbForms, type: $type, level: $level, nextReview: $nextReview}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is VerbVocab &&
          runtimeType == other.runtimeType &&
          plainVerb == other.plainVerb &&
          mapEquals(verbForms, other.verbForms);

  @override
  int get hashCode => super.hashCode ^ plainVerb.hashCode ^ verbForms.hashCode;
}
