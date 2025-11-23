import 'package:flutter/material.dart';

class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});
  @override
  State<DiceRoller> createState() {
    return _DiceRollerState();
  }
}

class _DiceRollerState extends State<DiceRoller> {
  final TextEditingController _x1Controller = TextEditingController();
  final TextEditingController _v1Controller = TextEditingController();
  final TextEditingController _x2Controller = TextEditingController();
  final TextEditingController _v2Controller = TextEditingController();

  String? _result;

  String kangaroo(int x1, int v1, int x2, int v2) {
    if (x1 == x2) {
      return 'YES';
    }
    if (v1 == v2) {
      return 'NO';
    }
    if (v1 > v2) {
      if (x1 >= x2) {
        return 'NO';
      }
      if ((x2 - x1) % (v1 - v2) == 0) {
        return 'YES';
      } else {
        return 'NO';
      }
    } else {
      if (x2 >= x1) {
        return 'NO';
      }
      if ((x1 - x2) % (v2 - v1) == 0) {
        return 'YES';
      } else {
        return 'NO';
      }
    }
  }

  void solveKangaroo() {
    try {
      final x1 = int.parse(_x1Controller.text);
      final v1 = int.parse(_v1Controller.text);
      final x2 = int.parse(_x2Controller.text);
      final v2 = int.parse(_v2Controller.text);

      final result = kangaroo(x1, v1, x2, v2);

      setState(() {
        _result = result;
      });
    } catch (e) {
      setState(() {
        _result = 'Lỗi: Vui lòng nhập số nguyên hợp lệ';
      });
    }
  }

  @override
  void dispose() {
    _x1Controller.dispose();
    _v1Controller.dispose();
    _x2Controller.dispose();
    _v2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _x1Controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'x1 (Vị trí ban đầu kangaroo 1)',
              hintText: 'Ví dụ: 0',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _v1Controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'v1 (Vận tốc nhảy kangaroo 1)',
              hintText: 'Ví dụ: 3',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _x2Controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'x2 (Vị trí ban đầu kangaroo 2)',
              hintText: 'Ví dụ: 4',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _v2Controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'v2 (Vận tốc nhảy kangaroo 2)',
              hintText: 'Ví dụ: 2',
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: solveKangaroo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text('Run'),
          ),
          if (_result != null) ...[
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _result == 'YES'
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _result == 'YES' ? Colors.green : Colors.red,
                  width: 2,
                ),
              ),
              child: Text(
                'Kết quả: $_result',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _result == 'YES'
                      ? Colors.green.shade900
                      : Colors.red.shade900,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
