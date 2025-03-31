import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'side_menu.dart';
import 'applications_page.dart';
import 'upload_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Index for Home Page

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Prevent reloading the same page

    switch (index) {
      case 0:
        break; // Already on HomePage
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ApplicationsPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UploadPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF002B5B),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("NGOBeacon", style: TextStyle(color: Color(0xFF002B5B))),
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset('assets/Images/logo.png'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Color(0xFF002B5B)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SideMenuPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Number of Applications for Upcoming Events",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: 3, // Updated from `y` to `toY`
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(toY: 5, color: Colors.lightBlue),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(toY: 2, color: Colors.blueGrey),
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [BarChartRodData(toY: 7, color: Colors.black)],
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text("Blood Donation");
                            case 1:
                              return Text("Clothes Drive");
                            case 2:
                              return Text("Internship");
                            case 3:
                              return Text("Tree Plantation");
                            default:
                              return Text("");
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildInfoCard("Number of visitors on NGOWiki Page till date: 30"),
            _buildInfoCard("Average read time of NGOWiki Page: 2 minutes"),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                size: 30,
                color: _selectedIndex == 0 ? Colors.blue : Color(0xFF002B5B),
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.article,
                size: 30,
                color: _selectedIndex == 1 ? Colors.blue : Color(0xFF002B5B),
              ),
              onPressed: () => _onItemTapped(1),
            ),
            IconButton(
              icon: Icon(
                Icons.upload_file,
                size: 30,
                color: _selectedIndex == 2 ? Colors.blue : Color(0xFF002B5B),
              ),
              onPressed: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
