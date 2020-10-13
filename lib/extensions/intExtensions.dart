extension InRange on int {
  /// Checks wheter the provided integer lays within mathematical interval [start, ... , end]
  /// (includes start & end values)
  bool inRange(int start, int end) {
    return this >= start && this <= end;
  }
}
