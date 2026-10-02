import 'package:flutter/material.dart';
import 'package:liquidify/liquidify.dart';

void main() {
  runApp(const LiquidifyExampleApp());
}

class LiquidifyExampleApp extends StatefulWidget {
  const LiquidifyExampleApp({super.key});

  @override
  State<LiquidifyExampleApp> createState() => _LiquidifyExampleAppState();
}

class _LiquidifyExampleAppState extends State<LiquidifyExampleApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _forceLiquidGlass = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquidify Showcase',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007AFF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A84FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: LiquidifyShowcaseScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        forceGlass: _forceLiquidGlass,
        onToggleTheme: () {
          setState(() {
            _themeMode = _themeMode == ThemeMode.dark
                ? ThemeMode.light
                : ThemeMode.dark;
          });
        },
        onToggleForce: (val) {
          setState(() {
            _forceLiquidGlass = val;
          });
        },
      ),
    );
  }
}

class LiquidifyShowcaseScreen extends StatefulWidget {
  final bool isDarkMode;
  final bool forceGlass;
  final VoidCallback onToggleTheme;
  final ValueChanged<bool> onToggleForce;

  const LiquidifyShowcaseScreen({
    super.key,
    required this.isDarkMode,
    required this.forceGlass,
    required this.onToggleTheme,
    required this.onToggleForce,
  });

  @override
  State<LiquidifyShowcaseScreen> createState() =>
      _LiquidifyShowcaseScreenState();
}

class _LiquidifyShowcaseScreenState extends State<LiquidifyShowcaseScreen> {
  int _currentIndex = 0;
  bool _switchValue = true;
  double _sliderValue = 65.0;
  Set<int> _selectedSegment = {0};
  final TextEditingController _textController = TextEditingController(
    text: 'Steve Jobs',
  );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showLiquidDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Liquid Glass Dialog'),
        content: const Text(
          'This dialog was converted smoothly using .liquidGlass() without changing any constructor properties!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ).liquidGlass(),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Confirm'),
          ).liquidGlass(
            options: LiquidGlassOptions(
              force: widget.forceGlass,
              tint: const Color(0xFF007AFF).withValues(alpha: 0.35),
            ),
          ),
        ],
      ).liquidGlass(options: LiquidGlassOptions(force: widget.forceGlass)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final opts = LiquidGlassOptions(force: widget.forceGlass);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Liquidify',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ).liquidGlass(options: opts),
          const SizedBox(width: 8.0),
        ],
      ).liquidGlass(options: opts),
      body: Stack(
        children: [
          // Background rich decorative gradient bubbles to highlight frosted glass
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.isDarkMode
                      ? [
                          const Color(0xFF0F172A),
                          const Color(0xFF1E1B4B),
                          const Color(0xFF311042),
                        ]
                      : [
                          const Color(0xFFE0E7FF),
                          const Color(0xFFFCE7F3),
                          const Color(0xFFFEF3C7),
                        ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: -40,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6366F1).withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 140,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFEC4899).withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main scrollable content
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 120.0),
              children: [
                // Quick settings card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Force Liquid Glass',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                            Switch(
                              value: widget.forceGlass,
                              onChanged: widget.onToggleForce,
                            ).liquidGlass(options: opts),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'When active, forces Apple Liquid Glass rendering on Android, Web, and Desktop.',
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).liquidGlass(options: opts),

                const SizedBox(height: 18.0),

                // Search Bar
                SearchBar(
                  hintText: 'Search liquid components...',
                  leading: const Icon(Icons.search),
                ).liquidGlass(options: opts),

                const SizedBox(height: 18.0),

                // Segmented Button
                Center(
                  child: SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 0, label: Text('Frosted')),
                      ButtonSegment(value: 1, label: Text('Crystal')),
                      ButtonSegment(value: 2, label: Text('Smoke')),
                    ],
                    selected: _selectedSegment,
                    onSelectionChanged: (val) {
                      setState(() => _selectedSegment = val);
                    },
                  ).liquidGlass(options: opts),
                ),

                const SizedBox(height: 24.0),

                // Input Field
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    labelText: 'User Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ).liquidGlass(options: opts),

                const SizedBox(height: 24.0),

                // Sliders & Controls Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Glass Fluidity',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text('${_sliderValue.toInt()}%'),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Slider(
                          value: _sliderValue,
                          min: 0,
                          max: 100,
                          divisions: 100,
                          onChanged: (val) =>
                              setState(() => _sliderValue = val),
                        ).liquidGlass(options: opts),
                        const Divider(height: 28.0),
                        SwitchListTile(
                          title: const Text('Dynamic Haptics'),
                          subtitle: const Text(
                            'Subtle micro-feedback on touch',
                          ),
                          value: _switchValue,
                          onChanged: (val) =>
                              setState(() => _switchValue = val),
                        ).liquidGlass(options: opts),
                      ],
                    ),
                  ),
                ).liquidGlass(options: opts),

                const SizedBox(height: 24.0),

                // Chips Row
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.star, size: 16.0),
                      label: const Text('Featured'),
                    ).liquidGlass(options: opts),
                    FilterChip(
                      label: const Text('Interactive'),
                      selected: true,
                      onSelected: (_) {},
                    ).liquidGlass(options: opts),
                    ActionChip(
                      avatar: const Icon(Icons.open_in_new, size: 16.0),
                      label: const Text('Dialog Demo'),
                      onPressed: () => _showLiquidDialog(context),
                    ).liquidGlass(options: opts),
                  ],
                ),

                const SizedBox(height: 24.0),

                // Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showLiquidDialog(context),
                        child: const Text('Open Dialog'),
                      ).liquidGlass(options: opts),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {},
                        child: const Text('Save Action'),
                      ).liquidGlass(options: opts),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets_outlined),
            activeIcon: Icon(Icons.widgets),
            label: 'Showcase',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.palette_outlined),
            activeIcon: Icon(Icons.palette),
            label: 'Styles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ).liquidGlass(options: opts),
    );
  }
}
