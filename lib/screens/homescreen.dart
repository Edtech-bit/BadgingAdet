import 'package:flutter/material.dart';
import 'settings_layout.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final Color themeColor;

  const HomeScreen({super.key, this.userName = '', this.themeColor = Colors.blue});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _userName;
  late Color _themeColor;

  final _themeColors = [Colors.blue, Colors.green, Colors.purple];
  final _themeColorNames = ['Blue', 'Green', 'Purple'];

  @override
  void initState() {
    super.initState();
    _userName = widget.userName;
    _themeColor = widget.themeColor;
    
    // this runs when the app is first opening
    // it checks if user name is empty so it can show the initialization account popup
    if (_userName.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showSettingsDialog(isFirstTime: true));
    }
  }

  void _showSettingsDialog({bool isFirstTime = false}) {
    final TextEditingController nameController = TextEditingController(text: _userName);
    Color selectedColor = _themeColor;

    showDialog(
      context: context,
      barrierDismissible: !isFirstTime,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            
            // preventing user from closing dialog, making sure the user input their name
            return PopScope(
              canPop: !isFirstTime,
              child: Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 8,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade50, Colors.blue.shade100],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight
                          ),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))
                        ),
                        child: Text(
                          isFirstTime ? 'Welcome! Let\'s Get Started' : 'Settings',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade800, letterSpacing: 0.5)
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isFirstTime) ...[
                              Text('Please set up your profile to continue', style: TextStyle(fontSize: 14, color: Colors.grey.shade600, letterSpacing: 0.3)),
                              SizedBox(height: 20)
                            ],
                            Text('Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade600, letterSpacing: 0.3)),
                            SizedBox(height: 8),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Enter your name',
                                hintStyle: TextStyle(color: Colors.grey.shade400),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16)
                              )
                            ),
                            SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Theme Color', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade600, letterSpacing: 0.3)),
                                Text('Choose 1 of 3', style: TextStyle(fontSize: 12, color: Colors.grey.shade500, letterSpacing: 0.3))
                              ]
                            ),
                            SizedBox(height: 12),
                            
                            // looping through the colors array to make the choice buttons
                            ..._themeColors.asMap().entries.map((entry) {
                              final index = entry.key;
                              final color = entry.value;
                              final isSelected = selectedColor == color;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  onTap: () {
                                    setDialogState(() {
                                      selectedColor = color;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isSelected ? color.withValues(alpha: 0.15) : Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: isSelected ? color : Colors.grey.shade200, width: isSelected ? 2 : 1)
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40, height: 40,
                                          decoration: BoxDecoration(color: color.withValues(alpha: 0.3), shape: BoxShape.circle),
                                          child: Center(
                                            child: Container(width: 24, height: 24, decoration: BoxDecoration(color: color, shape: BoxShape.circle))
                                          )
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            _themeColorNames[index],
                                            style: TextStyle(color: Colors.blueGrey.shade900, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.3)
                                          )
                                        )
                                      ]
                                    )
                                  )
                                )
                              );
                            }),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                if (!isFirstTime) ...[
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.grey.shade600,
                                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        backgroundColor: Colors.white
                                      ),
                                      child: Text('CANCEL', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 1))
                                    )
                                  ),
                                  SizedBox(width: 12)
                                ],
                                Expanded(
                                  child: FilledButton(
                                    onPressed: () {
                                      final name = nameController.text.trim();
                              
                                      // snackbar showing red warning to users who dont enter their name
                                      if (name.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Please enter your name'), backgroundColor: Colors.red.shade600)
                                        );
                                        return;
                                      }
                                      setState(() {
                                        _userName = name;
                                        _themeColor = selectedColor;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.blue.shade600,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      elevation: 0
                                    ),
                                    child: Text(isFirstTime ? 'GET STARTED' : 'SAVE', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 1))
                                  )
                                )
                              ]
                            )
                          ]
                        )
                      )
                    ]
                  )
                )
              )
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_userName.isEmpty ? 'Welcome!' : 'Hi, $_userName', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
            Text('Daily Helper Toolkit', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: 0.5))
          ]
        ),
        actions: [
          IconButton(icon: Icon(Icons.settings_outlined), onPressed: _showSettingsDialog, tooltip: 'Settings')
        ]
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: 40),
                Text('Daily Helper Toolkit', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800, letterSpacing: 0.5)),
                SizedBox(height: 8),
                Text('Three Tools in One!', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey.shade600, letterSpacing: 0.3)),
                SizedBox(height: 48),
                Text('Created By', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade700, letterSpacing: 0.5)),
                SizedBox(height: 20),
                
                // creators of this project, using a widget builder for simplicity sakes
                Column(
                  children: [
                    Row(
                      children: [
                        _studentsRow('ANUNCIATION, Adrian'),
                        SizedBox(width: 12),
                        _studentsRow('CASTILLO, Ed Clarence'),
                        SizedBox(width: 12),
                        _studentsRow('LOZANO, Aaron Daniel')
                      ]
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        _studentsRow('PINEDA, Eldrin Josh'),
                        SizedBox(width: 12),
                        _studentsRow('PRADILLA, Khristian Carl')
                      ]
                    )
                  ]
                ),
                SizedBox(height: 48),
                Text('Explore', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade700, letterSpacing: 0.5)),
                SizedBox(height: 20),
                _toolRow(icon: Icons.monitor_weight_outlined, title: 'BMI Calculator', description: 'Track your body mass index', color: Colors.blue.shade700, moduleIndex: 0),
                SizedBox(height: 16),
                _toolRow(icon: Icons.payments_outlined, title: 'Expense Splitter', description: 'Split bills with friends', color: Colors.green.shade700, moduleIndex: 1),
                SizedBox(height: 16),
                _toolRow(icon: Icons.calculate_outlined, title: 'Grade Calculator', description: 'Calculate your grades easily', color: Colors.purple.shade600, moduleIndex: 2),
                SizedBox(height: 40)
              ]
            )
          )
        )
      )
    );
  }

  Widget _studentsRow(String name) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: Offset(0, 2))]
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6, offset: Offset(0, 2))]
              ),
              child: Icon(Icons.person_outline, color: Colors.blue.shade300, size: 28)
            ),
            SizedBox(height: 12),
            Text(name, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade800, letterSpacing: 0.3), maxLines: 2, overflow: TextOverflow.ellipsis)
          ]
        )
      )
    );
  }

  Widget _toolRow({required IconData icon, required String title, required String description, required Color color, required int moduleIndex}) {
    return InkWell(
      onTap: () {
        
        // taking user to the mini-tool they clicked on
        // passing the names and colors over so other pages will have the same settings
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(initialIndex: moduleIndex, userName: _userName, themeColor: _themeColor)));
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 12, offset: Offset(0, 4))]
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, size: 32, color: color)
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800, letterSpacing: 0.3)),
                  SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, letterSpacing: 0.2))
                ]
              )
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: color)
          ]
        )
      )
    );
  }
}
