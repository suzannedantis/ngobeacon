//ngo_item.dart
import 'package:flutter/material.dart';

class NGOItem extends StatelessWidget {
  final String name;
  final String logo;
  final String? event_name;
  final VoidCallback onPressed;

  const NGOItem({
    Key? key,
    required this.name,
    required this.logo,
    this.event_name,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo image with fixed size
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(logo),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(height: 4),
                    if (event_name != null)
                      Text(
                        event_name!,
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF163F77),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        textStyle: TextStyle(fontSize: 14),
                      ),
                      child: Text("View Details"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
