import 'package:crypto_wallet/model/user_response_model.dart';

bool isPositive({String? s}) {
  double value = double.tryParse(s ?? "0") ?? 0;
  return value > 0;
}

bool isPriceGraterThen({String? s1, String? s2}) {
  double value1 = double.tryParse(s1 ?? "0") ?? 0;
  double value2 = double.tryParse(s2 ?? "0") ?? 0;
  return value1 > value2;
}

String stringPricePrefix({String? s, int decimal = 2}) {
  double value = double.tryParse(s ?? "0") ?? 0;
  return value.toStringAsFixed(decimal);
}

String userDetailsFirstLetter({required User user}) {
  String s = "";
  if (user.firstname != null && (user.firstname ?? "").isNotEmpty) {
    s = (user.firstname ?? "")[0].toUpperCase();
  }
  if (s.isEmpty &&
      (user.firstname != null && (user.firstname ?? "").isNotEmpty)) {
    s = (user.lastname ?? "")[0].toUpperCase();
  }

  return s;
}
