import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_example_2/db/notes_database.dart';
import 'package:sqlite_example_2/model/note.dart';
import 'package:sqlite_example_2/page/edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int? noteId;

  NoteDetailPage({this.noteId});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() {
      isLoading = true;
    });
    note = await NoteDatabases.instance.readNote(widget.noteId!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(12),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    note.title!,
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd().format(note.createdTime!),
                    style: TextStyle(color: Colors.white38),
                  ),
                  SizedBox(height: 8),
                  Text(
                    note.description!,
                    style: TextStyle(color: Colors.white70, fontSize: 18.0),
                  ),
                ],
              ),
            ),
    );
  }

  Widget editButton() {
    return IconButton(
        onPressed: () async {
          if (isLoading) return;

          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return AddEditNotePage(note: note);
          }));

          refreshNote();
        },
        icon: Icon(Icons.edit_outlined));
  }

  Widget deleteButton() {
    return IconButton(
        onPressed: () async {
          await NoteDatabases.instance.delete(widget.noteId!);

          Navigator.of(context).pop();
        },
        icon: Icon(Icons.delete));
  }
}
