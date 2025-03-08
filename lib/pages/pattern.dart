import 'package:flutter/material.dart';
import 'package:torcher/state.dart';

import '../utils/dialogs.dart';

class PatternEdit extends StatefulWidget {
  const PatternEdit({Key? key, required this.appState}) : super(key: key);

  final AppState appState;

  @override
  State<PatternEdit> createState() => _PatternEditState();
}

class _PatternEditState extends State<PatternEdit> {
  Widget buildTitle(String title) {
    const textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue);
    return Expanded(
      flex: 2,
      child: InkWell(
          onTap: () => showDialog(context: context, builder: buildAboutDialog),
          child: Center(child: Text(title, style: textStyle))),
    );
  }

  final Color activeButtonColor = Colors.blue[600]!;
  final Color inactiveButtonColor = Colors.blue[200]!;
  Widget _buildButtonFeedback(String caption, bool state, Function()? func) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        foregroundColor: state ? activeButtonColor : inactiveButtonColor,
      ),
      onPressed: func != null ? () => setState(func) : null,
      child: Text(caption),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          buildTitle('Flashlight Torcher'),
          const Text("Custom pattern"),
          const Text('.-o*'),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildButtonFeedback("Hello", true, null),
              const Text('Short pause'),
              const Text('Long pause'),
              const Text('Short light'),
              const Text('Long light'),
            ],
          )
        ],
      ),
    );
  }
}
