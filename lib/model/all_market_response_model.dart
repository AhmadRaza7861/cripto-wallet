import 'dart:convert';

List<AllMarketResponseModel> allMarketResponseModelFromJson(String str) => List<AllMarketResponseModel>.from(json.decode(str).map((x) => AllMarketResponseModel.fromJson(x)));

String allMarketResponseModelToJson(List<AllMarketResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllMarketResponseModel {
  AllMarketResponseModel({
    this.allMarketResponseModelE,
    this.e,
    this.s,
    this.allMarketResponseModelP,
    this.p,
    this.w,
    this.x,
    this.allMarketResponseModelC,
    this.q,
    this.allMarketResponseModelB,
    this.b,
    this.allMarketResponseModelA,
    this.a,
    this.allMarketResponseModelO,
    this.h,
    this.allMarketResponseModelL,
    this.v,
    this.allMarketResponseModelQ,
    this.o,
    this.c,
    this.f,
    this.l,
    this.n,
  });

  String? allMarketResponseModelE;
  int? e;
  String? s;
  String? allMarketResponseModelP;
  String? p;
  String? w;
  String? x;
  String? allMarketResponseModelC;
  String? q;
  String? allMarketResponseModelB;
  String? b;
  String? allMarketResponseModelA;
  String? a;
  String? allMarketResponseModelO;
  String? h;
  String? allMarketResponseModelL;
  String? v;
  String? allMarketResponseModelQ;
  int? o;
  int? c;
  int? f;
  int? l;
  int? n;

  factory AllMarketResponseModel.fromJson(Map<String, dynamic> json) => AllMarketResponseModel(
    allMarketResponseModelE: json["e"],
    e: json["E"],
    s: json["s"],
    allMarketResponseModelP: json["p"],
    p: json["P"],
    w: json["w"],
    x: json["x"],
    allMarketResponseModelC: json["c"],
    q: json["Q"],
    allMarketResponseModelB: json["b"],
    b: json["B"],
    allMarketResponseModelA: json["a"],
    a: json["A"],
    allMarketResponseModelO: json["o"],
    h: json["h"],
    allMarketResponseModelL: json["l"],
    v: json["v"],
    allMarketResponseModelQ: json["q"],
    o: json["O"],
    c: json["C"],
    f: json["F"],
    l: json["L"],
    n: json["n"],
  );

  Map<String, dynamic> toJson() => {
    "e": allMarketResponseModelE,
    "E": e,
    "s": s,
    "p": allMarketResponseModelP,
    "P": p,
    "w": w,
    "x": x,
    "c": allMarketResponseModelC,
    "Q": q,
    "b": allMarketResponseModelB,
    "B": b,
    "a": allMarketResponseModelA,
    "A": a,
    "o": allMarketResponseModelO,
    "h": h,
    "l": allMarketResponseModelL,
    "v": v,
    "q": allMarketResponseModelQ,
    "O": o,
    "C": c,
    "F": f,
    "L": l,
    "n": n,
  };
}
