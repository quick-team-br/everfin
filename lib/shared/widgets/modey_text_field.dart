import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'package:everfin/core/extensions/int_extensions.dart';

class MoneyTextField extends StatefulWidget {
  final String label;
  final int? defaultValue;
  final Function(int)? onChanged;

  const MoneyTextField({
    super.key,
    this.label = "Valor",
    this.onChanged,
    this.defaultValue = 0,
  });

  @override
  State<MoneyTextField> createState() => _MoneyTextFieldState();
}

class _MoneyTextFieldState extends State<MoneyTextField> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  String _formatNumber(String s) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: '',
      decimalDigits: 2,
    );
    final number = double.tryParse(s.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return formatter.format(number / 100);
  }

  void _onTextChanged(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    final intValue = int.tryParse(digitsOnly) ?? 0;

    final formatted = _formatNumber(digitsOnly);
    _controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    if (widget.onChanged != null) widget.onChanged!(intValue);
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.defaultValue?.toBRLWithoutSymbol(),
    );
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor =
        _hasFocus
            ? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.outline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: Theme.of(context).textTheme.bodyMedium,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: _onTextChanged,
            decoration: InputDecoration(
              prefixText: 'R\$ ',
              prefixStyle: Theme.of(context).textTheme.bodyMedium,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
