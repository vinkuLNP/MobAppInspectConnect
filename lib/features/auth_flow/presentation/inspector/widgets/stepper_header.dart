import 'package:clean_architecture/core/utils/values/colors.dart';
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
    return LayoutBuilder(
      builder: (context, c) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(labels.length, (i) {
            final active = i == current;
            final done = i < current;
            final bool isUpcoming = i > current;
            final bg = active
                ? theme.colorScheme.primary
                : done
                ? theme.colorScheme.primary
                : Colors.grey;
            final fg = active
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant;

            return Expanded(
              child: InkWell(
                onTap: onTap == null ? null : () => onTap!(i),
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: bg,
                        shape: BoxShape.circle,
                        border: isUpcoming
                            ? Border.all(
                                color: theme.colorScheme.outlineVariant,
                                width: 1.2,
                              )
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: done
                          ? Icon(Icons.check_rounded, color: white, size: 24)
                          : Text(
                              '${i + 1}',
                              style: TextStyle(
                                color: fg,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      labels[i],
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: active || done
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

