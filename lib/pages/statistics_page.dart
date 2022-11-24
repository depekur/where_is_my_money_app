import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:where_is_my_money_app/providers/app_provider.dart';

import '../helpers/date_filter.dart';
import '../widgets/statistics/date_filter_select.dart';
import '../widgets/statistics/expense_category_Card.dart';
import '../widgets/statistics/expenses_by_category_pie_chart.dart';

class StatisticsPage extends StatefulWidget {
  static const route = '/statistics';

  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  GlobalKey<DateFilterSelectState> _filterKey = GlobalKey();
  DateFilter _filterType = dateFilter[4]; // all time
  List<DateTime> _dateRange = DateFilter.getDatesRange(
    DateTime.now(),
    dateFilter[4].type,
  );

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.fetchAndSetStatistics(
      filterType: _filterType.type.toString().split('.').last,
      startDate: _dateRange[0].toIso8601String(),
      endDate: _dateRange[1].toIso8601String(),
    );
  }

  Widget _dateSelectorDropdownMenu() {
    return DropdownButton<String>(
      value: _filterType.label,
      elevation: 10,
      dropdownColor: Theme.of(context).primaryColor,
      style: const TextStyle(color: Colors.white),
      underline: Container(
        height: 1,
        color: Colors.white70,
      ),
      onChanged: (String? value) {
        if (value != null && value.isNotEmpty) {
          setState(() {
            _filterType = DateFilter.getTypeByLabel(value);
            _dateRange = DateFilter.getDatesRange(
              DateTime.now(),
              _filterType.type,
            );
            _filterKey.currentState?.resetDate();
          });

          getData();
        }
      },
      items: dateFilter.map<DropdownMenuItem<String>>((DateFilter value) {
        return DropdownMenuItem(
          value: value.label,
          child: Text(value.label),
        );
      }).toList(),
    );
  }

  Widget _incomeAndOutcome(statistic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(
              Icons.arrow_circle_up_outlined,
              color: Colors.green.shade300,
            ),
            const SizedBox(width: 5),
            Text('${statistic['totalEuroIncomeAmount']} EUR'),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.arrow_circle_down_outlined,
              color: Colors.deepOrange.shade300,
            ),
            const SizedBox(width: 5),
            Text('${statistic['totalEuroExpenseAmount']} EUR'),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final statistic = Provider.of<AppProvider>(context).statistic;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _dateSelectorDropdownMenu(),
          ),
        ],
      ),
      body: statistic != null
          ? Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: ListView(
                children: [
                  if (_filterType.type != DATE_FILTER_TYPE.ALL_TIME)
                    DateFilterSelect(
                      key: _filterKey,
                      filterType: _filterType.type,
                      onChange: (dateRange) {
                        if (dateRange != null) {
                          setState(() {
                            _dateRange = dateRange;
                          });
                          getData();
                        }
                      },
                    ),
                  if (statistic['byCategory'].isNotEmpty)
                    ExpensesByCategoryPieChart(statistic: statistic),
                  if (statistic['byCategory'].isNotEmpty)
                    const SizedBox(height: 30),
                  if (statistic['byCategory'].isNotEmpty)
                    _incomeAndOutcome(statistic),
                  if (statistic['byCategory'].isNotEmpty)
                    const SizedBox(height: 20),
                  if (statistic['byCategory'].isNotEmpty)
                    ...statistic['byCategory'].map((data) {
                      return ExpenseCategoryCard(data: data);
                    }).toList(),
                  const SizedBox(height: 30),
                  if (statistic['byCategory'].isEmpty)
                    const Center(
                        child: Text(
                      'Немає данних за цей період',
                      style: TextStyle(fontSize: 16),
                    ))
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  void _openDatePicker() {
    showDialog(
      barrierLabel: 'barrierLabel',
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Вибери період'),
          // content: const Text('бла бла бла'),
          content: Container(
            width: 300,
            height: 300,
            child: SfDateRangePicker(
              onSelectionChanged: (args) {
                print(args);
              },
              selectionMode: DateRangePickerSelectionMode.extendableRange,
              initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(const Duration(days: 4)),
                  DateTime.now().add(const Duration(days: 3))),
            ),
          ),
          actions: [
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Назад')),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Показати період')),
          ],
        );
      },
    );
  }
}
