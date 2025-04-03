import 'package:flutter/material.dart';

class NGOItem extends StatelessWidget {
  final String name;
  final String logo;
  final count = null;
  NGOItem({required this.name, required this.logo, count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              SizedBox(width: 20), // Added padding to shift content right
              Image(height: 80, width: 80, image: AssetImage(logo)),
              SizedBox(width: 20),
              Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                count,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
