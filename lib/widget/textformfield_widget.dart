import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final void Function(String)? onChange;

  const TextFormFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    required this.obscureText,
    this.readOnly = false,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
    this.onChange,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      inputFormatters: [...widget.inputFormatters],
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      onChanged: widget.onChange,
    );
  }
}
