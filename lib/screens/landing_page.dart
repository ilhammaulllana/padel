import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  final Function(int) onNavigate;

  const LandingPage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Hero Section
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? size.width * 0.08 : 24,
              vertical: isDesktop ? 80 : 40,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0D0F12),
                  const Color(0xFF151824).withOpacity(0.8),
                  const Color(0xFF0D0F12),
                ],
              ),
            ),
            child: () {
              final leftHero = Column(
                crossAxisAlignment:
                    isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCCFF00).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFFCCFF00).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '⚡ MULTI-TENANT PADEL BOOKING MVP',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFFCCFF00),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Seamless Padel Booking\n',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: isDesktop ? 56 : 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        TextSpan(
                          text: 'Zero Hassle. Real-Time.',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: isDesktop ? 56 : 36,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [Color(0xFFCCFF00), Color(0xFF00E5FF)],
                              ).createShader(
                                const Rect.fromLTWH(0.0, 0.0, 400.0, 70.0),
                              ),
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Courtly replaces manual WhatsApp scheduling with an automated, multi-tenant digital booking platform. Customers secure slots in 2 minutes, while owners manage venue availability seamlessly.',
                    textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF9EAFBC),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Wrap(
                    alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      ElevatedButton(
                        onPressed: () => onNavigate(1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCCFF00),
                          foregroundColor: const Color(0xFF0D0F12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 8,
                          shadowColor: const Color(0xFFCCFF00).withOpacity(0.4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Book a Court Now',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => onNavigate(2),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Tenant Admin Portal',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.dashboard_rounded, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
 
              final rightHero = Container(
                margin: EdgeInsets.only(top: isDesktop ? 0 : 40),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00E5FF).withOpacity(0.15),
                            blurRadius: 100,
                            spreadRadius: 40,
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 16,
                      color: const Color(0xFF1E2230).withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        width: 380,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Apex Padel Arena',
                                        style: GoogleFonts.spaceGrotesk(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        'Court A (Indoor)',
                                        style: GoogleFonts.outfit(
                                          color: const Color(0xFF00E5FF),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCCFF00).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Rp 150k/h',
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFFCCFF00),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.white12, height: 32),
                            Text(
                              'Select Time Slot',
                              style: GoogleFonts.outfit(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildMockSlotRow('08:00 - 09:00', 'Booked', Colors.redAccent.withOpacity(0.2), Colors.redAccent),
                            const SizedBox(height: 8),
                            _buildMockSlotRow('09:00 - 10:00', 'Available', const Color(0xFFCCFF00).withOpacity(0.15), const Color(0xFFCCFF00)),
                            const SizedBox(height: 8),
                            _buildMockSlotRow('10:00 - 11:00', 'Available', const Color(0xFFCCFF00).withOpacity(0.15), const Color(0xFFCCFF00)),
                            const SizedBox(height: 8),
                            _buildMockSlotRow('11:00 - 12:00', 'Booked', Colors.redAccent.withOpacity(0.2), Colors.redAccent),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
 
              return isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 5, child: leftHero),
                        const SizedBox(width: 48),
                        Expanded(flex: 4, child: rightHero),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        leftHero,
                        const SizedBox(height: 40),
                        rightHero,
                      ],
                    );
            }(),
          ),

          // 2. Problem & Solution Comparison
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
            color: const Color(0xFF08090C),
            child: Column(
              children: [
                Text(
                  'THE SYSTEM UPGRADE',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF00E5FF),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Say Goodbye to Booking Chaos',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final useHorizontal = width > 750;
                    return useHorizontal
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildComparisonCard(
                                  title: 'WhatsApp Booking (Before)',
                                  icon: Icons.cancel_outlined,
                                  iconColor: Colors.redAccent,
                                  items: [
                                    'Frustrating waiting time for admin responses.',
                                    'Risk of double booking / scheduling conflicts.',
                                    'No visual overview of vacant slots.',
                                    'Loss of booking records and payments.',
                                  ],
                                  bgColor: const Color(0xFF161315),
                                  borderColor: Colors.redAccent.withOpacity(0.2),
                                ),
                              ),
                              const SizedBox(width: 32),
                              Expanded(
                                child: _buildComparisonCard(
                                  title: 'Courtly Booking (After)',
                                  icon: Icons.check_circle_outline_rounded,
                                  iconColor: const Color(0xFFCCFF00),
                                  items: [
                                    'Instantly check slot availability in real time.',
                                    'Guaranteed zero double-bookings.',
                                    'Reservations complete in under 2 minutes.',
                                    'Automatic tracking for customers and admins.',
                                  ],
                                  bgColor: const Color(0xFF141913),
                                  borderColor: const Color(0xFFCCFF00).withOpacity(0.2),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildComparisonCard(
                                title: 'WhatsApp Booking (Before)',
                                icon: Icons.cancel_outlined,
                                iconColor: Colors.redAccent,
                                items: [
                                  'Frustrating waiting time for admin responses.',
                                  'Risk of double booking / scheduling conflicts.',
                                  'No visual overview of vacant slots.',
                                  'Loss of booking records and payments.',
                                ],
                                bgColor: const Color(0xFF161315),
                                borderColor: Colors.redAccent.withOpacity(0.2),
                              ),
                              const SizedBox(height: 24),
                              _buildComparisonCard(
                                title: 'Courtly Booking (After)',
                                icon: Icons.check_circle_outline_rounded,
                                iconColor: const Color(0xFFCCFF00),
                                items: [
                                  'Instantly check slot availability in real time.',
                                  'Guaranteed zero double-bookings.',
                                  'Reservations complete in under 2 minutes.',
                                  'Automatic tracking for customers and admins.',
                                ],
                                bgColor: const Color(0xFF141913),
                                borderColor: const Color(0xFFCCFF00).withOpacity(0.2),
                              ),
                            ],
                          );
                  },
                ),
              ],
            ),
          ),

          // 3. Feature Highlights
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? size.width * 0.08 : 24,
              vertical: 80,
            ),
            color: const Color(0xFF0D0F12),
            child: Column(
              children: [
                Text(
                  'CORE MVP FEATURES',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFCCFF00),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Designed for Efficiency',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),
                GridView.count(
                  crossAxisCount: isDesktop ? 3 : 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: isDesktop ? 1.0 : 1.3,
                  children: [
                    _buildFeatureCard(
                      icon: Icons.storefront_rounded,
                      title: 'Multi-Tenant Structure',
                      desc: 'A unified portal allowing several padel venues (tenants) to manage operations independently.',
                    ),
                    _buildFeatureCard(
                      icon: Icons.calendar_month_rounded,
                      title: 'Real-Time Availability',
                      desc: 'Interactive schedule slot grids that automatically block confirmed and pending bookings.',
                    ),
                    _buildFeatureCard(
                      icon: Icons.qr_code_2_rounded,
                      title: 'Instant Confirmation Link',
                      desc: 'Generates structured booking codes and routes users straight to WhatsApp to submit proof of payment.',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 4. Booking CTA Footer Banner
          Container(
            padding: const EdgeInsets.all(48),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E261A), Color(0xFF131F2A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Experience Courtly Right Now',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Use our simulated frontend flow to book a slot and see it update the Tenant Admin panel instantly.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF9EAFBC),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () => onNavigate(1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCCFF00),
                    foregroundColor: const Color(0xFF0D0F12),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Start Booking Demo',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            color: const Color(0xFF07080A),
            child: Column(
              children: [
                Text(
                  'Courtly © 2026',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Premium Sport Venue Booking Management System',
                  style: GoogleFonts.outfit(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockSlotRow(String time, String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: text, size: 16),
              const SizedBox(width: 8),
              Text(
                time,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: text,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> items,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      iconColor == Colors.redAccent ? Icons.close : Icons.check,
                      color: iconColor.withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF151824).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF00E5FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF00E5FF), size: 24),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            style: GoogleFonts.outfit(
              color: const Color(0xFF9EAFBC),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
