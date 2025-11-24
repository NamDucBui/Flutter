import 'package:flutter/material.dart';

class QuestionSumary extends StatelessWidget {
  const QuestionSumary(this.summaryData, {super.key});

  final List<Map<String, Object>> summaryData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        child: Column(
          children: summaryData.map((data) {
            return Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20),
                  color: data['correct_answer'] == data['selected_answer']
                      ? Colors.green
                      : Colors.red,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    ((data['question_index'] as int) + 1).toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        data['question'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        data['correct_answer'] as String,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data['selected_answer'] as String,
                        style: TextStyle(
                          color:
                              data['selected_answer'] == data['correct_answer']
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
