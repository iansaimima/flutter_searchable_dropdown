// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

enum PopupStyle { bottomSheetModal, fullScreenModal }

class SearchableDropdown<T> extends StatefulWidget {
  /// dropdown items
  final List<T> items;

  /// trigger to set textfield value
  /// and send back selected item to parent
  final Function(T?) onSelectedItemChanged;

  /// to set which item will displayed
  final String Function(T) displayItem;

  /// set popup style
  /// - fullScreenModal
  /// - bottomSheetModal
  final PopupStyle? popupStyle;

  /// textediting controller
  final TextEditingController textController;

  /// set selectedItem
  final T selectedItem;

  /// set title
  final String title;

  /// set searchable
  final bool? searchable;

  /// set search text label
  final String searchText;

  /// set textController value
  final String? value;

  /// set dropdown item text style
  final TextStyle? itemTextStyle;

  /// to set show selected item or not
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
    this.showSelected = false,
  }) : super(key: key);

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    widget.textController.text = widget.value ?? "";

    /// =================================================
    /// generate textfield to show selected dropdown item
    /// =================================================
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

        /// =======================================
        /// show dropdown list as bottomsheet modal
        /// =======================================
        if (widget.popupStyle == PopupStyle.bottomSheetModal) {
          res = await showModalBottomSheet<T>(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return FractionallySizedBox(
                heightFactor: 0.7,
                child: DialogDropdown<T>(
                  title: widget.title,
                  items: widget.items,
                  selectedItem: widget.selectedItem,
                  onChanged: widget.onSelectedItemChanged,
                  displayItem: widget.displayItem,
                  searchable: widget.searchable ?? false,
                  searchText: widget.searchText,
                ),
              );
            },
          );
        }

        /// ======================================
        /// show dropdown list as fullscreen modal
        /// ======================================
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
                showSelected: widget.showSelected,
              ),
            ),
          );
        }

        /// =============================================
        /// set the result to textfield and parent widget
        /// =============================================
        if (res != null) {
          widget.textController.text = widget.displayItem(res);
          widget.onSelectedItemChanged(res);
        }
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
  final TextStyle? itemTextStyle;
  final bool searchable;
  final String searchText;
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
          /// ===============================================
          /// generate textfield search if searchable is true
          /// ===============================================
          Visibility(
            visible: widget.searchable,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),

              /// ================
              /// textfield search
              /// ================
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
                      /// ======================
                      /// clear search textfield
                      /// ======================
                      textSearch.clear();
                      filteredItems = fullItems;
                      setState(() {});
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
                onChanged: (value) {
                  filteredItems = fullItems.where((item) {
                    /// searchable
                    if (widget.searchable) {
                      try {
                        /// ====================
                        /// search dropdown item
                        /// ====================
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

          /// ===========================
          /// generate dropdown item list
          /// ===========================
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                T item = filteredItems[index];

                /// ========================================
                /// if show selected, then set selected item
                bool selected = item == widget.selectedItem;

                ///
                /// if not show selected, then selected item always false
                if (!widget.showSelected) selected = false;

                /// ========================================

                /// ======================
                /// generate dropdown item
                /// ======================
                return Container(
                  margin: EdgeInsets.only(
                      bottom: index == (filteredItems.length - 1) ? 16 : 0),

                  /// ========================================
                  /// set background color if selected is true
                  /// ========================================
                  color: selected ? Colors.grey.shade100 : null,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),

                    /// =======================
                    /// show dropdown item text
                    /// =======================
                    title: Text(
                      widget.displayItem(item),
                      style: widget.itemTextStyle,
                    ),

                    /// =====================================
                    /// show checked icon if selected is true
                    /// =====================================
                    trailing: selected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      /// ========================
                      /// close dropdown item list
                      /// ========================
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
