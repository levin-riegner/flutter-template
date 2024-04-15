// Create your own implementation of LocalValidationRules here by extending the interface
// Refer to the default implementations below for guidance on how to create your own
// Nullable fields are optional, pass them as null if you don't want to use them as validation rules
import 'package:flutter_template/util/tools/local_field_validation/rule_constants.dart';

abstract class LocalValidationRule<RuleType> {
  final String id;
  final RuleType? ruleValue;

  LocalValidationRule({
    required this.id,
    this.ruleValue,
  });

  bool satisfies(String? value);
}

class RequiredRule extends LocalValidationRule {
  RequiredRule({
    super.id = RuleConstants.requiredRuleId,
  });

  @override
  bool satisfies(String? value) => value?.isNotEmpty ?? false;
}

class MinLengthRule extends LocalValidationRule<int> {
  MinLengthRule({
    required super.ruleValue,
    super.id = RuleConstants.minLengthRuleId,
  });

  @override
  bool satisfies(String? value) => (value?.length ?? 0) >= (ruleValue ?? 0);
}

class MaxLengthRule extends LocalValidationRule<int> {
  @override
  MaxLengthRule({
    required super.ruleValue,
    super.id = RuleConstants.maxLengthRuleId,
  });

  @override
  bool satisfies(String? value) => (value?.length ?? 0) <= (ruleValue ?? 0);
}

class PatternRule extends LocalValidationRule<String> {
  PatternRule({
    required super.ruleValue,
    super.id = RuleConstants.patternRuleId,
  });

  @override
  bool satisfies(String? value) =>
      RegExp(ruleValue ?? "").hasMatch(value ?? "");
}
