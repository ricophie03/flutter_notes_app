import 'package:flutter/material.dart';
import 'package:sqlite_example_2/db/notes_database.dart';
import 'package:sqlite_example_2/model/note.dart';
import 'package:sqlite_example_2/page/edit_note_page.dart';
import 'package:sqlite_example_2/page/note_detail_page.dart';
import 'package:sqlite_example_2/widget/note_card_widget.dart';

class NotesPages extends StatefulWidget {
  @override
  _NotesPagesState createState() => _NotesPagesState();
}

class _NotesPagesState extends State<NotesPages> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(fontSize: 24),
        ),
        // actions: [
        //   Icon(Icons.search),
        //   SizedBox(width: 12),
        // ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : notes.isEmpty
                ? Text(
                    'No Notes',
                    style: TextStyle(color: Colors.white),
                  )
                : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return AddEditNotePage();
          }));
          refreshNotes();
        },
      ),
    );
  }

  @override
  void dispose() {
    NoteDatabases.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });
    notes = await NoteDatabases.instance.readAllNote();
    setState(() {
      isLoading = false;
    });
  }

  Widget buildNotes() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];

        return GestureDetector(
          onTap: () async {
            await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return NoteDetailPage(noteId: note.id!);
            }));
            refreshNotes();
          },
          child: NoteCardWidget(note: note, index: index),
        );
      },
    );
  }
}
