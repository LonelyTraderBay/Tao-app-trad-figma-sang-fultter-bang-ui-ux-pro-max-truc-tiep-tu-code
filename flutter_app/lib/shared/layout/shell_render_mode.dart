enum ShellRenderMode { native, visualQa }

const bool _visualQaFrameFromEnvironment = bool.fromEnvironment(
  'VISUAL_QA_FRAME',
);

ShellRenderMode defaultShellRenderMode() {
  return _visualQaFrameFromEnvironment
      ? ShellRenderMode.visualQa
      : ShellRenderMode.native;
}

extension ShellRenderModeState on ShellRenderMode {
  bool get usesVisualQaFrame => this == ShellRenderMode.visualQa;
}
