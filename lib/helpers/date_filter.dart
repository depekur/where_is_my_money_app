enum DATE_FILTER_TYPE { DAY, WEEK, MONTH, YEAR, ALL_TIME }

class DateFilter {
  final String label;
  final DATE_FILTER_TYPE type;

  DateFilter(this.label, this.type);

  static DateFilter getTypeByLabel(String label) {
    final dynamic el =
        dateFilter.where((dynamic el) => el.label == label).toList();

    if (el.isNotEmpty) {
      return el[0];
    } else {
      return dateFilter[2];
    }
  }

  static List<DateTime> getWeekDatesRange(DateTime date) {
    DateTime startDate = date.subtract(Duration(days: date.weekday - 1));
    DateTime endDate =
        date.add(Duration(days: DateTime.daysPerWeek - date.weekday));

    return [startDate, endDate];
  }

  static List<DateTime> getDatesRange(DateTime date, DATE_FILTER_TYPE type) {
    List<DateTime> range;

    switch (type) {
      case DATE_FILTER_TYPE.DAY:
        range = [date, date];
        break;
      case DATE_FILTER_TYPE.WEEK:
        range = DateFilter.getWeekDatesRange(date);
        break;
      case DATE_FILTER_TYPE.MONTH:
        range = [
          DateTime(date.year, date.month, 1),
          DateTime(date.year, date.month + 1, 0),
        ];
        break;
      case DATE_FILTER_TYPE.YEAR:
        range = [
          DateTime(date.year, 1, 1),
          DateTime(date.year, 13, 0),
        ];
        break;
      case DATE_FILTER_TYPE.ALL_TIME:
        range = [date, date];
        break;
    }

    return [
      DateTime(range[0].year, range[0].month, range[0].day, 0, 0, 0),
      DateTime(range[1].year, range[1].month, range[1].day, 23, 59, 59)
    ];
  }
}

final List<DateFilter> dateFilter = [
  DateFilter('День', DATE_FILTER_TYPE.DAY),
  DateFilter('Тиждень', DATE_FILTER_TYPE.WEEK),
  DateFilter('Місяць', DATE_FILTER_TYPE.MONTH),
  DateFilter('Рік', DATE_FILTER_TYPE.YEAR),
  DateFilter('Увесь час', DATE_FILTER_TYPE.ALL_TIME),
];
