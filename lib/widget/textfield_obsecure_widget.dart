import 'package:flutter/material.dart';

class TextFieldObscure extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final InputDecoration? decoration;

  const TextFieldObscure({
    super.key,
    required this.controller,
    required this.hintText,
    this.decoration, // Menerima InputDecoration
  });

  @override
  State<TextFieldObscure> createState() => _TextFieldObscureState();
}

class _TextFieldObscureState extends State<TextFieldObscure> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    // Mengambil dekorasi yang disuplai atau menggunakan dekorasi dasar jika null
    final baseDecoration = widget.decoration ?? const InputDecoration();

    return TextField(
      controller: widget.controller,
      obscureText: _isObscure,
      keyboardType: TextInputType.text,
      decoration: baseDecoration.copyWith(
        // Menggabungkan dekorasi dari luar dengan ikon visibility toggle
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
            color: Colors.black54,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
        // Menggunakan hintText dari parameter widget jika labelText/hintText di decoration kosong
        hintText: baseDecoration.hintText ?? widget.hintText,
      ),
    );
  }
}
