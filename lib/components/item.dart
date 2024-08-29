import 'package:flutter/material.dart';
import 'package:soundest/components/pickPlaylist.dart';
import 'package:soundest/editItem.dart';
import '../services/fetchItems.dart';
import 'dart:io';


class Item extends StatefulWidget{
  const Item({super.key, required this.login, required this.item, required this.setSong, required this.type, this.uploadItem, this.removeFromCloud_, this.removeItem, this.removeFromPlaylist_});
  final login;
  final item;
  final setSong;
  final String type;
  final uploadItem;
  final removeFromCloud_;
  final removeItem;
  final removeFromPlaylist_;

  @override
  State<Item> createState() => _Item(login: login, item: item, setSong: setSong, type: type, uploadItem: uploadItem, removeFromCloud_: removeFromCloud_, removeItem: removeItem, removeFromPlaylist_: removeFromPlaylist_);

}

class _Item extends State<Item>{
  _Item({required this.item, required this.login, required this.setSong, required this.type, this.uploadItem, this.removeFromCloud_, this.removeItem, this.removeFromPlaylist_});
  final login;
  final item;
  final setSong;
  final String type;
  final uploadItem;
  final removeFromCloud_;
  final removeItem;
  final removeFromPlaylist_;

  bool isLocal = false;
  bool isUploaded = false;

  @override
  void initState() {
    checkStates();
  }

  void checkStates() async {
    super.initState();
    if (item.containsKey('path')){
      isLocal = true;
    }
    if (await getIsUploaded(item['id'], login)){
      isUploaded = true;
    }
    setState(() {});
  }

  void editItem_(int id, String filename, String title, String author) {
    setState(() {
      item['title'] = title;
      item['author'] = author;
    });
    editItem(id, login, filename, title, author);
  }

  @override
  Widget build(BuildContext context){
    return Container(
      width: 1000,
      height: 62,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).primaryColor
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell (
        onTap: () => setSong(item),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'], style: const TextStyle(fontSize: 15)),
                    Text(item['author'], style: const TextStyle(fontSize: 13)),
                  ]
                ),
              ),
              PopupMenuButton(
                color: Theme.of(context).scaffoldBackgroundColor,
                itemBuilder: (BuildContext context) => [
                    if (!isLocal && isUploaded && type != 'playlist')
                      PopupMenuItem(
                        value: 1,
                        child: const Text('Скачать на устройство'),
                        onTap: () async {
                          await downloadItem(item, login, context);
                          final title = item['title'];
                          final author = item['author'];
                          item['path'] = '/storage/emulated/0/Music/$title@$author.mp3';
                          isLocal = true;
                          setState(() => {});
                        },
                      ),
                    if (isLocal && !isUploaded && type != 'playlist')
                      PopupMenuItem(
                        value: 1,
                        child: const Text('Загрузить в облако'),
                        onTap: () {
                          uploadItem(item, context);
                          setState(() => isUploaded = true);
                        },
                      ),
                    if (isLocal && type != 'playlist')
                      PopupMenuItem(
                        value: 1,
                        child: const Text('Удалить с устройства'),
                        onTap: () {
                          final title = item['title'];
                          final author = item['author'];
                          final file = File("/storage/emulated/0/Music/$title@$author.mp3");
                          file.deleteSync();
                          if (!isUploaded){
                            removeItem(item['id']);
                          }
                          isLocal = false;
                          item.remove('path');
                          setState(() => {});
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Трек удален с устройства')));
                        },
                      ),
                    if (isUploaded && type != 'playlist')
                      PopupMenuItem(
                        value: 1,
                        child: const Text('Удалить из облака'),
                        onTap: () {
                          removeFromCloud_(item['id'], context);
                          if (!isLocal){
                            removeItem(item['id']);
                          }
                          setState(() => isUploaded = false);
                        },
                      ),
                    PopupMenuItem(
                      value: 1,
                      child: const Text('Добавить в плейлист'),
                      onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => PickPlaylist(login: login, item: item)
                      ),
                    ),
                    if (type == 'playlist')
                      PopupMenuItem(
                        value: 1,
                        child: const Text('Удалить из плейлиста'),
                        onTap: () => removeFromPlaylist_(item['id']),
                      ),
                    PopupMenuItem(
                      value: 2,
                      child: const Text('Изменить название или автора'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EditItem(data: item, editItem: editItem_))),
                    ),
                ]),
            ]
          )
        ) 
      )
    );
  }
}