import 'package:flutter/material.dart';
import '../models/tool_module.dart';


// Extending the BmiModule using 'extends' (Inheritance)
class BmiModule extends ToolModule {
  @override String get title => 'BMI Checker';
  @override IconData get icon => Icons.monitor_weight_outlined;
  
  // 4 Private Variables for the BMI Module + 2 Functions to control the display of the UI
  // assigned variables dynamically based on type needs
  double _height = 0;
  double _weight = 0;
  double? _bmiResult;
  String? _category;
  
  final TextEditingController _inputH = TextEditingController();
  final TextEditingController _inputW = TextEditingController();

  void compute() {
    _height = double.tryParse(_inputH.text) ?? 0;
    _weight = double.tryParse(_inputW.text) ?? 0;
    
    // This If-else checks for empty variables before doing calculations
    // Then categorizing the result gotten based on colos
    if (_height > 0 && _weight > 0) {
      final heightInMeters = _height / 100;
      _bmiResult = _weight / (heightInMeters * heightInMeters);
      
      if (_bmiResult! < 18.5) {
        _category = 'Underweight';
      } else if (_bmiResult! < 25) {
        _category = 'Normal';
      } else if (_bmiResult! < 30) {
        _category = 'Overweight';
      } else {
        _category = 'Obese';
      }
    }
  }

  Color resultingColor() {
    if (_category == 'Underweight') return Color(0xff3b82f6);
    if (_category == 'Normal') return Color(0xFF10B981);
    if (_category == 'Overweight') return Colors.orange;
    if (_category == 'Obese') return Colors.redAccent;
    return Colors.grey;
  }

  @override Widget buildBody(BuildContext context) { return _BmiModuleBody(module: this); }
}

class _BmiModuleBody extends StatefulWidget {
  final BmiModule module;
  const _BmiModuleBody({required this.module});
  @override State<_BmiModuleBody> createState() => _BmiModuleBodyState();
}

class _BmiModuleBodyState extends State<_BmiModuleBody> {
  @override Widget build(BuildContext context) {
    var mainColor = Theme.of(context).primaryColor;
    var lightThemeColor = mainColor.withValues(alpha: 0.15);

    return Container(
      color: const Color(0xFFF5F5F7),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // The start of the BMI Module
          // This If statement checks if a module is being used (in this case, it's the bmi), thus it would generate the appropriate screen
          if (widget.module._bmiResult != null) ...[ 
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, 
                  end: Alignment.bottomCenter, 
                  colors: [lightThemeColor, Colors.white]
                  ),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [ // Result Display/Header
                      const Text('YOUR BMI', 
                      style: TextStyle(fontSize: 12, 
                      fontWeight: FontWeight.w600, 
                      color: Colors.grey, 
                      letterSpacing: 1)),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.module.resultingColor().withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text(
                          widget.module._category!,
                          style: TextStyle(fontSize: 12, 
                          fontWeight: FontWeight.w600, 
                          color: widget.module.resultingColor()) ) 
                          ) 
                        ] 
                      ),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.module._bmiResult!.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 48, 
                      fontWeight: FontWeight.bold, 
                      color: Color(0xFF1F2937), 
                      height: 1.1)
                    )
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _displayMetrics('Height', '${widget.module._height.toStringAsFixed(0)} cm'),

                      const SizedBox(width: 12),

                      _displayMetrics('Weight', '${widget.module._weight.toStringAsFixed(0)} kg')
                    ]
                  ) 
                ] 
              ) 
            ),

            const SizedBox(height: 24)

          ],

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ // Inputting details Body
                const Text('Enter Details', 
                style: TextStyle(fontSize: 18, 
                fontWeight: FontWeight.bold, 
                color: Color(0xFF1F2937))),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _inputMetrics('Height (cm)', 'ex. 170', widget.module._inputH, mainColor),
                    const SizedBox(width: 12),
                    _inputMetrics('Weight (kg)', 'ex. 65', widget.module._inputW, mainColor)
                  ]
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (double.tryParse(widget.module._inputH.text) == null || double.tryParse(widget.module._inputW.text) == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Please enter valid details'), 
                                backgroundColor: const Color(0xFFDC2626),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                              ) );
                            return; }
                          setState(() => widget.module.compute());
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: mainColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                        ),
                        child: const Text('Calculate', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15))
                      )
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: OutlinedButton(
                        onPressed: () { setState(() {
                            widget.module._bmiResult = null; widget.module._category = null;
                            widget.module._inputH.clear(); widget.module._inputW.clear();
                          }); },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1F2937),
                          side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                        ),
                        child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15))
                      ) ) ] ) ] ) ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(  // Small section representing the bmi chart
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Category Guide', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                const SizedBox(height: 16),
                _displayCategory('Underweight', 'below 18.5', const Color(0xFF3B82F6)),
                const SizedBox(height: 12),
                _displayCategory('Normal', '18.5–24.9', const Color(0xFF10B981)),
                const SizedBox(height: 12),
                _displayCategory('Overweight', '25–29.9', Colors.orange),
                const SizedBox(height: 12),
                _displayCategory('Obese', '30 and above', Colors.redAccent)
              ]
              )
          )
        ]
      )
    );
  }

// Widgets builders for the display boxes/inputs
  Widget _displayMetrics(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromARGB(255, 162, 162, 162), width: 0.6)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),

            const SizedBox(height: 4),

            Text(value, style: const TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: Color(0xFF1F2937)))
          ]
        )
      )
    );
  }

  Widget _inputMetrics(String label, String hint, TextEditingController controller, Color focusColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,  
          style: TextStyle( fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[600] )
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
            )
          )
        ]
      )
    );
  }

  Widget _displayCategory(String label, String range, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)))
          ]
        ),
        Text(range, style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500))
      ]
    );
  }
}
