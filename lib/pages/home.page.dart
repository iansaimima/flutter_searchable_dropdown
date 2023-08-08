import 'package:dropdown_search/models/fruits.model.dart';
import 'package:dropdown_search/pages/searchable_dropdown.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var textController = TextEditingController();

  List<Fruit> fruits = [
    Fruit(name: "Apel", color: "Merah"),
    Fruit(name: "Jeruk", color: "Orange"),
    Fruit(name: "Pisang", color: "Kuning"),
    Fruit(name: "Melon", color: "Hijau"),
  ];
  Fruit? selectedFruit;

  @override
  void initState() {
    selectedFruit = fruits.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SearchableDropdown<Fruit>(
              textController: textController,
              title: "Pilih buah",
              items: fruits,
              selectedItem: selectedFruit!,
              value: selectedFruit!.name,
              onSelectedItemChanged: (value) {
                setState(() {
                  selectedFruit = value;
                });
              },
              displayItem: (Fruit fruit) => fruit.name ?? "",
              // popupStyle: PopupStyle.fullScreenModal,
              searchable: true,
              searchText: "Cari",
              showSelected: true,
            ),
            const SizedBox(height: 16),
            Text("Buah yang dipilih ${selectedFruit!.name}, berwarna ${selectedFruit!.color}"),
          ],
        ),
      ),
    );
  }
}
