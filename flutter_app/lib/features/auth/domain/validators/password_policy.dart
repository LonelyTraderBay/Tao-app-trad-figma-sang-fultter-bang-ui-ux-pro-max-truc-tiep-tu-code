/// Canonical password strength policy shared by the registration and
/// password-reset flows.
///
/// Registration and password-reset used to define their own, slightly
/// different password rules (reset only checked for "any letter"; register
/// required upper *and* lower case). That meant a password accepted on one
/// screen could be rejected on the other. This file is the single source of
/// truth for what "letter case", "digit" and "special character" mean for a
/// VitTrade password, so both screens agree.
library;

/// A single password strength requirement: a short label plus the
/// predicate used to evaluate a candidate password against it.
final class PasswordRule {
  const PasswordRule({required this.label, required this.test});

  final String label;
  final bool Function(String value) test;
}

bool passwordHasMinLength(String value) => value.length >= 8;

bool passwordHasUpperAndLowerCase(String value) =>
    RegExp('[A-Z]').hasMatch(value) && RegExp('[a-z]').hasMatch(value);

bool passwordHasDigit(String value) => RegExp(r'\d').hasMatch(value);

bool passwordHasSpecialCharacter(String value) =>
    RegExp(r'[!@#$%^&*]').hasMatch(value);

const _minLengthRule = PasswordRule(
  label: 'Tối thiểu 8 ký tự',
  test: passwordHasMinLength,
);
const _upperLowerRule = PasswordRule(
  label: 'Chữ hoa & thường',
  test: passwordHasUpperAndLowerCase,
);
const _digitRule = PasswordRule(label: 'Có số', test: passwordHasDigit);
const _specialCharRule = PasswordRule(
  label: 'Ký tự đặc biệt',
  test: passwordHasSpecialCharacter,
);

/// The full canonical rule set, shown to the user as a checklist
/// (password reset) or a strength meter (registration). All four rules are
/// evaluated identically on both screens.
const passwordPolicyRules = <PasswordRule>[
  _minLengthRule,
  _upperLowerRule,
  _digitRule,
  _specialCharRule,
];

/// The subset of [passwordPolicyRules] required to submit a password on
/// either the registration or password-reset screen.
///
/// The special-character rule is still surfaced to the user as a strength
/// hint (via [passwordPolicyRules]), but is intentionally not a hard
/// requirement: making it mandatory on the reset screen would add extra
/// friction for a user who is already locked out of their account, so it
/// stays optional on both screens to keep the two flows consistent with
/// each other.
const requiredPasswordRules = <PasswordRule>[
  _minLengthRule,
  _upperLowerRule,
  _digitRule,
];

/// Whether [value] satisfies every rule in [requiredPasswordRules].
bool passwordMeetsPolicy(String value) =>
    requiredPasswordRules.every((rule) => rule.test(value));

/// Number of [passwordPolicyRules] that [value] satisfies (0-4), used to
/// drive the registration strength meter.
int passwordStrengthScore(String value) =>
    passwordPolicyRules.where((rule) => rule.test(value)).length;
