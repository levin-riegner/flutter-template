import 'package:flutter/material.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:flutter_template/util/tools/local_field_validation/local_validation_rules.dart';
import 'package:flutter_template/util/tools/local_field_validation/rule_constants.dart';

extension LocalValidationRuleLocalized on LocalValidationRule {
  String defaultLocalizedMessage(BuildContext context) {
    return switch (id) {
      RuleConstants.requiredRuleId => context.l10n.fieldErrorRequired,
      RuleConstants.minLengthRuleId =>
        context.l10n.fieldErrorMinLength(ruleValue),
      RuleConstants.maxLengthRuleId =>
        context.l10n.fieldErrorMaxLength(ruleValue),
      RuleConstants.patternRuleId => context.l10n.fieldErrorInvalid,
      _ => context.l10n.error,
    };
  }
}
