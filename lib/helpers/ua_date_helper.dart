import 'package:intl/intl.dart';

class UaDateHelper {
  static parseShortDate(String date) {
    final parsedMonth = DateFormat('MMMM').format(DateTime.parse(date));
    final parsedDay = DateFormat('d').format(DateTime.parse(date));
    final translatedMonth = UaDateHelper.translateMonth(
      month: parsedMonth,
      type: 2,
    );
    return '$parsedDay $translatedMonth';
  }

  static String translateMonth({required String month, int type = 1}) {
    switch (month) {
      case 'January':
        return type == 1 ? 'Січень' : 'Січня';
      case 'February':
        return type == 1 ? 'Лютий' : 'Лютого';
      case 'March':
        return type == 1 ? 'Березень' : 'Березня';
      case 'April':
        return type == 1 ? 'Квітень' : 'Квітня';
      case 'May':
        return type == 1 ? 'Травень' : 'Травня';
      case 'June':
        return type == 1 ? 'Червень' : 'Червня';
      case 'July':
        return type == 1 ? 'Липень' : 'Липня';
      case 'August':
        return type == 1 ? 'Серпень' : 'Серпеня';
      case 'September':
        return type == 1 ? 'Вересень' : 'Вересень';
      case 'October':
        return type == 1 ? 'Жовтень' : 'Жовтеня';
      case 'November':
        return type == 1 ? 'Листопад' : 'Листопада';
      case 'December':
        return type == 1 ? 'Грудень' : 'Грудня';
      default:
        return '';
    }
  }
}
