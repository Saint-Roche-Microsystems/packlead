enum LogLevel {
  debug(500, '[DEBUG]'),
  info(800, '[INFO]'),
  warning(900, '[WARNING]'),
  error(1000, '[ERROR]');

  const LogLevel(this.severity, this.label);

  final int severity;
  final String label;
}
