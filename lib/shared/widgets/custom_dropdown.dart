import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/svg.dart';

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    required this.label,
    this.defaultValue,
    this.onChanged,
    this.selectedItem,
    this.itemToString,
  });
  final List<T> items;
  final T? defaultValue;
  final T? selectedItem;
  final String label;
  final Function(T?)? onChanged;
  final String Function(T)? itemToString;

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.defaultValue;
  }

  @override
  void didUpdateWidget(CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != oldWidget.selectedItem) {
      _selectedItem = widget.selectedItem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 12),
        DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            isExpanded: true,
            value:
                widget.items.isNotEmpty
                    ? widget.selectedItem ?? _selectedItem
                    : null,
            items:
                widget.items.map((item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      widget.itemToString?.call(item) ?? "",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedItem = value;
              });
              widget.onChanged?.call(value);
            },
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 2,
                ),
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Transform.rotate(
                angle: -1.6,
                child: SvgPicture.asset(
                  'assets/svgs/arrow_with_shadow_icon.svg',
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).textTheme.bodyMedium?.color ??
                        Colors.black,
                    BlendMode.srcIn,
                  ),
                  semanticsLabel: "Abrir opções",
                ),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).cardColor,
              ),
              maxHeight: 200,
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}
