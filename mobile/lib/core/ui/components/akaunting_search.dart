import 'package:flutter/material.dart';

class AkauntingSearch extends StatelessWidget {
  final String placeholder;
  final String? value;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const AkauntingSearch({
    super.key,
    this.placeholder = 'Search or filter results...',
    this.value,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    // Manually create the controller and set the cursor to the end
    // so that we don't get the reversed text formatting error.
    final controller = TextEditingController(text: value ?? '');
    if (value != null) {
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: value!.length),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        // Submit only on "Enter" or when text is cleared completely
        onSubmitted: onChanged,
        onChanged: (val) {
          if (val.isEmpty && onChanged != null) {
            onChanged!('');
          }
        },
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: value != null && value!.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                  onPressed: onClear,
                )
              : IconButton(
                  icon: const Icon(Icons.search, color: Colors.grey, size: 20),
                  onPressed: () {
                    if (onChanged != null) onChanged!(controller.text);
                  },
                ),
        ),
      ),
    );
  }
}
