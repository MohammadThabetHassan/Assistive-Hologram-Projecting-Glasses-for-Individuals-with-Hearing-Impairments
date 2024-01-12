import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eye Glass App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircularProgressIndicator(),
                          Text('Searching...'),
                        ],
                      ),
                    );
                  },
                );

                await Future.delayed(Duration(seconds: 10));
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Found a glass called Mohammad glass'),
                    duration: Duration(seconds: 3),
                  ),
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EyeGlassSettings()),
                );
              },
              child: Text('Add Glass'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EyeGlassSettings()),
                );
              },
              child: Text('Skip'),
            ),
          ],
        ),
      ),
    );
  }
}

class EyeGlassSettings extends StatefulWidget {
  @override
  _EyeGlassSettingsState createState() => _EyeGlassSettingsState();
}

class _EyeGlassSettingsState extends State<EyeGlassSettings> {
  Color fontColor = Colors.black;
  double fontSize = 14;
  String fontFamily = 'Roboto';

  void changeFontColor(Color color) => setState(() => fontColor = color);

  void changeFontSize(double size) => setState(() => fontSize = size);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSettingsOption('Font Type', () async {
              String? newFontFamily = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('Choose Font Type'),
                    children: [
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'Roboto'),
                        child: Text('Roboto'),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'Arial'),
                        child: Text('Arial'),
                      ),
                    ],
                  );
                },
              );
              if (newFontFamily != null) {
                setState(() {
                  fontFamily = newFontFamily;
                });
              }
            }),
            buildSettingsOption('Font Size', () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Choose Font Size'),
                    content: Slider(
                      value: fontSize,
                      min: 8,
                      max: 30,
                      onChanged: (double value) {
                        changeFontSize(value);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              );
            }),
            buildSettingsOption('Font Color', () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Choose Font Color'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: fontColor,
                        onColorChanged: changeFontColor,
                        showLabel: false,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text('Done'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }),
            buildSettingsOption('Battery Level', () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Battery Level: 100%'),
                  duration: Duration(seconds: 2),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsOption(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text,
            style: TextStyle(
                fontSize: fontSize, fontFamily: fontFamily, color: fontColor)),
      ),
    );
  }
}
