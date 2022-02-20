extension IsAtSameDate on DateTime {
  bool isAtSameDate(DateTime other) =>
      other.year == year && other.month == month && other.day == day;
}
