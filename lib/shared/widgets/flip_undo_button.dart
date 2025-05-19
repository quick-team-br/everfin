import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:everfin/core/theme/app_colors.dart';
import 'package:everfin/core/theme/styles/button_styles.dart';

class FlipUndoButton extends StatefulWidget {
  final VoidCallback? onConfirmed;
  final Duration delay;
  final String undoLabel;
  final Widget front;

  const FlipUndoButton({
    super.key,
    this.onConfirmed,
    required this.front,
    this.delay = const Duration(seconds: 5),
    this.undoLabel = 'Undo',
  });

  @override
  State<FlipUndoButton> createState() => _FlipUndoButtonState();
}

class _FlipUndoButtonState extends State<FlipUndoButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _startCountdown() {
    setState(() {
      _isFlipped = true;
      _remainingSeconds = widget.delay.inSeconds;
    });
    _controller.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) {
          _completeAction();
        }
      });
    });
  }

  void _cancelAction() {
    _timer?.cancel();
    _controller.reverse().then((_) {
      setState(() {
        _isFlipped = false;
      });
    });
  }

  void _completeAction() {
    _timer?.cancel();
    widget.onConfirmed?.call();
    _controller.reverse().then((_) {
      setState(() {
        _isFlipped = false;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isFlipped ? _cancelAction : _startCountdown,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * pi;
          final isFront = angle <= pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(angle),
            child: isFront ? widget.front : _buildBack(),
          );
        },
      ),
    );
  }

  Widget _buildBack() {
    double progress =
        _remainingSeconds / widget.delay.inSeconds.clamp(1, double.infinity);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateX(pi),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.redAlpha,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Text(
              '${widget.undoLabel} (${_remainingSeconds}s)',
              style: ButtonStyles.elevated().textStyle
                  ?.resolve({})
                  ?.copyWith(color: AppColors.red),
            ),
            Positioned(
              bottom: -12,
              left: -6,
              right: -6,
              child: FractionallySizedBox(
                alignment: Alignment.bottomLeft,
                widthFactor: progress,
                child: Container(height: 2, color: AppColors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
