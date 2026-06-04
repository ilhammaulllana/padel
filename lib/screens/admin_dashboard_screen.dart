import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import '../models/venue.dart';
import '../providers/booking_provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isAuthenticated = false;
  final _emailController = TextEditingController(text: 'admin@courtly.com');
  final _passwordController = TextEditingController(text: 'admin');
  final _loginFormKey = GlobalKey<FormState>();

  String _selectedFilter = 'All'; // 'All', 'Pending', 'Confirmed', 'Completed', 'Cancelled'

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_loginFormKey.currentState!.validate()) {
      if (_emailController.text.trim() == 'admin@courtly.com' &&
          _passwordController.text == 'admin') {
        setState(() {
          _isAuthenticated = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials. Use admin@courtly.com / admin'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return _buildLoginWall();
    }
    return _buildDashboardContent();
  }

  // --- LOGIN GATE SCREEN ---
  Widget _buildLoginWall() {
    return Container(
      color: const Color(0xFF0D0F12),
      child: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 12,
            color: const Color(0xFF151824),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Admin Dashboard',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to manage partner venue bookings',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF9EAFBC),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Email Address',
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration('admin@courtly.com', Icons.email_outlined),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Enter email address';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Password',
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration('••••••••', Icons.lock_outline),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Enter password';
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCCFF00),
                        foregroundColor: const Color(0xFF0D0F12),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Login securely',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _emailController.text = 'admin@courtly.com';
                          _passwordController.text = 'admin';
                          _isAuthenticated = true;
                        });
                      },
                      child: Text(
                        'Demo Quick Bypass',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF00E5FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
      prefixIcon: Icon(icon, color: Colors.white30, size: 18),
      filled: true,
      fillColor: const Color(0xFF0D0F12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.02)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1.5),
      ),
    );
  }

  // --- MAIN DASHBOARD SCREEN ---
  Widget _buildDashboardContent() {
    final provider = Provider.of<BookingProvider>(context);
    final bookings = provider.bookings;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    // Calculations for metrics
    final totalBookings = bookings.length;
    final pendingCount = bookings.where((b) => b.status == BookingStatus.pending).length;
    final confirmedCount = bookings.where((b) => b.status == BookingStatus.confirmed).length;
    
    double revenue = 0;
    for (var b in bookings) {
      if (b.status == BookingStatus.confirmed || b.status == BookingStatus.completed) {
        final venue = provider.venues.firstWhere((v) => v.id == b.venueId);
        revenue += venue.pricePerHour;
      }
    }

    // Apply Filter
    final filteredBookings = bookings.where((b) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Pending' && b.status == BookingStatus.pending) return true;
      if (_selectedFilter == 'Confirmed' && b.status == BookingStatus.confirmed) return true;
      if (_selectedFilter == 'Completed' && b.status == BookingStatus.completed) return true;
      if (_selectedFilter == 'Cancelled' && b.status == BookingStatus.cancelled) return true;
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151824),
        title: Text(
          'Courtly Venue Control Room',
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white70),
            tooltip: 'Logout Demo',
            onPressed: () {
              setState(() {
                _isAuthenticated = false;
              });
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Header
              isDesktop
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome Back, Admin',
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Live system monitors active bookings across all clubs.',
                                style: GoogleFonts.outfit(color: const Color(0xFF9EAFBC), fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildOnlineBadge(),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back, Admin',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Live system monitors active bookings across all clubs.',
                          style: GoogleFonts.outfit(color: const Color(0xFF9EAFBC), fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        _buildOnlineBadge(),
                      ],
                    ),
              const SizedBox(height: 24),

              // KPI Dashboard Metric Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final kpiCount = constraints.maxWidth > 800 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: kpiCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: constraints.maxWidth > 800 ? 1.5 : (constraints.maxWidth > 400 ? 1.7 : 1.35),
                    children: [
                      _buildMetricCard('Total Bookings', totalBookings.toString(), Icons.book_online, Colors.white24),
                      _buildMetricCard('Pending Validation', pendingCount.toString(), Icons.hourglass_empty_rounded, Colors.orangeAccent),
                      _buildMetricCard('Confirmed Slots', confirmedCount.toString(), Icons.check_circle_outline, Colors.blueAccent),
                      _buildMetricCard('Active Revenue', 'Rp ${NumberFormat('#,###').format(revenue)}', Icons.payments_outlined, const Color(0xFFCCFF00)),
                    ],
                  );
                },
              ),
              const SizedBox(height: 36),

              // Booking Table / List Title and Status Filters
              Text(
                'Reservations Log',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // Status Tabs Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Pending', 'Confirmed', 'Completed', 'Cancelled'].map((status) {
                    final isSelected = _selectedFilter == status;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(
                          status,
                          style: GoogleFonts.outfit(
                            color: isSelected ? const Color(0xFF0D0F12) : Colors.white60,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedFilter = status;
                            });
                          }
                        },
                        selectedColor: const Color(0xFFCCFF00),
                        backgroundColor: const Color(0xFF151824),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Booking List Grid / Card Items
              if (filteredBookings.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 80),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151824).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.inbox_rounded, color: Colors.white24, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'No bookings match the filter.',
                          style: GoogleFonts.outfit(color: Colors.white30, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredBookings.length,
                  itemBuilder: (context, index) {
                    final booking = filteredBookings[index];
                    return _buildBookingLogCard(booking, provider);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.greenAccent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'SYSTEM ONLINE',
            style: GoogleFonts.outfit(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Card(
      color: const Color(0xFF151824),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.white.withOpacity(0.04)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13),
                ),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingLogCard(Booking booking, BookingProvider provider) {
    final venue = provider.venues.firstWhere((v) => v.id == booking.venueId);
    final dateStr = DateFormat('EEE, d MMM yyyy').format(booking.bookingDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF151824).withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withOpacity(0.04)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 650;

            final infoSection = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      booking.id,
                      style: GoogleFonts.spaceGrotesk(
                        color: const Color(0xFF00E5FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: booking.status.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        booking.status.name.toUpperCase(),
                        style: GoogleFonts.outfit(
                          color: booking.status.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${booking.venueName} • ${booking.courtName}',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Schedule: $dateStr @ ${booking.timeSlot}',
                  style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.white30, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${booking.customerName} (+${booking.customerPhone})',
                        style: GoogleFonts.outfit(color: const Color(0xFF9EAFBC), fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            );

            final actionsSection = Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (booking.status == BookingStatus.pending) ...[
                  ElevatedButton(
                    onPressed: () {
                      provider.updateBookingStatus(booking.id, BookingStatus.confirmed);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Text('Confirm', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                ],
                if (booking.status == BookingStatus.confirmed) ...[
                  ElevatedButton(
                    onPressed: () {
                      provider.updateBookingStatus(booking.id, BookingStatus.completed);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Text('Complete', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                ],
                if (booking.status != BookingStatus.cancelled && booking.status != BookingStatus.completed) ...[
                  OutlinedButton(
                    onPressed: () {
                      provider.updateBookingStatus(booking.id, BookingStatus.cancelled);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Text('Cancel', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            );

            if (isWide) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: infoSection),
                  actionsSection,
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  infoSection,
                  const Divider(color: Colors.white10, height: 24),
                  actionsSection,
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
