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
    Fruit(name: "Apple", color: "Red"),
    Fruit(name: "Banana", color: "Yellow"),
    Fruit(name: "Pisang", color: "Kuning"),
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
              title: "Select Fruit",
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
            Text("Selected fruit is ${selectedFruit!.name}"),
          ],
        ),
      ),
    );
  }
}
