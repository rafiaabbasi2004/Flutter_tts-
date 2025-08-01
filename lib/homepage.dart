import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
class ttsDemo extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkmode;
  const ttsDemo({Key? key, required this.onToggleTheme, required this.isDarkmode}) : super(key: key);
  @override
  State<ttsDemo> createState() => _ttsDemoState();
}

class _ttsDemoState extends State<ttsDemo> {
  bool ismalevoice  = true;
  List<dynamic> voices = [];
  String? language ;
  TextEditingController textcontroller = TextEditingController();
  final FlutterTts fluttertts = FlutterTts();

  @override
  void initState() {
    super.initState();
    loadvoices();
  }


  Future<void> loadvoices() async {
    voices = await fluttertts.getVoices;
    print("Available Voices: $voices");
  }

  Future<void> speak() async {
    if (language == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please select a language')));
      return;
    }
    if (textcontroller.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please write some text first')));
      return;
    }

    String langCode = switch (language) {
      "French" => "fr-FR",
      "English" => "en-US",
      "Spanish" => "es-ES",
      "German" => "de-DE",
      "English-UK" => "en-GB",
      _ => "null",

    };
    var availableVoices =
    voices.where((v) => v["locale"] == langCode).toList();

    if (availableVoices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No voices available for this language')));
      return;
    }

    int index = (ismalevoice || availableVoices.length == 1) ? 0 : 1;

    await fluttertts.setVoice({
      "name": availableVoices[index]["name"],
      "locale": langCode
    });

    await fluttertts.setLanguage(langCode);
    await fluttertts.speak(textcontroller.text);

    setState(() {
      ismalevoice = !ismalevoice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDarkmode ? Icons.dark_mode : Icons.light_mode),
          )
        ],
        title: Text('Multillingual Text to speech App',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),




      body: Padding(
        padding: const EdgeInsets.all(15.0),

        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text('Select Language'),
                 SizedBox(width: 20,),
                 DropdownButton<String>(
                   hint: Text("Choose language"),
                   value: language,
                   items: ["English", "French", "Spanish", "German", "Urdu", "English-UK"].map((lang) {
                     return DropdownMenuItem(
                       value: lang,
                       child: Text(lang),
                     );
                   }).toList(),
                   onChanged: (value) {
                     setState(() {
                       language = value;
                     });
                   },
                 ),
               ],
             ),





              SizedBox(height: 20,),

              TextField(
                controller: textcontroller,
                decoration: InputDecoration(
                  labelText: 'Enter text',
                  border: OutlineInputBorder(),
                  hintText: 'your text here',
                ),

              ),

              SizedBox(height: 20,),

              ElevatedButton(

                onPressed: speak,
                child: Text('Play'),


              )
            ],
          ),
        ),
      ),
    );
  }
}
