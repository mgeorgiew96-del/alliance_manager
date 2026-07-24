enum ProgressPriority { mandatory, recommended, optional }

extension ProgressPriorityX on ProgressPriority {
  String get label {
    switch (this) {
      case ProgressPriority.mandatory:
        return 'Mandatory';
      case ProgressPriority.recommended:
        return 'Recommended';
      case ProgressPriority.optional:
        return 'Optional';
    }
  }

  int get sortOrder {
    switch (this) {
      case ProgressPriority.mandatory:
        return 0;
      case ProgressPriority.recommended:
        return 1;
      case ProgressPriority.optional:
        return 2;
    }
  }
}
