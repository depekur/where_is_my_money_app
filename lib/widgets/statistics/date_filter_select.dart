import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helpers/date_filter.dart';
import '../../helpers/ua_date_helper.dart';

class DateFilterSelect extends StatefulWidget {
  const DateFilterSelect(
      {Key? key, required this.filterType, required this.onChange})
      : super(key: key);

  final DATE_FILTER_TYPE filterType;
  final Function onChange;

  @override
  State<DateFilterSelect> createState() => DateFilterSelectState();
}

class DateFilterSelectState extends State<DateFilterSelect> {
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentDate = DateTime.now();
  }

  resetDate() {
    setState(() {
      _currentDate = DateTime.now();
    });
  }

  String get viewLabel {
    switch (widget.filterType) {
      case DATE_FILTER_TYPE.DAY:
        return _dayViewLabel();
      case DATE_FILTER_TYPE.WEEK:
        return _weekViewLabel();
      case DATE_FILTER_TYPE.MONTH:
        return _monthViewLabel();
      case DATE_FILTER_TYPE.YEAR:
        return _yearViewLabel();
      case DATE_FILTER_TYPE.ALL_TIME:
        return _allTimeViewLabel();
    }
  }

  String _dayViewLabel() {
    final DateTime now = DateTime.now();

    if (now.year == _currentDate.year &&
        now.month == _currentDate.month &&
        now.day == _currentDate.day) {
      return 'Сьогодні';
    } else if (now.year == _currentDate.year &&
        now.month == _currentDate.month &&
        now.day == (_currentDate.day + 1)) {
      return 'Вчора';
    } else {
      return DateFormat('dd.MM')
          .format(DateTime.parse(_currentDate.toString()));
    }
  }

  String _weekViewLabel() {
    final List<DateTime> datesRange =
        DateFilter.getWeekDatesRange(_currentDate);

    final String weekStart = DateFormat('dd.MM').format(datesRange[0]);
    final String weekEnd = DateFormat('dd.MM').format(datesRange[1]);

    return '$weekStart - $weekEnd';
  }

  String _monthViewLabel() {
    final String month = DateFormat('MMMM').format(_currentDate);
    return UaDateHelper.translateMonth(month: month);
  }

  String _yearViewLabel() {
    return _currentDate.year.toString();
  }

  String _allTimeViewLabel() {
    return 'Увесь час';
  }

  void _prev() {
    switch (widget.filterType) {
      case DATE_FILTER_TYPE.DAY:
        setState(() {
          _currentDate = DateTime(
            _currentDate.year,
            _currentDate.month,
            _currentDate.day - 1,
          );
        });
        break;
      case DATE_FILTER_TYPE.WEEK:
        setState(() {
          _currentDate =
              _currentDate.subtract(Duration(days: _currentDate.weekday));
        });
        break;
      case DATE_FILTER_TYPE.MONTH:
        setState(() {
          _currentDate = DateTime(
            _currentDate.year,
            _currentDate.month - 1,
            _currentDate.day,
          );
        });
        break;
      case DATE_FILTER_TYPE.YEAR:
        setState(() {
          _currentDate = DateTime(
            _currentDate.year - 1,
            _currentDate.month,
            _currentDate.day,
          );
        });
        break;
      case DATE_FILTER_TYPE.ALL_TIME:
        break;
    }

    widget.onChange(DateFilter.getDatesRange(_currentDate, widget.filterType));
  }

  void _next() {
    switch (widget.filterType) {
      case DATE_FILTER_TYPE.DAY:
        setState(() {
          _currentDate = DateTime(
            _currentDate.year,
            _currentDate.month,
            _currentDate.day + 1,
          );
        });
        break;
      case DATE_FILTER_TYPE.WEEK:
        setState(() {
          _currentDate = _currentDate.add(Duration(days: _currentDate.weekday));
        });
        break;
      case DATE_FILTER_TYPE.MONTH:
        setState(() {
          _currentDate = DateTime(
            _currentDate.year,
            _currentDate.month + 1,
            _currentDate.day,
          );
        });
        break;
      case DATE_FILTER_TYPE.YEAR:
        setState(() {
          _currentDate = DateTime(
            _currentDate.year + 1,
            _currentDate.month,
            _currentDate.day,
          );
        });
        break;
      case DATE_FILTER_TYPE.ALL_TIME:
        break;
    }

    widget.onChange(DateFilter.getDatesRange(_currentDate, widget.filterType));
  }

  bool _isNextAvailable() {
    final now = DateTime.now();

    switch (widget.filterType) {
      case DATE_FILTER_TYPE.DAY:
        return now.day != _currentDate.day;
      case DATE_FILTER_TYPE.WEEK:
        final List<DateTime> filterWeek =
            DateFilter.getWeekDatesRange(_currentDate);
        final List<DateTime> nowWeek = DateFilter.getWeekDatesRange(now);
        return filterWeek[0].day != nowWeek[0].day &&
            filterWeek[1].day != nowWeek[1].day;
      case DATE_FILTER_TYPE.MONTH:
        return now.month != _currentDate.month;
      case DATE_FILTER_TYPE.YEAR:
        return now.year != _currentDate.year;
      case DATE_FILTER_TYPE.ALL_TIME:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.filterType);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.filterType != DATE_FILTER_TYPE.ALL_TIME)
          IconButton(
            onPressed: _prev,
            icon: const Icon(Icons.arrow_back_ios),
          ),
        const SizedBox(width: 20),
        Text(viewLabel),
        const SizedBox(width: 20),
        if (widget.filterType != DATE_FILTER_TYPE.ALL_TIME)
          IconButton(
            onPressed: _isNextAvailable() ? _next : null,
            icon: const Icon(Icons.arrow_forward_ios),
          ),
      ],
    );
  }
}
