import 'package:flutter/material.dart';
import 'package:flutter_lab/widgets/input_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  String text = '';
  Color containerColor = Colors.white;

  void _handleSubmitted(String newText) {
    setState(() {
      text = newText;
      if (newText.length == 6) {
        containerColor = Color(int.parse('0xFF$newText'));
      } else {
        containerColor = Colors.white;
      }
    });
    print('Submitted text: $newText');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              InputField(controller: controller, onSubmitted: _handleSubmitted),
              Container(height: 50, width: 100, color: containerColor),
            ],
          ),
        ),
      ),
    );
  }
}
