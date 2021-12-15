import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class StateMachineWiget extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    Map<String, SMIInput> inputs,
    StateMachineController controller,
    Rive rive,
  ) builder;
  final Map<String, Type> inputs;
  final String stateMachineName;
  final String assetPath;

  const StateMachineWiget({
    required this.builder,
    required this.inputs,
    required this.stateMachineName,
    required this.assetPath,
  });

  @override
  _StateMachineWigetState createState() => _StateMachineWigetState();
}

class _StateMachineWigetState extends State<StateMachineWiget> {
  bool get isPlaying => _controller?.isActive ?? false;

  late Artboard? _riveArtboard;
  StateMachineController? _controller;
  final Map<String, SMIInput> _inputs = {};

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/rocket.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        final controller =
            StateMachineController.fromArtboard(artboard, 'Button');
        if (controller != null) {
          artboard.addController(controller);
          for (var i = 0; i < widget.inputs.entries.length; i++) {
            final _key = widget.inputs.keys.toList()[i];
            _inputs[_key] = controller.findInput<dynamic>(_key)!;
          }
        }
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _rive = Rive(
      artboard: _riveArtboard!,
    );
    return widget.builder(
      context,
      _inputs,
      _controller!,
      _rive,
    );
  }
}
