import 'dart:developer';

import 'package:flutter/foundation.dart';

void logger(dynamic msg){
  if(kDebugMode){
    log("$msg");
  }
}

void logPrint(dynamic msg){
  if(kDebugMode){
    log("$msg");
  }
}