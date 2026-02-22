import 'package:flutter/material.dart';
import '../models/tool_module.dart';
import 'bmi.dart';
import 'expense.dart';
import 'gradecalculator.dart';
import 'homescreen.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;
  final String userName;
  final Color themeColor;
  
  // setting up the defaults JUST in case nothing get passed in
  const HomePage({
    super.key,
    this.initialIndex = 0,
    this.userName = '',
    this.themeColor = Colors.blue
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // putting all the tools in a list so we can access them by index numbers
  final List<ToolModule> modules = [
    BmiModule(),
    ExpenseSplitterModule(),
    GradeCalculatorModule()
  ];

  late int _currentIndex;
  late String _userName;
  late Color _themeColor;

  final List<Color> _themeColors = [
    Colors.blue,
    Colors.green,
    Colors.purple
  ];

  final List<String> _themeColorNames = [
    'Blue',
    'Green',
    'Purple'
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _userName = widget.userName;
    _themeColor = widget.themeColor;
  }

  void _showSettingsDialog() {
    final TextEditingController nameController = TextEditingController(text: _userName);
    Color selectedColor = _themeColor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            
            // this the popup window for settings
            // where user can change their name and color
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)
              ),
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24)
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade50,
                            Colors.blue.shade100
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24)
                        )
                      ),
                      child: const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                          letterSpacing: 0.5
                        )
                      )
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              letterSpacing: 0.3
                            )
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
                            )
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Theme Color',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  letterSpacing: 0.3
                                )
                              ),
                              Text(
                                'Choose 1 of 3',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  letterSpacing: 0.3
                                )
                              )
                            ]
                          ),
                          const SizedBox(height: 12),
                          
                          // creating the color buttons by mapping the list
                          // making sure it highlight the one that is picked
                          ..._themeColors.asMap().entries.map((entry) {
                            final index = entry.key;
                            final color = entry.value;
                            final isSelected = selectedColor == color;
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () {
                                  setDialogState(() {
                                    selectedColor = color;
                                  });
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected ? color.withValues(alpha: 0.15) : Colors.grey[50],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected ? color : Colors.grey[200]!,
                                      width: isSelected ? 2 : 1
                                    )
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.3),
                                          shape: BoxShape.circle
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: color,
                                              shape: BoxShape.circle
                                            )
                                          )
                                        )
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          _themeColorNames[index],
                                          style: TextStyle(
                                            color: Colors.blueGrey[900],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.3
                                          )
                                        )
                                      )
                                    ]
                                  )
                                )
                              )
                            );
                          }),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.grey,
                                    side: BorderSide(color: Colors.grey[300]!, width: 1),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                    ),
                                    backgroundColor: Colors.white
                                  ),
                                  child: const Text(
                                    'CANCEL',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      letterSpacing: 1
                                    )
                                  )
                                )
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton(
                                  onPressed: () {
                                    final name = nameController.text.trim();
                                    
                                    // a red snackbar error if user try to save without name it wont let them
                                    if (name.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Please enter your name'),
                                          backgroundColor: Colors.red[600],
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                          )
                                        )
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
                                    backgroundColor: Colors.blue[600],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                    ),
                                    elevation: 0
                                  ),
                                  child: const Text(
                                    'SAVE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      letterSpacing: 1
                                    )
                                  )
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
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // wrapping everything in Theme so the colors updates everywhere
    // when the user pick a new color in settings
    return Theme(
      data: ThemeData(
        primaryColor: _themeColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _themeColor,
          primary: _themeColor
        )
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _themeColor,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    userName: _userName,
                    themeColor: _themeColor
                  )
                )
              );
            },
            tooltip: 'Back to Home'
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _userName.isEmpty ? 'Welcome!' : 'Hi, $_userName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1
                )
              ),
              Text(
                modules[_currentIndex].title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.5
                )
              )
            ]
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: _showSettingsDialog,
              tooltip: 'Settings'
            )
          ]
        ),
        
        // showing the actual tool screen based on what tab index we are on
        body: modules[_currentIndex].buildBody(context),
        
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: _themeColor, width: 3)
            )
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: _themeColor,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal
            ),
            // mapping the modules list to create the bottom buttons automatically
            items: modules.map((module) {
              return BottomNavigationBarItem(
                icon: Icon(module.icon),
                label: module.title
              );
            }).toList()
          )
        )
      )
    );
  }
}
