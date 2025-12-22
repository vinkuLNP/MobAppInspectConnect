import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PerDigitOtp extends StatefulWidget {
  const PerDigitOtp({
    super.key,
    required this.length,
    required this.controller,
    this.boxSize = 56,
    this.boxGap = 12,
    this.onCompleted,
    this.autofillHints = const [AutofillHints.oneTimeCode],
    this.decorationBuilder,
    this.textStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    this.themeColor = const Color(0xFF3F51B5),
  });

  final int length;
  final TextEditingController controller;
  final double boxSize;
  final double boxGap;
  final VoidCallback? onCompleted;
  final List<String> autofillHints;
  final InputDecoration Function(bool focused, bool filled)? decorationBuilder;
  final TextStyle textStyle;
  final Color themeColor;

  @override
  State<PerDigitOtp> createState() => _PerDigitOtpState();
}

class _PerDigitOtpState extends State<PerDigitOtp> {
  late final List<TextEditingController> _digits;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _digits = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());

    _seedFromMaster(widget.controller.text);

    for (final c in _digits) {
      c.addListener(_syncToMaster);
    }
  }

  @override
  void didUpdateWidget(covariant PerDigitOtp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        oldWidget.length != widget.length) {
      _seedFromMaster(widget.controller.text);
    }
  }

  void _seedFromMaster(String value) {
    final sanitized = value.replaceAll(RegExp(r'\D'), '');
    for (var i = 0; i < _digits.length; i++) {
      _digits[i].text = i < sanitized.length ? sanitized[i] : '';
    }
    _syncToMaster();
  }

  void _syncToMaster() {
    final joined = _digits.map((c) => c.text).join();
    if (joined != widget.controller.text) {
      widget.controller.value = TextEditingValue(
        text: joined,
        selection: TextSelection.collapsed(offset: joined.length),
      );
      if (joined.length == widget.length) {
        widget.onCompleted?.call();
      }
    }
    setState(() {});
  }

  void _focusAt(int i) => _nodes[i].requestFocus();

  void _focusNext(int i) {
    if (i + 1 < _nodes.length) _focusAt(i + 1);
  }

  void _focusPrev(int i) {
    if (i - 1 >= 0) _focusAt(i - 1);
  }

  InputDecoration _decoration(bool focused, bool filled) {
    if (widget.decorationBuilder != null) {
      return widget.decorationBuilder!(focused, filled);
    }
    return InputDecoration(
      counterText: '',
      contentPadding: EdgeInsets.zero,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: widget.themeColor, width: 2),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _digits) {
      c.clear();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.length, (i) {
          final focused = _nodes[i].hasFocus;
          final filled = _digits[i].text.isNotEmpty;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.boxGap / 2),
            child: SizedBox(
              width: widget.boxSize,
              height: widget.boxSize,
              child: Focus(
                onKeyEvent: (node, event) {
                  if (event is! KeyDownEvent) return KeyEventResult.ignored;
                  final key = event.logicalKey;
                  if (key == LogicalKeyboardKey.arrowLeft) {
                    _focusPrev(i);
                    return KeyEventResult.handled;
                  }
                  if (key == LogicalKeyboardKey.arrowRight) {
                    _focusNext(i);
                    return KeyEventResult.handled;
                  }

                  if (key == LogicalKeyboardKey.backspace) {
                    if (_digits[i].text.isEmpty) {
                      if (i > 0) {
                        _focusPrev(i);
                        if (_digits[i - 1].text.isNotEmpty) {
                          _digits[i - 1].clear();
                          _syncToMaster();
                        }
                      }
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  }

                  return KeyEventResult.ignored;
                },
                child: TextField(
                  controller: _digits[i],
                  focusNode: _nodes[i],
                  textAlign: TextAlign.center,
                  style: widget.textStyle,
                  keyboardType: TextInputType.number,
                  textInputAction: i == widget.length - 1
                      ? TextInputAction.done
                      : TextInputAction.next,
                  maxLength: 1,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  autofillHints: widget.autofillHints,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _decoration(focused, filled),
                  onTap: () => _focusAt(i),
                  onChanged: (val) {
                    if (val.isEmpty) {
                      _focusPrev(i);
                    } else if (RegExp(r'^\d$').hasMatch(val)) {
                      _digits[i].text = val.substring(val.length - 1);
                      _digits[i].selection = const TextSelection.collapsed(
                        offset: 1,
                      );
                      _focusNext(i);
                    } else {
                      _digits[i].clear();
                    }
                    _syncToMaster();
                  },
                  onSubmitted: (_) {
                    if (i < widget.length - 1) {
                      _focusNext(i);
                    }
                  },
                  onEditingComplete: () {},
                  contextMenuBuilder: (ctx, editableTextState) {
                    return AdaptiveTextSelectionToolbar.buttonItems(
                      anchors: editableTextState.contextMenuAnchors,
                      buttonItems: editableTextState.contextMenuButtonItems
                          .where((b) {
                            return true;
                          })
                          .toList(),
                    );
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
