import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartPrinter extends StatefulWidget {
  LineChartPrinter({required this.bedTemp, required this.nozzleTemp});

  final List<double> bedTemp;
  final List<double> nozzleTemp;

  @override
  LineChartWidget createState() => LineChartWidget();
}

class LineChartWidget extends State<LineChartPrinter> {
  bool isShowingMainData = true;
  double maxX = 13;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Color(0xff2c274c),
              Color(0xff46426c),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 5),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(height: 10, width: 10, color: Color(0xffaa4cfc)),
                  Container(width: 10),
                  Text("Bed"),
                  Container(width: 10),
                  Text("|"),
                  Container(width: 10),
                  Container(height: 10, width: 10, color: Color(0xff4af699)),
                  Container(width: 10),
                  Text("Nozzle")
                ]),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'OnlinePrinterApp',
                  style: TextStyle(
                    color: Color(0xff827daa),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Temperature graph',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                      isShowingMainData ? sampleData1() : sampleData1(),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: maxX,
      maxY: 300,
      minY: 0,
      lineBarsData: linesBarData1(widget.bedTemp, widget.nozzleTemp),
    );
  }

  List<LineChartBarData> linesBarData1(
      List<double> bedTemp, List<double> nozzleTemp) {
    List<FlSpot> nozzleList = [];
    int index = 0;
    for (double temp in nozzleTemp) {
      index++;
      nozzleList.add(FlSpot(index.toDouble(), temp));
    }
    final LineChartBarData nozzle = LineChartBarData(
      spots: nozzleList,
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    List<FlSpot> bedList = [];
    index = 0;
    for (double temp in bedTemp) {
      index++;
      bedList.add(FlSpot(index.toDouble(), temp));
    }
    final LineChartBarData bed = LineChartBarData(
      spots: bedList,
      isCurved: true,
      colors: [
        const Color(0xffaa4cfc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    return [
      nozzle,
      bed,
    ];
  }
}
