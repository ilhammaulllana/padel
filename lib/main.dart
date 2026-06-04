import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/booking_provider.dart';
import 'screens/landing_page.dart';
import 'screens/booking_flow_screen.dart';
import 'screens/admin_dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp(
        title: 'Courtly - Sports Booking Platform',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFFCCFF00),
          scaffoldBackgroundColor: const Color(0xFF0D0F12),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFCCFF00),
            secondary: Color(0xFF00E5FF),
            background: Color(0xFF0D0F12),
            surface: Color(0xFF151824),
          ),
          textTheme: GoogleFonts.outfitTextTheme(
            ThemeData.dark().textTheme,
          ),
          useMaterial3: true,
        ),
        home: const AppShell(),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  void _onNavigate(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    final List<Widget> screens = [
      LandingPage(onNavigate: _onNavigate),
      const BookingFlowScreen(),
      const AdminDashboardScreen(),
    ];

    return Scaffold(
      appBar: isDesktop ? _buildDesktopHeader() : null,
      body: SafeArea(child: screens[_selectedIndex]),
      bottomNavigationBar: !isDesktop ? _buildBottomNavBar() : null,
    );
  }

  PreferredSizeWidget _buildDesktopHeader() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF151824),
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.05),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            GestureDetector(
              onTap: () => _onNavigate(0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCCFF00),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.sports_tennis_rounded,
                      color: Color(0xFF0D0F12),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'COURTLY',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Links
            Row(
              children: [
                _buildHeaderNavLink('Home', 0),
                const SizedBox(width: 32),
                _buildHeaderNavLink('Book a Court', 1),
                const SizedBox(width: 32),
                _buildHeaderNavLink('Admin Portal', 2),
              ],
            ),

            // CTA Button
            ElevatedButton(
              onPressed: () => _onNavigate(1),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCCFF00),
                foregroundColor: const Color(0xFF0D0F12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Book Now',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderNavLink(String title, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onNavigate(index),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                color: isSelected ? const Color(0xFFCCFF00) : const Color(0xFF9EAFBC),
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 12,
              height: 2,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFCCFF00) : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onNavigate,
      backgroundColor: const Color(0xFF151824),
      selectedItemColor: const Color(0xFFCCFF00),
      unselectedItemColor: const Color(0xFF9EAFBC),
      selectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: GoogleFonts.outfit(fontSize: 11),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_tennis_outlined),
          activeIcon: Icon(Icons.sports_tennis_rounded),
          label: 'Book Court',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings_outlined),
          activeIcon: Icon(Icons.admin_panel_settings_rounded),
          label: 'Admin',
        ),
      ],
    );
  }
}
