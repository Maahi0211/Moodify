import 'package:flutter/material.dart';
import 'package:moodify/models/mood.dart';

//Constants in Dart should be written in lowerCamelcase.
const  availableCategories = [
  Mood(
    id: 'c1',
    title: 'Happy',
    color: Color.fromARGB(255, 102, 208, 119),
  ),
  Mood(
    id: 'c2',
    title: 'Sad',
    color: Color.fromARGB(255, 214, 176, 110),
  ),
  Mood(
    id: 'c3',
    title: 'Folk',
    color: Color.fromARGB(255, 113, 208, 224),
  ),
  Mood(
    id: 'c4',
    title: 'pop',
    color: Color.fromARGB(255, 169, 104, 235),
  ),
    Mood(
    id: 'c5',
    title: 'Piano',
    color: Color.fromARGB(222, 240, 181, 70),
    
  ),

    Mood(
    id: 'c6',
    title: 'Classical',
    color: Color.fromARGB(255, 205, 196, 226),
    
  ),


];