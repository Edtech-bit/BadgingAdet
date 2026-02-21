import 'package:flutter/material.dart';
import 'settings_layout.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final Color themeColor;

  const HomeScreen({
    super.key,
    this.userName = '',
    this.themeColor = const Color(0xFF7B9FE8),
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _userName;
  late Color _themeColor;

  final List<Color> _themeColors = [
    const Color(0xFF7B9FE8),
    const Color(0xFF81C995),
    const Color(0xFFB39CD0),
  ];

  final List<String> _themeColorNames = [
    'Blue',
    'Green',
    'Purple',
  ];

  @override
  void initState() {
    super.initState();
    _userName = widget.userName;
    _themeColor = widget.themeColor;
    
    // This if condition checks if the user's name variable is empty
    // If yes, prompts the setup on the first launch
    if (_userName.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSettingsDialog(isFirstTime: true);
      });
    }
  }

  void _showSettingsDialog({bool isFirstTime = false}) {
    final TextEditingController nameController = TextEditingController(text: _userName);
    Color selectedColor = _themeColor;

    showDialog(
      context: context,
      // Basically prevents dismissing the setup to make sure user sets up their profile
      barrierDismissible: !isFirstTime,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return WillPopScope(
              onWillPop: () async => !isFirstTime, 
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 8,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
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
                              const Color(0xFFE8EFFA),
                              const Color(0xFFD4E3F7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Text(
                          isFirstTime ? 'Welcome! Let\'s Get Started' : 'Settings',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isFirstTime) ...[
                              Text(
                                'Please set up your profile to continue',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                            const Text(
                              'Name',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Enter your name',
                                hintStyle: TextStyle(color: Colors.grey[400]),
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
                                  borderSide: const BorderSide(color: Color(0xFF7B9FE8), width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
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
                                    color: Color(0xFF6B7280),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                Text(
                                  'Choose 1 of 3',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
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
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: color.withValues(alpha: 0.3),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: color,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            _themeColorNames[index],
                                            style: TextStyle(
                                              color: const Color(0xFF1F2937),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (!isFirstTime) ...[
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF6B7280),
                                        side: BorderSide(color: Colors.grey[300]!, width: 1),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        backgroundColor: Colors.white,
                                      ),
                                      child: const Text(
                                        'CANCEL',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                Expanded(
                                  child: FilledButton(
                                    onPressed: () {
                                      final name = nameController.text.trim();
                                      // alerts the user with an error snackbar if the name string value is empty
                                      if (name.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Please enter your name'),
                                            backgroundColor: const Color(0xFFDC2626),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
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
                                      backgroundColor: const Color(0xFF4F7FEE),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      isFirstTime ? 'GET STARTED' : 'SAVE',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
            // This checks if the user currently hasn't configured a custom name 
            // Then dynamically displays the proper text greeting based on that variable
            Text(
              _userName.isEmpty ? 'Welcome!' : 'Hi, $_userName',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const Text(
              'Daily Helper Toolkit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: _showSettingsDialog,
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Daily Helper Toolkit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Three Tools in One!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Created By',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                _buildCreatorsGrid(),
                const SizedBox(height: 48),
                Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                _buildModuleCard(
                  context,
                  icon: Icons.monitor_weight_outlined,
                  title: 'BMI Calculator',
                  description: 'Track your body mass index',
                  color: const Color.fromARGB(255, 19, 92, 238),
                  moduleIndex: 0,
                ),
                const SizedBox(height: 16),
                _buildModuleCard(
                  context,
                  icon: Icons.payments_outlined,
                  title: 'Expense Splitter',
                  description: 'Split bills with friends',
                  color: const Color.fromARGB(255, 13, 150, 52),
                  moduleIndex: 1,
                ),
                const SizedBox(height: 16),
                _buildModuleCard(
                  context,
                  icon: Icons.calculate_outlined,
                  title: 'Grade Calculator',
                  description: 'Calculate your grades easily',
                  color: const Color.fromARGB(255, 138, 42, 255),
                  moduleIndex: 2,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreatorsGrid() {
    final creators = [
      'ANUNCIATION, Adrian',
      'CASTILLO, Ed Clarence',
      'LOZANO, Aaron Daniel',
      'PINEDA, Eldrin Josh',
      'PRADILLA, Khristian Carl',
    ];

    // This predefined data lists all of the specific creator names
    // Then assigns them neatly into separate UI grid layouts visually
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCreatorCard(creators[0]),
            const SizedBox(width: 12),
            _buildCreatorCard(creators[1]),
            const SizedBox(width: 12),
            _buildCreatorCard(creators[2]),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCreatorCard(creators[3]),
            const SizedBox(width: 12),
            _buildCreatorCard(creators[4]),
          ],
        ),
      ],
    );
  }

  Widget _buildCreatorCard(String name) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFE8EFFA),
              const Color(0xFFD4E3F7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_outline,
                color: Color(0xFF7B9FE8),
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
                letterSpacing: 0.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required int moduleIndex,
  }) {
    return InkWell(
      // This Inkwell captures whenever a specific tool card is clicked 
      // Then securely navigates the app view to the mapped layout for that module index
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              initialIndex: moduleIndex,
              userName: _userName,
              themeColor: _themeColor,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
