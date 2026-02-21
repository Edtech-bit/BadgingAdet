import 'package:flutter/material.dart';
import '../models/tool_module.dart';

class BmiModule extends ToolModule {
  @override
  String get title => 'BMI Checker';
  @override
  IconData get icon => Icons.monitor_weight_outlined;


  double _height = 0;
  double _weight = 0;
  double? _bmi;
  String? _category;
  Color? _bmiColor;

  double get height => _height;
  double get weight => _weight;
  double? get bmi => _bmi;
  String? get category => _category;
  Color? get bmiColor => _bmiColor;

  void calculateBmi(double height, double weight) {
    _height = height;
    _weight = weight;

    if (_height > 0 && _weight > 0) {
      _bmi = _weight / ((_height / 100) * (_height / 100));

      if (_bmi! < 18.5) {
        _category = 'Underweight';
        _bmiColor = Colors.blue.shade400;
      } else if (_bmi! < 25) {
        _category = 'Normal';
        _bmiColor = Colors.green.shade300;
      } else if (_bmi! < 30) {
        _category = 'Overweight';
        _bmiColor = Colors.orange;
      } else {
        _category = 'Obese';
        _bmiColor = Colors.redAccent;
      }
    }
  }

  void reset() {
    _height = 0;
    _weight = 0;
    _bmi = null;
    _category = null;
    _bmiColor = null;
  }

  @override
  Widget buildBody(BuildContext context) => _BmiModuleBody(module: this);
}

class _BmiModuleBody extends StatefulWidget {
  final BmiModule module;
  const _BmiModuleBody({required this.module});

  @override
  State<_BmiModuleBody> createState() => _BmiModuleBodyState();
}

class _BmiModuleBodyState extends State<_BmiModuleBody> {
  final TextEditingController _inputH = TextEditingController();
  final TextEditingController _inputW = TextEditingController();

  @override
  void dispose() {
    _inputH.dispose();
    _inputW.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _calculateBmi() {
    final height = double.tryParse(_inputH.text);
    final weight = double.tryParse(_inputW.text);

    if (height == null || weight == null) {
      return _showError('Please enter valid details');
    }

    setState(() {
      widget.module.calculateBmi(height, weight);
    });
  }

  void resetHeightWeight() {
    setState(() {
      widget.module.reset();
      _inputH.clear();
      _inputW.clear();
    });
  }



  Widget _displayHW(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[400]!, width: 0.6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputHW(String label, String hint, TextEditingController controller) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorBMI(String label, String range, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[900],
              ),
            ),
          ],
        ),
        Text(
          range,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (widget.module.bmi != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor.withValues(alpha: 0.15),
                    Colors.white
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'YOUR BMI',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          letterSpacing: 1,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.module.bmiColor!.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.module.category!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: widget.module.bmiColor!,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.module.bmi!.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900],
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _displayHW('Height', '${widget.module.height.toStringAsFixed(0)} cm'),
                      const SizedBox(width: 12),
                      _displayHW('Weight', '${widget.module.weight.toStringAsFixed(0)} kg'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _inputHW('Height (cm)', 'ex. 170', _inputH),
                    const SizedBox(width: 12),
                    _inputHW('Weight (kg)', 'ex. 65', _inputW),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: _calculateBmi,
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Calculate',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: resetHeightWeight,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blueGrey[900],
                          side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category Guide',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                ),
                const SizedBox(height: 16),
                _colorBMI('Underweight', 'below 18.5', Colors.blue.shade400),
                const SizedBox(height: 12),
                _colorBMI('Normal', '18.5–24.9', Colors.green.shade300),
                const SizedBox(height: 12),
                _colorBMI('Overweight', '25–29.9', Colors.orange),
                const SizedBox(height: 12),
                _colorBMI('Obese', '30 and above', Colors.redAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
