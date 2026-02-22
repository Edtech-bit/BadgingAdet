import 'package:flutter/material.dart';
import '../models/tool_module.dart';

class ExpenseSplitterModule extends ToolModule {
  @override
  String get title => 'Expense Splitter';

  @override
  IconData get icon => Icons.attach_money;
  double _total = 0.0;
  int _pax = 0;
  double _tipPercent = 10.0;
  double? _perPerson;
  double? _tipAmount;
  double? _grandTotal;

  //Text field to be able to enter bill information
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _paxController = TextEditingController();

  //Placeholders for pax and max number of bill
  //Para sa checkers
  static const double _isBillTooBig = 1000000.0;
  static const int _groupMax = 30;
  
  //Code para sa bill split function
  void splitBill() {
    if (_total > 0 && _pax > 0) {
      _tipAmount = _total * (_tipPercent / 100);
      _grandTotal = _total + _tipAmount!;
      _perPerson = _grandTotal! / _pax;
    }
  }

  //Code para makapag reset ng inputs
  void clearAll() {
    _total = 0.0;
    _pax = 0;
    _tipPercent = 10.0;
    _perPerson = null;
    _tipAmount = null;
    _grandTotal = null;
    _totalController.clear();
    _paxController.clear();
  }

  //Gets the bill and checks if masyadong malaki yung bill
  bool get isBillTooBig => _total > _isBillTooBig;

  @override
  Widget buildBody(BuildContext context) {
    return _ExpenseSplitterBody(module: this);
  }
}

class _ExpenseSplitterBody extends StatefulWidget {
  final ExpenseSplitterModule module;
  const _ExpenseSplitterBody({required this.module});

  @override
  State<_ExpenseSplitterBody> createState() => _ExpenseSplitterBodyState();
}

class _ExpenseSplitterBodyState extends State<_ExpenseSplitterBody> {
  
  //If statement to check different situations
  String? _billChecker() {
    if (widget.module._total <= 0) {
      return 'Please enter the total bill amount.';
    } if (widget.module._total < 1.0) {
      return 'Bill amount seems too low. Did you mean ₱${(widget.module._total * 100).toStringAsFixed(0)}?';
    } if (widget.module._pax <= 0) {
      return 'Number of people must be at least 1.';
    } if (widget.module._pax > ExpenseSplitterModule._groupMax) {
      return 'For groups over ${ExpenseSplitterModule._groupMax}, please double check your inputs.';
    }
    return null;
  }

  //Error message para lumitaw sa snack bar
  void _showErrorMessages(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: const Color(0xFFDC2626),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  //Code para sa ma-call yung computation function and checker
  void _onCompute() {
    final error = _billChecker();
    if (error != null) {
      _showErrorMessages(error);
      return;
    }

    setState(() {
      widget.module.splitBill();
    });
  }
  
  //Widget build and css
  @override
  Widget build(BuildContext context) {
    
    final themeColor = Theme.of(context).primaryColor;
    final lightThemeColor = themeColor.withValues(alpha: 0.15);

   
    final statBoxBorder = Border.all(
      color: const Color.fromARGB(255, 162, 162, 162),
      width: 0.6,
    );
    const statBoxRadius = BorderRadius.all(Radius.circular(12));
    const statBoxPadding = EdgeInsets.all(16);
    const statLabelStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
    const statValueStyle = TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1F2937));

    return Container(
      color: const Color(0xFFF5F5F7),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          
          if (widget.module._perPerson != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [lightThemeColor, Colors.white],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EACH PERSON PAYS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                          letterSpacing: 1,
                        ),
                      ),
                      
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: themeColor.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Tip ${widget.module._tipPercent.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    '₱${widget.module._perPerson!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                      height: 1.1,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: statBoxPadding,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: statBoxRadius,
                            border: statBoxBorder,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('People',
                                  style: statLabelStyle.copyWith(
                                      color: Colors.grey[600])),
                              const SizedBox(height: 4),
                              Text('${widget.module._pax}',
                                  style: statValueStyle),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: statBoxPadding,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: statBoxRadius,
                            border: statBoxBorder,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total w/ Tip',
                                  style: statLabelStyle.copyWith(
                                      color: Colors.grey[600])),
                              const SizedBox(height: 4),
                              Text(
                                  '₱${widget.module._grandTotal!.toStringAsFixed(2)}',
                                  style: statValueStyle),
                            ],
                          ),
                        ),
                      ),
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
                const Text(
                  'Bill Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                
                const SizedBox(height: 4),
                Text(
                  'Enter the total bill and how many people are splitting it.',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Bill (₱)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Before tip',
                            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: widget.module._totalController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintText: 'e.g., 1500',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                            ),
                            onChanged: (value) {
                              widget.module._total = double.tryParse(value) ?? 0;
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No. of People',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          
                          const SizedBox(height: 4),
                          Text(
                            'Including yourself',
                            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                          ),
                          
                          const SizedBox(height: 8),
                          TextField(
                            controller: widget.module._paxController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'e.g., 4',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                            ),
                            onChanged: (value) {
                              widget.module._pax = int.tryParse(value) ?? 1;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tip / Service Charge',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.module._tipPercent.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: themeColor,
                    inactiveTrackColor: Colors.grey[200],
                    thumbColor: themeColor,
                    overlayColor: themeColor.withValues(alpha: 0.2),
                    trackHeight: 4.0,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
                  ),
                  child: Slider(
                    value: widget.module._tipPercent,
                    min: 0,
                    max: 30,
                    divisions: 6,
                    label: '${widget.module._tipPercent.round()}%',
                    onChanged: (double value) {
                      setState(() {
                        widget.module._tipPercent = value;
                      });
                    },
                  ),
                ),
                
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: _onCompute,
                        style: FilledButton.styleFrom(
                          backgroundColor: themeColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Split Bill',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            widget.module.clearAll();
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1F2937),
                          side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (widget.module._perPerson != null) ...[
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
                  const Text(
                    'Bill Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    'How the total was calculated',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600])),
                      Text('₱${widget.module._total.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937))),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Tip (${widget.module._tipPercent.toStringAsFixed(0)}%)',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600])),
                      Text('₱${widget.module._tipAmount!.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937))),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: lightThemeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Grand Total',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937))),
                        Text('₱${widget.module._grandTotal!.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}