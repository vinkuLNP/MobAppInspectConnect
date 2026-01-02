import 'package:flutter/material.dart';

class StepMeta {
  final String title;
  final Widget content;
  final GlobalKey<FormState> formKey;
  StepMeta(this.title, this.content, this.formKey);
}
