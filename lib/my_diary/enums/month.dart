enum Month { JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEPT, OCT, NOV, DEC }

extension MonthExtension on Month {
  get label {
    return this.toString().replaceAll('Month.', '');
  }

  get fullName {
    switch (this) {
      case Month.JAN:
        return 'January';
      case Month.FEB:
        return 'February';
      case Month.MAR:
        return 'March';
      case Month.APR:
        return 'April';
      case Month.MAY:
        return 'May';
      case Month.JUN:
        return 'June';
      case Month.JUL:
        return 'July';
      case Month.AUG:
        return 'August';
      case Month.SEPT:
        return 'September';
      case Month.OCT:
        return 'October';
      case Month.NOV:
        return 'November';
      case Month.DEC:
        return 'December';
      default:
        return 'Unknown';
    }
  }
}
