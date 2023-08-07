// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

enum PopupStyle { bottomSheetModal, fullScreenModal, dialogScreenModal }

class SearchableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final Function(T?) onSelectedItemChanged;
  final String Function(T) displayItem;
  final PopupStyle? popupStyle;
  final TextEditingController textController;
  final T selectedItem;
  final String title;
  final bool? searchable;
  final String searchText;
  final String searchKey;
  final String? value;
  final TextStyle? itemTextStyle;
  final bool showSelected;

  const SearchableDropdown({
    Key? key,
    required this.items,
    required this.onSelectedItemChanged,
    required this.displayItem,
    this.popupStyle = PopupStyle.bottomSheetModal,
    required this.textController,
    required this.selectedItem,
    required this.title,
    this.value,
    this.itemTextStyle,
    this.searchable = false,
    this.searchText = "Search ...",
    this.searchKey = "",
    this.showSelected = false,
  }) : super(key: key);

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    widget.textController.text = widget.value ?? "";
    return TextFormField(
      readOnly: true,
      controller: widget.textController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(12),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        fillColor: Colors.white,
        iconColor: Colors.white,
        filled: true,
        isDense: true,
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      onTap: () async {
        T? res;
        if (widget.popupStyle == PopupStyle.bottomSheetModal) {
          res = await showModalBottomSheet<T>(
            context: context,
            builder: (context) {
              return DialogDropdown<T>(
                title: widget.title,
                items: widget.items,
                selectedItem: widget.selectedItem,
                onChanged: widget.onSelectedItemChanged,
                displayItem: widget.displayItem,
                searchable: widget.searchable ?? false,
                searchText: widget.searchText,
                searchKey: widget.searchKey,
              );
            },
          );
          if (res != null) {
            widget.textController.text = widget.displayItem(res);
          }
        }
        if (widget.popupStyle == PopupStyle.fullScreenModal) {
          res = await Navigator.push<T>(
            context,
            MaterialPageRoute<T>(
              builder: (BuildContext context) => DialogDropdown<T>(
                title: widget.title,
                items: widget.items,
                selectedItem: widget.selectedItem,
                onChanged: widget.onSelectedItemChanged,
                displayItem: widget.displayItem,
                itemTextStyle: widget.itemTextStyle,
                searchable: widget.searchable ?? false,
                searchText: widget.searchText,
                searchKey: widget.searchKey,
                showSelected: widget.showSelected,
              ),
            ),
          );
          if (res != null) {
            widget.textController.text = widget.displayItem(res);
          }
        }

        if (res != null) {
          widget.onSelectedItemChanged(res);
        }

        // Navigator.pop(context, res);
      },
    );
  }
}

class DialogDropdown<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final T selectedItem;
  final ValueChanged<T?> onChanged;
  final String Function(T) displayItem;
  final PopupStyle? popupStyle;
  final TextStyle? itemTextStyle;
  final bool searchable;
  final String searchText;
  final String searchKey;
  final bool showSelected;

  const DialogDropdown({
    Key? key,
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.displayItem,
    required this.searchable,
    this.searchText = "Search ...",
    this.searchKey = "",
    this.popupStyle = PopupStyle.bottomSheetModal,
    this.itemTextStyle,
    this.showSelected = false,
  }) : super(key: key);

  @override
  _DialogDropdownState<T> createState() => _DialogDropdownState<T>();
}

class _DialogDropdownState<T> extends State<DialogDropdown<T>> {
  TextEditingController textSearch = TextEditingController();

  List<T> fullItems = [];
  List<T> filteredItems = [];

  @override
  void initState() {
    setState(() {
      fullItems = widget.items;
      filteredItems = fullItems;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Column(
        children: [
          Visibility(
            visible: widget.popupStyle == PopupStyle.fullScreenModal,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 0),
          Visibility(
            visible: widget.searchable,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextFormField(
                controller: textSearch,                
                decoration: InputDecoration(
                  filled: false,
                  hintText: widget.searchText,
                  focusColor: Colors.white,
                  hoverColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide: const BorderSide(width: 1.2),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      textSearch.clear();
                      filteredItems = fullItems;
                      setState(() {});
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
                onChanged: (value) {
                  filteredItems = fullItems.where((item) {
                    if (widget.searchable) {                                          
                      try {
                        return item.toString().toLowerCase().contains(value);
                      } catch (e) {
                        return false;
                      }
                    }
                    return false;
                  }).toList();
                  setState(() {});
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                T item = filteredItems[index];

                bool selected = item == widget.selectedItem;

                if (!widget.showSelected) selected = false;

                return Container(
                  margin: EdgeInsets.only(
                      bottom: index == (filteredItems.length - 1) ? 16 : 0),
                  color: selected ? Colors.grey.shade100 : null,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                    title: Text(
                      widget.displayItem(item),
                      style: widget.itemTextStyle,
                    ),
                    trailing: selected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      Navigator.pop(context, item);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
