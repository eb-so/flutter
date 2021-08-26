// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Template: dev/snippets/config/templates/freeform.tmpl
//
// Comment lines marked with "▼▼▼" and "▲▲▲" are used for authoring
// of samples, and may be ignored if you are just exploring the sample.

// Flutter code sample for RawAutocomplete
//
//***************************************************************************
//* ▼▼▼▼▼▼▼▼ description ▼▼▼▼▼▼▼▼ (do not modify or remove section marker)

// This example shows the use of RawAutocomplete in a form.

//* ▲▲▲▲▲▲▲▲ description ▲▲▲▲▲▲▲▲ (do not modify or remove section marker)
//***************************************************************************

//*************************************************************************
//* ▼▼▼▼▼▼▼▼ code-main ▼▼▼▼▼▼▼▼ (do not modify or remove section marker)

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const AutocompleteExampleApp());

class AutocompleteExampleApp extends StatelessWidget {
  const AutocompleteExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('RawAutocomplete Form'),
        ),
        body: const Center(
          child: AutocompleteFormExample(),
        ),
      ),
    );
  }
}

class AutocompleteFormExample extends StatefulWidget {
  const AutocompleteFormExample({Key? key}) : super(key: key);

  @override
  AutocompleteFormExampleState createState() => AutocompleteFormExampleState();
}

class AutocompleteFormExampleState extends State<AutocompleteFormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  String? _dropdownValue;
  String? _autocompleteSelection;

  static const List<String> _options = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          DropdownButtonFormField<String>(
            value: _dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            hint: const Text('This is a regular DropdownButtonFormField'),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            onChanged: (String? newValue) {
              setState(() {
                _dropdownValue = newValue;
              });
            },
            items: <String>['One', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (String? value) {
              if (value == null) {
                return 'Must make a selection.';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              hintText: 'This is a regular TextFormField',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Can't be empty.";
              }
              return null;
            },
          ),
          RawAutocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              return _options.where((String option) {
                return option.contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              setState(() {
                _autocompleteSelection = selection;
              });
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              return TextFormField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  hintText: 'This is a RawAutocomplete!',
                ),
                focusNode: focusNode,
                onFieldSubmitted: (String value) {
                  onFieldSubmitted();
                },
                validator: (String? value) {
                  if (!_options.contains(value)) {
                    return 'Nothing selected.';
                  }
                  return null;
                },
              );
            },
            optionsViewBuilder: (BuildContext context,
                AutocompleteOnSelected<String> onSelected,
                Iterable<String> options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  child: SizedBox(
                    height: 200.0,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            onSelected(option);
                          },
                          child: ListTile(
                            title: Text(option),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (!_formKey.currentState!.validate()) {
                return;
              }
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Successfully submitted'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('DropdownButtonFormField: "$_dropdownValue"'),
                          Text(
                              'TextFormField: "${_textEditingController.text}"'),
                          Text('RawAutocomplete: "$_autocompleteSelection"'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

//* ▲▲▲▲▲▲▲▲ code-main ▲▲▲▲▲▲▲▲ (do not modify or remove section marker)
//*************************************************************************