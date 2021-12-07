import 'package:flutter/material.dart';

void unfocus(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
}

class SwatchEdit extends FormField<int> {
  SwatchEdit({
    Key? key,
    String? label,
    String? hint,
    String? description,
    required int initialValue,
    FormFieldValidator<int>? validator,
    FormFieldSetter<int>? onSaved,
    required this.swatches,
    this.onChanged,
  })  : decoration = InputDecoration(
          labelText: label,
          hintText: hint,
          helperText: description,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          border: InputBorder.none,
          isDense: true,
        ),
        super(
          key: key,
          initialValue: initialValue,
          validator: validator,
          onSaved: onSaved,
          builder: (FormFieldState<int> field) =>
              (field as _SwatchEditState)._build(field.context),
        );

  @override
  _SwatchEditState createState() => _SwatchEditState();

  final InputDecoration? decoration;
  final List<MaterialColor> swatches;
  final ValueChanged<int>? onChanged;
}

class _SwatchEditState extends FormFieldState<int> {
  @override
  SwatchEdit get widget => super.widget as SwatchEdit;

  final double _swatchSize = 45.0;

  Widget _buildSwatch(BuildContext context, int index) {
    var item = widget.swatches[index];
    return CircleAvatar(
        backgroundColor: item,
        child: IconButton(
          color: value != index ? item : Colors.black,
          icon: const Icon(Icons.check),
          onPressed: widget.enabled
              ? () {
                  unfocus(context);
                  didChange(index);
                  if (widget.onChanged != null) widget.onChanged!(value!);
                }
              : null,
        ));
  }

  Widget _build(BuildContext context) {
    double scrollOfs = (value! - 2) * _swatchSize;
    if (scrollOfs < 0) scrollOfs = 0;
    final selector = SizedBox(
        height: _swatchSize - 6,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          controller: ScrollController(initialScrollOffset: scrollOfs),
          itemExtent: _swatchSize,
          itemCount: widget.swatches.length,
          itemBuilder: _buildSwatch,
        ));
    return InputDecorator(
      decoration: widget.decoration!.copyWith(errorText: errorText),
      isEmpty: true,
      child: selector,
    );
  }
}
