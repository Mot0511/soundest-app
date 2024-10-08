import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:soundest/services/fetchItems.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:soundest/utils/checkInternet.dart';
import 'package:soundest/utils/prefs.dart';

// Получение списка плейлистов
Future<Map<String, List>> getPlaylists(String login) async {
  Map<String, List> playlists = {};
  if (await internet()){
    DatabaseReference ref = FirebaseDatabase.instance.ref('/users/$login/playlists');
    final snap = await ref.get();
    final data = snap.value;

    if (data != null){
      (data as Map).forEach((key, value){
        List<int> list = List.from(value);
        playlists[key] = list;
      });
    }
  }

  return playlists;
}

// Получение списка id треков в одном плейлисте
Future<List> getPlaylist(String login, String name) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref('/users/$login/playlists/$name');
  final snap = await ref.get();
  final data = (snap.value as List).toList();

  return data;
}

// Добавление трека в плейлист
void addInPlaylist(int songID, String login, String name) async {
  final playlist = await getPlaylist(login, name);
  playlist.add(songID);

  DatabaseReference ref = FirebaseDatabase.instance.ref('/users/$login/playlists/$name');
  await ref.set(playlist);

}

// Добавление трека в передаваемый список, возвращается измененный список плейлистов
List<int> addItem(List<int> list, int id) {
  list.add(id);
  return list;
}

// Удаление плейлиста из облака
Future<void> removeFromCloudPlaylist(int id, String login) async {
  final DatabaseReference playlistsRef = FirebaseDatabase.instance.ref('users/$login/playlists/');
  final snap = await playlistsRef.get();
  final data = (snap.value as Map);

  for (final el in data.entries){
    final items = el.value.toList();
    if (items.contains(id)){
      items.remove(id);
    }
    final playlist = el.key;
    final DatabaseReference playlistRef = FirebaseDatabase.instance.ref('users/$login/playlists/$playlist');
    await playlistRef.set(items);
  }

}

// Удаление трека из плейлиста
Future<List<int>> removeFromPlaylist(List list, int id, String login, String name) async {
  List<int> newList = [];
  list.forEach((item) {
    if (item != id){
      newList.add(item);
    }
  });

  await removeFromCloudPlaylist(id, login);

  return newList;
}

// Создание плейлиста
void createPlaylist(String login, String name) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref('/users/$login/playlists');
  Map<String, List> playlists = await getPlaylists(login);
  playlists[name] = [0];
  ref.set(playlists);

}

// Удаление плейлиста из облака
void removePlaylist(String login, String name) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref('/users/$login/playlists/$name');
  ref.remove();
}

// Получение треков из плейлиста
Future<List<Map>> getItemsByIds(String login, List list, BuildContext context) async {
  final List<Map> items = await getItems(login, context);
  final List<Map> newItems = [];

  list.forEach((id){
    items.forEach((item){
      if (item['id'] == id){
        newItems.add(item);
      }
    });
  });

  return newItems;
}