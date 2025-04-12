import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'Applications/ngo_applications_page.dart';
import 'Upload_Page/ngo_upload_page.dart';
import 'components/bottom_nav_bar.dart';
import 'components/top_nav_bar.dart';

class NGOHomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<NGOHomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF002B5B),
      appBar: TopNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Statistic Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statCard("Applications", "3,245", "+11.01%", Colors.blueGrey),
                _statCard("Visitors", "1,220", "+4.22%", Colors.lightBlueAccent),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statCard("New Users", "256", "+15.03%", Colors.lightBlueAccent),
                _statCard("Active NGOs", "89", "+6.08%", Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 24),

            // Section: Applications Chart
            Text(
              "Applications per Event",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              padding: const EdgeInsets.all(12),
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 3, color: Colors.blue)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 5, color: Colors.lightBlue)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 2, color: Colors.blueGrey)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 7, color: Colors.black)]),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0: return Text("Blood", style: TextStyle(fontSize: 12));
                            case 1: return Text("Clothes", style: TextStyle(fontSize: 12));
                            case 2: return Text("Intern", style: TextStyle(fontSize: 12));
                            case 3: return Text("Trees", style: TextStyle(fontSize: 12));
                            default: return Text("");
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Section: Info Cards
            _infoCard("👥 NGOWiki Visitors", "30 total visitors so far."),
            _infoCard("⏱ Avg. Read Time", "2 mins average reading time."),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 0),
    );
  }

  Widget _statCard(String title, String value, String growth, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.white70, fontSize: 14)),
            SizedBox(height: 8),
            Text(value, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(growth, style: TextStyle(color: Colors.white60, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String heading, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}
