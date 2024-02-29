import 'dart:async';

import 'package:crypto_wallet/controller/coin_detail_controller.dart';
import 'package:crypto_wallet/enum/chart_interval.dart';
import 'package:crypto_wallet/enum/error_type.dart';
import 'package:crypto_wallet/model/chart_data_response_model.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWidget extends StatefulWidget {
  String coinSymbol;

  ChartWidget({required this.coinSymbol});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  TrackballBehavior? _trackballBehavior;
  final CoinDetailController _coinDetailController = Get.find();
  Timer? _timer;
  List<ChartInterval> chartIntervalList = [];

  @override
  void initState() {
    super.initState();
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
    tooltipDisplayMode: TrackballDisplayMode.nearestPoint
    );
    // chartIntervalList.add(ChartInterval.s1);
    chartIntervalList.add(ChartInterval.m1);
    // chartIntervalList.add(ChartInterval.m3);
    chartIntervalList.add(ChartInterval.m5);
    chartIntervalList.add(ChartInterval.m15);
    chartIntervalList.add(ChartInterval.m30);
    chartIntervalList.add(ChartInterval.h1);
    // chartIntervalList.add(ChartInterval.h2);
    chartIntervalList.add(ChartInterval.h4);
    chartIntervalList.add(ChartInterval.h6);
    chartIntervalList.add(ChartInterval.h8);
    chartIntervalList.add(ChartInterval.h12);
    chartIntervalList.add(ChartInterval.d1);
    chartIntervalList.add(ChartInterval.w1);
    chartIntervalList.add(ChartInterval.M1);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetX<CoinDetailController>(builder: (cont) {
      if (cont.error.value.errorType == ErrorType.internet) {
        return Container();
      }
      // if (cont.candleSeriesChartDataList.length < 5) {
      //   return const Center(
      //     child: CircularProgressIndicator(),
      //   );
      // }
      return Column(
        children: [
          Wrap(
            children: chartIntervalList.map((e) {
              return InkWell(
                onTap: () {
                  cont.selectedChartInterval.value = e;
                  cont.candleSeriesChartDataList.clear();
                  cont.coinCandlestickDisconnect();
                  setState(() {});
                  cont.getChartData(symbol: widget.coinSymbol).then((value) {
                    cont.coinCandlestickConnect(symbol: widget.coinSymbol);
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                  margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: cont.selectedChartInterval.value == e
                        ? AppColors.primaryColor.withOpacity(0.7)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                      color: cont.selectedChartInterval.value == e
                          ? AppColors.primaryColor.withOpacity(0.7)
                          : AppColors.primaryColor,
                      width: 1.w,
                    ),
                  ),
                  child: Text(
                    e.name,
                    style: TextStyle(
                      color: cont.selectedChartInterval.value == e
                          ? Colors.white
                          : AppColors.primaryColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Expanded(
            child: cont.candleSeriesChartDataList.length < 20
                ? const Center(child: CircularProgressIndicator())
                : SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    title: ChartTitle(text: ""),
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      enableDoubleTapZooming: true,
                      enablePanning: true,
                      enableSelectionZooming: true,
                    ),
                    // selectionType: SelectionType.series,
                    primaryXAxis: DateTimeAxis(
                      dateFormat: DateFormat("dd/MM hh:mm"),
                      labelStyle: TextStyle(fontSize: 8.sp),
                      // interval: cont.selectedChartInterval.value.interval,
                      // intervalType: cont.selectedChartInterval.value.intervalType,
                      minimum: cont.candleSeriesChartDataList.first.openTime,
                      maximum: cont.candleSeriesChartDataList.last.openTime,
                      majorGridLines: const MajorGridLines(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                      labelFormat: r'{value}',
                      axisLine: const AxisLine(
                        width: 0,
                      ),
                    ),
                    series: _getCandleSeries(cont: cont),
                    trackballBehavior: _trackballBehavior,
                  ),
          ),
        ],
      );
    });
  }

  List<CandleSeries<ChartDataResponseModel, DateTime>> _getCandleSeries(
      {required CoinDetailController cont}) {
    return <CandleSeries<ChartDataResponseModel, DateTime>>[
      CandleSeries<ChartDataResponseModel, DateTime>(
        enableSolidCandles: true,
        dataSource: cont.candleSeriesChartDataList,
        name: 'AAPL',
        showIndicationForSameValues: true,
        xValueMapper: (ChartDataResponseModel sales, _) => sales.openTime,

        /// High, low, open and close values used to render the candle series.
        lowValueMapper: (ChartDataResponseModel sales, _) => sales.lowPrice,
        highValueMapper: (ChartDataResponseModel sales, _) => sales.highPrice,
        openValueMapper: (ChartDataResponseModel sales, _) => sales.openPrice,
        closeValueMapper: (ChartDataResponseModel sales, _) => sales.closePrice,
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
