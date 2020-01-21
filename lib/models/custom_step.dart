
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class CustomStep {
  /// Creates a step for a [Stepper].
  ///
  /// The [title], [content], and [state] arguments must not be null.
  CustomStep({
    @required this.title,
    this.subtitle,
    this.content,
    this.state = StepState.indexed,
    this.isActive = false,
  }) : assert(title != null),
       assert(state != null);

  /// The title of the step that typically describes it.
   Widget title;

  /// The subtitle of the step that appears below the title and has a smaller
  /// font size. It typically gives more details that complement the title.
  ///
  /// If null, the subtitle is not shown.
   Widget subtitle;

  /// The content of the step that appears below the [title] and [subtitle].
  ///
  /// Below the content, every step has a 'continue' and 'cancel' button.
   List<Widget> content;

  /// The state of the step which determines the styling of its components
  /// and whether steps are interactive.
   StepState state;

  /// Whether or not the step is active. The flag only influences styling.
   bool isActive;

}