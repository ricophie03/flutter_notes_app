import 'package:flutter/material.dart';

const String tableNotes = 'notes'; // nama table yang nanti disimpan database

// Field dalam tabel database
class NoteFields {
  static final List<String> values = [
    // add all values
    id, isImportant, title, description, number, time
  ];

  // dioper ke list diatas agar nanti dapat dibaca datanya
  static final String id = '_id'; // id biasa selalu ada _ didepannya, _id
  static final String title = 'title';
  static final String description = 'description';
  static final String number = 'number';
  static final String isImportant = 'isImportant';
  static final String time = 'time';
}

class Note {
  final String? title;
  final String? description;
  final int? number;
  final bool? isImportant;
  final int? id;
  final DateTime? createdTime;

  Note(
      {this.id,
      this.title,
      this.createdTime,
      this.description,
      this.isImportant,
      this.number});

  Note copy(
      {final String? title,
      final String? description,
      final int? number,
      final bool? isImportant,
      final int? id,
      final DateTime? createdTime}) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      number: number ?? this.number,
      isImportant: isImportant ?? this.isImportant,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  Map<String, dynamic?> toJson() {
    // yang jadi Json adalah nama field yang ada di database

    return {
      NoteFields.id: id,
      NoteFields.title: title,
      NoteFields.description: description,
      NoteFields.isImportant: isImportant! ? 1 : 0,
      NoteFields.number: number,
      NoteFields.time: createdTime!.toIso8601String()
    };
  }

  static Note fromJson(Map<String, dynamic?> json) {
    return Note(
        id: json[NoteFields.id] as int?,
        title: json[NoteFields.title] as String?,
        description: json[NoteFields.description] as String?,
        number: json[NoteFields.number] as int?,
        createdTime: DateTime.parse(json[NoteFields.time] as String),
        isImportant: json[NoteFields.isImportant] == 1);
  }
}
