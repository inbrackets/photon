enum logKeys {
  General
}

class Logger {
  static final Logger _logger = new Logger._internal();

  factory Logger() {
    return _logger;
  }

  Logger._internal();

  bool display = false;

  void log(logKeys key, String output) {
    if (display) {
      print("$key: $output");
    }
  }
}