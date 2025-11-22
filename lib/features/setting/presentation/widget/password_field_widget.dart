import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/resources/colors.dart' as AppColors;

class PasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool showStrengthIndicator;

  const PasswordFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.onChanged,
    this.showStrengthIndicator = false,
  });

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool _obscureText = true;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 69,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(color: orange),
            keyboardType: TextInputType.visiblePassword,
            onChanged: (value) {
              if (widget.validator != null) {
                setState(() {
                  _errorText = widget.validator!(value);
                });
              }
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            validator: widget.validator,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              label: Text(
                widget.label.tr(),
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: AppColors.navy),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white.withOpacity(0.7),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              errorText: _errorText,
              errorStyle: TextStyle(
                color: Colors.red[300],
                fontSize: 12,
              ),
            ),
          ),
        ),
        // if (_errorText != null && _errorText!.isNotEmpty)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 8, left: 12),
        //     child: Text(
        //       _errorText!,
        //       style: TextStyle(
        //         color: Colors.red[300],
        //         fontSize: 12,
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
