import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum ChartInterval {
  s1,
  m1,
  m3,
  m5,
  m15,
  m30,
  h1,
  h2,
  h4,
  h6,
  h8,
  h12,
  d1,
  d3,
  w1,
  M1,
}

extension ChartIntervalExtension on ChartInterval {
  String get name {
   String s = describeEnum(this);
   String first = s[0];
   return "${s.replaceRange(0, 1, "")}$first";
  }

  double get interval {
    String s = describeEnum(this);
    return double.tryParse(s.replaceRange(0, 1, "")??"0")??1;
  }

  DateTimeIntervalType get intervalType {
    String s = describeEnum(this);
    String first = s[0];
    DateTimeIntervalType type =  DateTimeIntervalType.seconds;
    switch(first){
      case "s":
        type =  DateTimeIntervalType.seconds;
        break;
      case "m":
        type =  DateTimeIntervalType.minutes;
        break;
      case "h":
        type =  DateTimeIntervalType.hours;
        break;
      case "d":
        type =  DateTimeIntervalType.days;
        break;
      default:
        type =  DateTimeIntervalType.days;
        break;
    }
    return type;
  }
}
