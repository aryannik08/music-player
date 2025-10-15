import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SliderWidget extends StatelessWidget {
  final RxDouble currentValue;

  const SliderWidget({super.key, required this.currentValue});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Obx(() {
      return Slider(
        inactiveColor: theme.colorScheme.onSurface.withOpacity(0.5),
        value: currentValue.value,
        min: 0,
        max: 255,
        label: currentValue.value.toStringAsFixed(0),
        onChanged: (value) {
          currentValue.value = value;
        },
      );
    });
  }
}
