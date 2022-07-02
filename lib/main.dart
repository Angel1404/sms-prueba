import 'dart:io';

import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms/rotate_img.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:clipboard/clipboard.dart' as clip;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RotateImg(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TwilioFlutter twilioFlutter;
  String _comingSms = 'Unknown';
  late TextEditingController textEditingController1;
  @override
  void initState() {
    super.initState();
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC71c5be340d89a63619c5e70989b81164',
        authToken: 'e7d4fc2a7639325dca54b2c20b589843',
        twilioNumber: '+15078892218');
    textEditingController1 = TextEditingController();
    initSmsListener();
  }

  void pasteCode() async {
    await clip.FlutterClipboard.paste().then((value) {
      textEditingController1.text = value;
      print('value : $value');
      setState(() {});
    });
  }

  @override
  void dispose() {
    textEditingController1.dispose();
    AltSmsAutofill().unregisterListener();
    super.dispose();
  }

  Future<void> initSmsListener() async {
    String comingSms;
    String value;

    try {
      comingSms = (await AltSmsAutofill().listenForSms)!;
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;
    setState(() {
      _comingSms = comingSms;
      print("====>Message: $_comingSms");
      value = _comingSms.split(': ').last.substring(0, 5);
      //clip.FlutterClipboard.copy(value);
      textEditingController1.text = value;

      //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
                length: 4,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  fieldHeight: 50,
                  fieldWidth: 40,
                  inactiveFillColor: Colors.white,
                  inactiveColor: Colors.grey,
                  selectedColor: Colors.green,
                  selectedFillColor: Colors.white,
                  activeFillColor: Colors.white,
                  activeColor: Colors.green,
                ),
                cursorColor: Colors.black,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                controller: textEditingController1,
                onCompleted: (v) {
                  //do something or move to next screen when code complete
                },
                onChanged: (value) {
                  print('value $value');
                  setState(() {
                    print(value);
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          twilioFlutter.sendSMS(
              toNumber: '+573227222419',
              messageBody: 'hola tu codigo de amera es: 14040. no lo compartas con nadie');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class RotateImg extends StatefulWidget {
  const RotateImg({Key? key}) : super(key: key);

  @override
  State<RotateImg> createState() => _RotateImgState();
}

class _RotateImgState extends State<RotateImg> {
  double rotate = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  rotate += 90;
                  setState(() {});
                },
                child: const Text('Rotate '),
              ),
              Transform.rotate(
                angle: rotate,
                child: Image.asset('assets/manzana.png'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final img = await fixExifRotation('assest/manzana.png');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => ImagenRotada(img: img)),
                    ),
                  );
                },
                child: const Text('Enivar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImagenRotada extends StatelessWidget {
  const ImagenRotada({Key? key, required this.img}) : super(key: key);
  final File img;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
