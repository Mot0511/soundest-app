import 'package:flutter/material.dart';
import '../services/fetchItems.dart';
import 'dart:io';


class Item extends StatefulWidget{
  const Item({super.key, required this.login, required this.item, required this.remove, required this.setSong, required this.uploadItem});
  final login;
  final item;
  final remove;
  final setSong;
  final uploadItem;

  @override
  State<Item> createState() => _Item(login: login, item: item, remove: remove, setSong: setSong, uploadItem: uploadItem);

}

class _Item extends State<Item>{
  _Item({required this.item, required this.login, required this.remove, required this.setSong, required this.uploadItem});
  final login;
  final item;
  final remove;
  final setSong;
  final uploadItem;

  bool isLocal = false;
  bool isUploaded = false;

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

  @override
  void initState() {
    checkStates();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      width: 1000,
      height: 62,
      margin: EdgeInsets.only(bottom: 10),
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
          padding: EdgeInsets.all(10),
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
                    if (!isLocal && isUploaded)
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
                    if (isLocal && !isUploaded)
                      PopupMenuItem(
                        value: 1,
                        child: const Text('Загрузить в облако'),
                        onTap: () {
                          uploadItem(item, context);
                          setState(() => isUploaded = true);
                        },
                      ),
                    if (isLocal)
                      PopupMenuItem(
                        value: 1,
                        child: const Text('Удалить с устройства'),
                        onTap: () {
                          final title = item['title'];
                          final author = item['author'];
                          final file = File("/storage/enulated/0/$title@$author.mp3");
                          file.deleteSync();
                          if (!isUploaded){
                            remove(item['id']);
                          }
                          setState(() => isLocal = false);
                        },
                      ),
                    if (isUploaded)
                      PopupMenuItem(
                        value: 1,
                        child: const Text('Удалить из облака'),
                        onTap: () {
                          setState(() => isUploaded = false);
                        },
                      ),
                    PopupMenuItem(
                      value: 1,
                      child: const Text('Добавить в плейлист'),
                      onTap: () => remove(item['id']),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: const Text('Изменить название или автора'),
                      onTap: () => remove(item['id']),
                    ),
                ]),
            ]
          )
        ) 
      )
    );
  }
}