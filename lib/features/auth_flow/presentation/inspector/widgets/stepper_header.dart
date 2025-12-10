import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:flutter/material.dart';

class StepperHeader extends StatelessWidget {
  final int current;
  final List<String> labels;
  final void Function(int index)? onTap;

  const StepperHeader({
    super.key,
    required this.current,
    required this.labels,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(labels.length * 2 - 1, (index) {
          final i = index ~/ 2;
          final bool isConnector = index.isOdd;

          if (isConnector) {
            final bool done = i < current;
            final Color connectorColor = done
                ? theme.colorScheme.primary
                : Colors.grey.shade400;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 60, 
              height: 2,
              color: connectorColor,
            );
          }

          final bool active = i == current;
          final bool done = i < current;
          final bool upcoming = i > current;

          final Color circleColor = active || done
              ? theme.colorScheme.primary
              : Colors.grey.shade400;

          final Color textColor = active || done
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurfaceVariant;

          return InkWell(
            onTap: onTap == null ? null : () => onTap!(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
                border: upcoming
                    ? Border.all(
                        color: theme.colorScheme.outlineVariant,
                        width: 1.2,
                      )
                    : null,
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha:0.3),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: done
                  ? Icon(Icons.check_rounded, color: Colors.white, size: 20)
                  : textWidget(
                      text: '${i + 1}',
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
            ),
          );
        }),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return textWidget(text: text, fontSize: 16, fontWeight: FontWeight.w600);
  }
}
