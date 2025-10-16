import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;
  final String imagePath;

  const TaskCard({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
    this.imagePath = 'assets/img/ic_card.png',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
      decoration: BoxDecoration(
        color: const Color(0xFF5A7C3E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              const Text(
                'Hari ini',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                '$completedTasks/$totalTasks Tasks',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
          SizedBox(
            height: 120,
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
