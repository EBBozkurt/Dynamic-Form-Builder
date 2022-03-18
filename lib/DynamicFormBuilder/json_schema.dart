// ignore_for_file: no_logic_in_create_state

import 'dart:convert';
import 'package:flutter/material.dart';
import 'components/index.dart';

class JsonSchema extends StatefulWidget {
  const JsonSchema({
    Key? key,
    required this.form,
    required this.onChanged,
    this.padding,
    this.formMap,
    this.autovalidateMode,
    this.errorMessages = const {},
    this.validations = const {},
    this.decorations = const {},
    this.keyboardTypes = const {},
    this.buttonSave,
    this.actionSave,
  }) : super(key: key);

  final Map errorMessages;
  final Map validations;
  final Map decorations;
  final Map keyboardTypes;
  final String form;
  final Map? formMap;
  final double? padding;
  final Widget? buttonSave;
  final Function? actionSave;
  final ValueChanged<dynamic> onChanged;
  final AutovalidateMode? autovalidateMode;

  @override
  _CoreFormState createState() => _CoreFormState(formMap ?? json.decode(form));
}

class _CoreFormState extends State<JsonSchema> {
  final dynamic formGeneral;

  _CoreFormState(this.formGeneral);

  void _handleChanged() {
    widget.onChanged(formGeneral);
  }

  /// [position] -> Elimizdeki değişecek olan datanın pozisyonunu gönderip o
  /// datada değişiklik yapıyoruz..
  /// [value] -> Elimizdeki değişecek olan datanın value'su
  /// [unitValue]  -> varsa UnitValue'muz elimizdeki değişecek olan datanın UnitValue'su
  void onChange(int position, {dynamic value, dynamic unitValue}) {
    setState(() {
      if (value != null) {
        formGeneral['fields'][position]['value'] = value;
      }
      if (unitValue != null) {
        formGeneral['fields'][position]['UnitValue'] = unitValue;
      }
      _handleChanged();
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: widget.autovalidateMode,
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(widget.padding ?? 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: jsonToForm(),
        ),
      ),
    );
  }

  List<Widget> jsonToForm() {
    List<Widget> listWidget = [];
    if (formGeneral['title'] != null) {
      listWidget.add(Container(
        padding: const EdgeInsets.all(10),
        color: Colors.amberAccent,
        child: Center(
          child: Text(
            formGeneral['title'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
      ));
    }
    if (formGeneral['description'] != null) {
      listWidget.add(Text(
        "  " + formGeneral['description'],
        style: const TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
      ));
    }

    for (var count = 0; count < formGeneral['fields'].length; count++) {
      Map item = formGeneral['fields'][count];

      if (item['TYPE'] == "Sayısal Değer" ||
          item['TYPE'] == "Serbest Metin" ||
          item['TYPE'] == "Tam Sayı" ||
          item['TYPE'] == "Input" ||
          item['TYPE'] == "Password" ||
          item['TYPE'] == "Email") {
        listWidget.add(SimpleText(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item['TYPE'] == "Çoktan Seçmeli") {
        listWidget.add(SimpleSelect(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item['TYPE'] == "Tarih/Saat") {
        listWidget.add(SimpleDate(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item['TYPE'] == "RadioButton") {
        listWidget.add(SimpleRadios(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item['TYPE'] == "Switch") {
        listWidget.add(SimpleSwitch(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item['TYPE'] == "Checkbox") {
        listWidget.add(SimpleListCheckbox(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item['TYPE'] == "SectionHeader") {
        listWidget.add(SimpleSectionHeader(
          item: item,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }
    }

    if (widget.buttonSave != null) {
      listWidget.add(Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: InkWell(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              widget.actionSave!(formGeneral);
            }
          },
          child: widget.buttonSave,
        ),
      ));
    }

    return listWidget;
  }
}