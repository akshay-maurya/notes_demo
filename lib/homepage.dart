import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _noteController = TextEditingController();
  final List<String> _notes = [];
  Color tileColor = const Color(0xfff4e9e6);
  Color acttionButtonColor = const Color(0xffc99180);

  DateTime now = DateTime.now();
  String get formattedDate => DateFormat('MMM dd, yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    loadNotes();
  }
  void loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes.addAll(prefs.getStringList('notes') ?? []) ;
    });
  }
  void saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('notes', _notes);
  }
  void addNote() {
    String newNote = _noteController.text;
    if (newNote.isNotEmpty) {
      setState(() {
        _notes.add(newNote);
      });
      _noteController.clear();
      saveNotes();
    }
  }
  void deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    saveNotes();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            for(int i=0; i<_notes.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Dismissible(
                key: const Key("dismissed"),
                onDismissed: (direction) => deleteNote(i),
                background: Container(color: acttionButtonColor,),
                child: ListTile(
                  title: _notes[i].length <= 75 ? Text(_notes[i]) : Text(_notes[i].substring(0, 75)),
                  subtitle: Text("$formattedDate, ${now.hour}:${now.minute}", style: const TextStyle(fontSize: 12, color: Colors.grey),),
                  trailing: IconButton(
                    onPressed: () => deleteNote(i), icon: Icon(Icons.delete, color: acttionButtonColor,)),
                  tileColor: tileColor,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context, 
            shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            builder: (ctx) => Container(
              height: 200,
              color: Colors.grey.shade200,
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _noteController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "take a note ....",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: acttionButtonColor, width: 1),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          addNote();
                          Navigator.pop(context);
                        }, icon: const Icon(Icons.send))
                    ),
                  ),
                ),
              ),
            ),
            );
        },
        backgroundColor: acttionButtonColor,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      
    );
  }
}