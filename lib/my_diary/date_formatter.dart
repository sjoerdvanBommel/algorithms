String getDate() {
  DateTime today = DateTime.now();
  String month;
  switch (today.month) {
    case 1:
      month = 'JAN';
      break;
    case 2:
      month = 'FEB';
      break;
    case 3:
      month = 'MAR';
      break;
    case 4:
      month = 'APR';
      break;
    case 5:
      month = 'MAY';
      break;
    case 6:
      month = 'JUN';
      break;
    case 7:
      month = 'JUL';
      break;
    case 8:
      month = 'AUG';
      break;
    case 9:
      month = 'SEPT';
      break;
    case 10:
      month = 'OCT';
      break;
    case 11:
      month = 'NOV';
      break;
    case 12:
      month = 'DEC';
      break;
  }
  return '$month, ${today.day} / ${today.year}';
}

String getDay() {
  switch (DateTime.now().weekday) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
  }
  return '';
}
