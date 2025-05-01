import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/svg.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    required this.label,
    this.selectedItem,
    this.onChanged,
  });
  final List<String> items;
  final String? selectedItem;
  final String label;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 12),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            value: selectedItem,
            items:
                items.isEmpty
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
                    : items
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
            onChanged: onChanged,
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
                angle: -1.6, // -90 degrees in radians
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

// decoration: InputDecoration(
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: Theme.of(context).colorScheme.outline,
//                 width: 2,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: Theme.of(context).primaryColor,
//                 width: 2,
//               ),
//             ),
//             filled: false,
//           ),
//           icon: Transform.rotate(
//             angle: -1.6, // -90 degrees in radians
//             child: SvgPicture.asset(
//               'assets/svgs/arrow_with_shadow_icon.svg',
//               width: 20,
//               colorFilter: ColorFilter.mode(
//                 Theme.of(context).textTheme.labelMedium?.color ?? Colors.black,
//                 BlendMode.srcIn,
//               ),
//               semanticsLabel: "Abrir opções",
//             ),
//           ),
          
//           value: selectedItem,
//           items:
//               items.map((String item) {
//                 return DropdownMenuItem<String>(value: item, child: Text(item));
//               }).toList(),
//           onChanged: (String? novoValor) {
//             print('Opção selecionada: $novoValor');
//           },