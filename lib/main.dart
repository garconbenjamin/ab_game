import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'AB Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

bool isNumberDuplicate(String input) {
  return input.length != input.split('').toSet().length;
}

String generateRandomNumber() {
  String number = "";
  List<int> digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  digits.shuffle();

  for (int i = 0; i < 4; i++) {
    number += digits[i].toString();
  }
  return number;
}

class ResultMap {
  late int status;
  late String message;
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  String _answer = generateRandomNumber();

  String _result = "";

  void checkAnswer(input) {
    if (FormBuilderValidators.required()(input) != null ||
        FormBuilderValidators.numeric()(input) != null) {
      _result = "Please enter 4 digits";
    } else if (isNumberDuplicate(input)) {
      _result = "Please enter 4 different digits";
    } else {
      int a = 0;
      int b = 0;
      for (int i = 0; i < 4; i++) {
        if (input[i] == _answer[i]) {
          a++;
        } else if (_answer.contains(input[i])) {
          b++;
        }
      }
      if (a == 4) {
        //emoji celebration

        _result = "You win🎉! \nThe answer is $_answer";
        _answer = generateRandomNumber();
      } else {
        _result = "${a.toString()}A${b.toString()}B";
      }
    }
    print(_answer);
    setState(() {});
  }

  void submit() {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      checkAnswer(_formKey.currentState!.value['answerInput']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: FormBuilder(
          key: _formKey,
          child: (Center(
            child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FormBuilderTextField(
                      decoration: const InputDecoration(
                        labelText: "Guess the number",
                      ),
                      name: 'answerInput',
                      maxLength: 4,
                      buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          maxLength}) {
                        return Text(
                            "${currentLength.toString()}/${maxLength.toString()}");
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.lightGreen),
                                ),
                                onPressed: submit,
                                child: const Text(
                                  "Check",
                                  style: TextStyle(color: Colors.white),
                                ))),
                        Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.visibility),
                              tooltip: "Answer is $_answer",
                            )),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(_result,
                        style: const TextStyle(
                          fontSize: 30,
                        )),
                  ],
                )),
          ))),
    );
  }
}
