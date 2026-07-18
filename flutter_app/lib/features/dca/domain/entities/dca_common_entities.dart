/// Recurring buy frequency for a DCA plan.
enum DcaFrequency { daily, weekly, monthly }

/// Lifecycle status of a DCA plan.
enum DcaPlanStatus { active, paused, error }

/// UI state a DCA screen snapshot supports rendering.
enum DcaScreenState { loading, empty, error, offline, submitting, success }

/// Leading icon choice for a DCA schedule option row.
enum DcaScheduleOptionIcon { clock, trend, bolt, chart }

/// Accent color choice for a DCA rebalance-related UI element.
enum DcaRebalanceAccent { primary, accent, success, warning }
