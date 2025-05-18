import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/svg.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    required this.label,
    this.defaultValue,
    this.onChanged,
    this.selectedItem,
  });
  final List<String> items;
  final String? defaultValue;
  final String? selectedItem;
  final String label;
  final Function(String?)? onChanged;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.defaultValue;
  }

  @override
  void didUpdateWidget(CustomDropdown oldWidget) {
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
          child: DropdownButton2<String>(
            isExpanded: true,
            value:
                widget.items.isNotEmpty
                    ? widget.selectedItem ?? _selectedItem
                    : null,
            items:
                widget.items.isEmpty
                    ? [""]
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        )
                        .toList()
                    : widget.items
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        )
                        .toList(),
            onChanged: (value) {
              setState(() {
                _selectedItem = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
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
                    Theme.of(context).textTheme.labelMedium?.color ??
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
