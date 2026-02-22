import 'package:flutter/material.dart';
import '../models/tool_module.dart';

class GradeCalculatorModule extends ToolModule {
  @override
  String get title => 'Grade Calculator';
  @override
  IconData get icon => Icons.school_outlined;

  final List<Subject> _subjects = [];
  List<Subject> get subjects => List.unmodifiable(_subjects);

  double? _gwa;
  double? get gwa => _gwa;

  final double _targetGrade = 1.75;       //Minimum grade target to be included in the Dean's List in HAU
  double get targetGrade => _targetGrade;

  //Add subject function
  void addSubject(String subjectName, double grade, double units) {
    _subjects.add(Subject(subjectName: subjectName, grade: grade, units: units));
    computeGWA();
  }

  //Remove subject function
  void removeSubject(int index) {
    _subjects.removeAt(index);
    computeGWA();
  }

  //Clear entered subjects and grades functions for convenience
  void clearSubjects() {
    _subjects.clear();
    computeGWA();
  }

  //Compute function. The "brain" of the calculator
  void computeGWA() {
    if (_subjects.isEmpty) {
      _gwa = null;
      return;
    }
    double totalPoints = 0;
    double totalUnits = 0;
    for (var subject in _subjects) {
      totalPoints += subject.grade * subject.units;
      totalUnits += subject.units;
    }
    if (totalUnits > 0) _gwa = totalPoints / totalUnits;
  }

  double get totalUnits => _subjects.fold(0, (sum, subject) => sum + subject.units);
  int get subjectCount => _subjects.length;

  @override
  Widget buildBody(BuildContext context) => _GradeCalculatorModuleBody(module: this);
}

//Subject class. This is where you input your grades 
class Subject {
  final String subjectName;
  final double grade;
  final double units;
  Subject({required this.subjectName, required this.grade, required this.units});
}

class _GradeCalculatorModuleBody extends StatefulWidget {
  final GradeCalculatorModule module;
  const _GradeCalculatorModuleBody({required this.module});
  @override
  State<_GradeCalculatorModuleBody> createState() => _GradeCalculatorModuleBodyState();
}

//Code to input grades in a textbox 
class _GradeCalculatorModuleBodyState extends State<_GradeCalculatorModuleBody> {
  final _inputSubject = TextEditingController();
  final _inputGrade = TextEditingController();
  final _inputUnits = TextEditingController();

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: const Color(0xFFDC2626),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  //Delete confirmation button design
  void _confirmDelete({required String title, required String content, required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Text(content, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () { Navigator.pop(ctx); onConfirm(); },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFEE2E2),
                    foregroundColor: const Color(0xFFDC2626),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFFFCDD2)),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Clear', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  //Text input design code
  InputDecoration _inputDec(String hint, Color themeColor) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: themeColor, width: 2),
      ),
    );
  }

  //Display details widget
  Widget _displayDetails(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromARGB(255, 162, 162, 162), width: 0.6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
          ],
        ),
      ),
    );
  }

  //Adds a new subject and checks if the added subject is valid
  void _addSubject() {
    final subjectName = _inputSubject.text.trim();
    final grade = double.tryParse(_inputGrade.text);
    final units = double.tryParse(_inputUnits.text);

    if (subjectName.isEmpty || grade == null || units == null) return _showError('Please input with valid values');
    if (grade < 1.0 || grade > 5.0) return _showError('Grade must be between 1.0 and 5.0');
    if (units <= 0) return _showError('Units must be greater than 0');

    setState(() {
      widget.module.addSubject(subjectName, grade, units);
      _inputSubject.clear();
      _inputGrade.clear();
      _inputUnits.clear();
    });
  }

  // Main Widget
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Container(
      color: const Color(0xFFF5F5F7),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (widget.module.gwa != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [themeColor.withValues(alpha: 0.15), Colors.white],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('YOUR CURRENT GWA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700], letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Text(widget.module.gwa!.toStringAsFixed(2), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF1F2937), height: 1.1)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _displayDetails('Total Units', widget.module.totalUnits.toStringAsFixed(1)),
                      const SizedBox(width: 12),
                      _displayDetails('Subjects', '${widget.module.subjectCount}'),
                      const SizedBox(width: 12),
                      _displayDetails('Target', widget.module.targetGrade.toStringAsFixed(2)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add Subject', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                const SizedBox(height: 20),
                TextField(controller: _inputSubject, decoration: _inputDec('e.g., Math in the Modern World', themeColor)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Grade', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      TextField(controller: _inputGrade, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: _inputDec('e.g., 1.75', themeColor)),
                    ])),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Units', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      TextField(controller: _inputUnits, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: _inputDec('e.g., 3', themeColor)),
                    ])),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: FilledButton(
                      onPressed: _addSubject,
                      style: FilledButton.styleFrom(backgroundColor: themeColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Add Subject', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: OutlinedButton(
                      onPressed: () => setState(() { _inputSubject.clear(); _inputGrade.clear(); _inputUnits.clear(); }),
                      style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF1F2937), side: BorderSide(color: Colors.grey[300]!, width: 1.5), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Reset Fields', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    )),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _confirmDelete(
                      title: 'Clear all subjects?',
                      content: 'This will remove all subjects in the list. This action can\'t be undone.',
                      onConfirm: () => setState(() {
                        widget.module.clearSubjects(); 
                      }),
                    ),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red, width: 1.5), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), backgroundColor: const Color(0xFFFEE2E2)),
                    child: const Text('Clear All Subjects', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),

          if (widget.module.subjects.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Subject List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                  const SizedBox(height: 16),
                  ...widget.module.subjects.asMap().entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
                      child: Row(
                        children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(entry.value.subjectName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1F2937))),
                            const SizedBox(height: 4),
                            Text('Grade ${entry.value.grade.toStringAsFixed(2)} • ${entry.value.units.toStringAsFixed(1)} unit${entry.value.units != 1 ? 's' : ''}', style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
                          ])),
                          TextButton(
                            onPressed: () => _confirmDelete(
                              title: 'Delete subject?',
                              content: 'Are you sure you want to remove this subject from the list?',
                              onConfirm: () => setState(() {
                                widget.module.removeSubject(entry.key); 
                              }),
                            ),
                            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.red)),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}