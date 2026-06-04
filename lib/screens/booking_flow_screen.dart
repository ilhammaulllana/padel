import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/venue.dart';
import '../models/booking.dart';
import '../providers/booking_provider.dart';

class BookingFlowScreen extends StatefulWidget {
  const BookingFlowScreen({super.key});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  int _currentStep = 0; // 0: Venue List, 1: Details & Slot Checker, 2: Customer Form, 3: Success Ticket

  Venue? _selectedVenue;
  DateTime _selectedDate = DateTime.now();
  String? _selectedCourt;
  String? _selectedSlot;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  Booking? _createdBooking;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _resetFlow() {
    setState(() {
      _currentStep = 0;
      _selectedVenue = null;
      _selectedDate = DateTime.now();
      _selectedCourt = null;
      _selectedSlot = null;
      _nameController.clear();
      _phoneController.clear();
      _createdBooking = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0F12),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header indicator
              if (_currentStep < 3) ...[
                _buildStepperProgress(),
                const SizedBox(height: 32),
              ],
              Expanded(
                child: _buildCurrentStepContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepperProgress() {
    final steps = ['Select Venue', 'Choose Slot', 'Your Details'];
    return Row(
      children: List.generate(steps.length, (index) {
        final isActive = _currentStep == index;
        final isDone = _currentStep > index;

        return Expanded(
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? const Color(0xFFCCFF00)
                      : isActive
                          ? const Color(0xFF00E5FF)
                          : const Color(0xFF1E2230),
                  border: Border.all(
                    color: isActive ? const Color(0xFF00E5FF) : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 16, color: Color(0xFF0D0F12))
                      : Text(
                          '${index + 1}',
                          style: GoogleFonts.outfit(
                            color: isActive ? Colors.white : Colors.white60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  steps[index],
                  style: GoogleFonts.outfit(
                    color: isActive
                        ? const Color(0xFF00E5FF)
                        : isDone
                            ? const Color(0xFFCCFF00)
                            : Colors.white30,
                    fontWeight: isActive || isDone ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
              if (index < steps.length - 1)
                Container(
                  width: 30,
                  height: 1,
                  color: Colors.white12,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildVenueListStep();
      case 1:
        return _buildSlotSelectionStep();
      case 2:
        return _buildCustomerFormStep();
      case 3:
        return _buildSuccessStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // --- STEP 1: VENUE LIST ---
  Widget _buildVenueListStep() {
    final provider = Provider.of<BookingProvider>(context);
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose a Sports Club',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We support multiple partner venues with real-time slot checking.',
          style: GoogleFonts.outfit(color: const Color(0xFF9EAFBC), fontSize: 14),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: provider.venues.length,
            itemBuilder: (context, index) {
              final venue = provider.venues[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 20),
                color: const Color(0xFF151824).withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedVenue = venue;
                      _selectedCourt = provider.getCourtsForVenue(venue.id).first;
                      _currentStep = 1;
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Flex(
                      direction: isDesktop ? Axis.horizontal : Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            venue.imageUrl,
                            width: isDesktop ? 180 : double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: isDesktop ? 180 : double.infinity,
                              height: 120,
                              color: Colors.white10,
                              child: const Icon(Icons.broken_image, color: Colors.white30),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20, height: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      venue.name,
                                      style: GoogleFonts.spaceGrotesk(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFCCFF00).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Rp ${NumberFormat('#,###').format(venue.pricePerHour)}/hr',
                                      style: GoogleFonts.outfit(
                                        color: const Color(0xFFCCFF00),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Color(0xFF00E5FF), size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    venue.location,
                                    style: GoogleFonts.outfit(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                venue.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF9EAFBC),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _buildTag(Icons.sports_tennis, '${venue.courtCount} Courts'),
                                  const SizedBox(width: 8),
                                  _buildTag(Icons.schedule, venue.operationalHours),
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
          ),
        ),
      ],
    );
  }

  Widget _buildTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white30, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: Colors.white60,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // --- STEP 2: SLOT SELECTION ---
  Widget _buildSlotSelectionStep() {
    if (_selectedVenue == null) return const SizedBox.shrink();
    final provider = Provider.of<BookingProvider>(context);

    final courts = provider.getCourtsForVenue(_selectedVenue!.id);
    final slots = provider.getAvailableTimeSlotsForVenue(_selectedVenue!.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top breadcrumb and title
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
              onPressed: () {
                setState(() {
                  _currentStep = 0;
                  _selectedSlot = null;
                });
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedVenue!.name,
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Select date, court, and time slot below.',
                    style: GoogleFonts.outfit(color: const Color(0xFF9EAFBC), fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Date selection row (7 days)
        Text(
          '1. Choose Date',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 64,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isSelected = date.year == _selectedDate.year &&
                  date.month == _selectedDate.month &&
                  date.day == _selectedDate.day;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                    _selectedSlot = null; // Reset selection on date change
                  });
                },
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF00E5FF) : const Color(0xFF151824),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(date).toUpperCase(),
                        style: GoogleFonts.outfit(
                          color: isSelected ? const Color(0xFF0D0F12) : Colors.white30,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date.day.toString(),
                        style: GoogleFonts.spaceGrotesk(
                          color: isSelected ? const Color(0xFF0D0F12) : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),

        // Court selection row
        Text(
          '2. Choose Court',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: courts.map((court) {
            final isSelected = _selectedCourt == court;
            return ChoiceChip(
              label: Text(
                court,
                style: GoogleFonts.outfit(
                  color: isSelected ? const Color(0xFF0D0F12) : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCourt = court;
                    _selectedSlot = null; // Reset selection on court change
                  });
                }
              },
              selectedColor: const Color(0xFFCCFF00),
              backgroundColor: const Color(0xFF151824),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.05),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              showCheckmark: false,
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Schedule Grid Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '3. Available Slots',
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                _buildIndicatorDot(Colors.redAccent.withOpacity(0.3), 'Booked'),
                const SizedBox(width: 12),
                _buildIndicatorDot(const Color(0xFFCCFF00), 'Available'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Slots Grid
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            final crossCount = constraints.maxWidth > 600 ? 4 : 2;
            return GridView.builder(
              itemCount: slots.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
              ),
              itemBuilder: (context, index) {
                final slot = slots[index];
                final isBooked = provider.isSlotBooked(
                  _selectedVenue!.id,
                  _selectedCourt!,
                  _selectedDate,
                  slot,
                );
                final isSelected = _selectedSlot == slot;

                return GestureDetector(
                  onTap: isBooked
                      ? null
                      : () {
                          setState(() {
                            _selectedSlot = slot;
                          });
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isBooked
                          ? Colors.redAccent.withOpacity(0.08)
                          : isSelected
                              ? const Color(0xFF00E5FF)
                              : const Color(0xFF151824),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isBooked
                            ? Colors.redAccent.withOpacity(0.2)
                            : isSelected
                                ? Colors.transparent
                                : Colors.white.withOpacity(0.05),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            slot,
                            style: GoogleFonts.outfit(
                              color: isBooked
                                  ? Colors.white30
                                  : isSelected
                                      ? const Color(0xFF0D0F12)
                                      : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isBooked ? 'Booked' : 'Available',
                            style: GoogleFonts.outfit(
                              color: isBooked
                                  ? Colors.redAccent
                                  : isSelected
                                      ? const Color(0xFF0D0F12).withOpacity(0.8)
                                      : const Color(0xFFCCFF00),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 16),

        // Action panel
        ElevatedButton(
          onPressed: _selectedSlot == null
              ? null
              : () {
                  setState(() {
                    _currentStep = 2;
                  });
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCCFF00),
            foregroundColor: const Color(0xFF0D0F12),
            disabledBackgroundColor: Colors.white10,
            disabledForegroundColor: Colors.white30,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Continue to Customer Info',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicatorDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.white30, fontSize: 11),
        ),
      ],
    );
  }

  // --- STEP 3: CUSTOMER FORM ---
  Widget _buildCustomerFormStep() {
    if (_selectedVenue == null || _selectedSlot == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Back
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
              onPressed: () {
                setState(() {
                  _currentStep = 1;
                });
              },
            ),
            const SizedBox(width: 8),
            Text(
              'Enter Booking Details',
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Summary details card
        Card(
          color: const Color(0xFF1E2230).withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.white.withOpacity(0.05)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSummaryRow('Venue', _selectedVenue!.name),
                const Divider(color: Colors.white12, height: 16),
                _buildSummaryRow('Court', _selectedCourt!),
                const Divider(color: Colors.white12, height: 16),
                _buildSummaryRow('Date', DateFormat('EEEE, MMM d, yyyy').format(_selectedDate)),
                const Divider(color: Colors.white12, height: 16),
                _buildSummaryRow('Time Slot', _selectedSlot!),
                const Divider(color: Colors.white12, height: 16),
                _buildSummaryRow(
                  'Price',
                  'Rp ${NumberFormat('#,###').format(_selectedVenue!.pricePerHour)}',
                  valColor: const Color(0xFFCCFF00),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Form fields
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Full Name',
                style: GoogleFonts.outfit(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration('e.g. Ahmad Rafiq', Icons.person_outline),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your full name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'WhatsApp Number',
                style: GoogleFonts.outfit(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: _buildInputDecoration('e.g. 6281234567890', Icons.phone_android_outlined),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your WhatsApp number.';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(val.trim())) {
                    return 'Please enter digits only (include country code, e.g. 6281...).';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const Spacer(),

        // Submit button
        ElevatedButton(
          onPressed: _submitBooking,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCCFF00),
            foregroundColor: const Color(0xFF0D0F12),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Confirm Reservation',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.white30, fontSize: 13),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: valColor ?? Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.white30, size: 20),
      filled: true,
      fillColor: const Color(0xFF151824),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.03)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<BookingProvider>(context, listen: false);
      
      // Generate unique code like PDL-2026-XXX
      final rand = Random();
      final numCode = 100 + rand.nextInt(900); // 3 digit code
      final bookingCode = 'PDL-2026-$numCode';

      final booking = Booking(
        id: bookingCode,
        venueId: _selectedVenue!.id,
        venueName: _selectedVenue!.name,
        courtName: _selectedCourt!,
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        bookingDate: _selectedDate,
        timeSlot: _selectedSlot!,
        status: BookingStatus.pending,
      );

      // Save to Provider
      provider.addBooking(booking);

      setState(() {
        _createdBooking = booking;
        _currentStep = 3;
      });
    }
  }

  // --- STEP 4: SUCCESS TICKET ---
  Widget _buildSuccessStep() {
    if (_createdBooking == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFCCFF00).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle_outline_rounded,
              color: Color(0xFFCCFF00), size: 48),
        ),
        const SizedBox(height: 16),
        Text(
          'Reservation Requested!',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your court slot is locked. Complete the payment below.',
          style: GoogleFonts.outfit(color: const Color(0xFF9EAFBC), fontSize: 13),
        ),
        const SizedBox(height: 24),

        // Beautiful glassmorphism receipt ticket
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2230),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ticket Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    Text(
                      'BOOKING CODE',
                      style: GoogleFonts.outfit(
                        color: Colors.white30,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _createdBooking!.id,
                      style: GoogleFonts.spaceGrotesk(
                        color: const Color(0xFF00E5FF),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              // Dotted Separator
              CustomPaint(
                size: const Size(double.infinity, 1),
                painter: _TicketDividerPainter(),
              ),

              // Ticket Details
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildSummaryRow('Sports Club', _createdBooking!.venueName),
                    const SizedBox(height: 12),
                    _buildSummaryRow('Court Info', _createdBooking!.courtName),
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                        'Date', DateFormat('EEEE, MMM d, yyyy').format(_createdBooking!.bookingDate)),
                    const SizedBox(height: 12),
                    _buildSummaryRow('Time Slot', _createdBooking!.timeSlot),
                    const SizedBox(height: 12),
                    _buildSummaryRow('Customer', _createdBooking!.customerName),
                    const SizedBox(height: 12),
                    _buildSummaryRow('Phone', '+${_createdBooking!.customerPhone}'),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Status', _createdBooking!.status.name,
                        valColor: _createdBooking!.status.color),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Manual Bank Transfer Info
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF151824),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFCCFF00).withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFFCCFF00), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Manual Bank Transfer Details',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTransferDetailRow('Bank Name', 'Bank Central Asia (BCA)'),
              const SizedBox(height: 10),
              _buildTransferDetailRow('Account Number', '8720-449-110'),
              const SizedBox(height: 10),
              _buildTransferDetailRow('Account Name', 'PT Courtly Prima Padel'),
              const SizedBox(height: 10),
              _buildTransferDetailRow(
                'Amount to Transfer',
                'Rp ${NumberFormat('#,###').format(_selectedVenue!.pricePerHour)}',
                valueColor: const Color(0xFFCCFF00),
              ),
              const SizedBox(height: 16),
              Text(
                '💡 Transfer the exact amount. Once completed, take a screenshot of your transfer proof and send it via the WhatsApp button below.',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF9EAFBC),
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Action Buttons
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _sendWhatsAppProof,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366), // WA Green
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send_rounded, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Kirim Bukti Pembayaran via WhatsApp',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _resetFlow,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white30,
                ),
                child: Text(
                  'Book Another Court',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    );
  }

  Widget _buildTransferDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12),
        ),
        InkWell(
          onTap: label == 'Account Number'
              ? () {
                  Clipboard.setData(ClipboardData(text: value)).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account number copied to clipboard!'),
                        backgroundColor: Color(0xFF00E5FF),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  });
                }
              : null,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    color: valueColor ?? Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                if (label == 'Account Number') ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.copy_rounded, color: Color(0xFF00E5FF), size: 12),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _sendWhatsAppProof() {
    if (_createdBooking == null) return;
    
    final dateStr = DateFormat('EEEE, d MMM yyyy').format(_createdBooking!.bookingDate);
    final text = 'Halo ${_createdBooking!.venueName}, saya ingin melakukan konfirmasi pembayaran untuk booking lapangan.'
        '\n\n*Detail Booking:*'
        '\n- Kode Booking: *${_createdBooking!.id}*'
        '\n- Lapangan: ${_createdBooking!.courtName}'
        '\n- Jadwal: $dateStr, ${_createdBooking!.timeSlot}'
        '\n- Nama Pemesan: ${_createdBooking!.customerName}'
        '\n\nBerikut saya lampirkan bukti transfer pembayaran.';

    final encodedText = Uri.encodeComponent(text);
    final url = 'https://wa.me/${_createdBooking!.customerPhone}?text=$encodedText';

    // Simulate opening the link in UI
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2230),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        title: Row(
          children: [
            const Icon(Icons.launch_rounded, color: Color(0xFF00E5FF)),
            const SizedBox(width: 8),
            Text(
              'Simulating WhatsApp Link',
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Redirecting customer to WhatsApp API URL:',
              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                url,
                style: GoogleFonts.outfit(
                  color: const Color(0xFFCCFF00),
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Pre-filled Message Content:',
              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                text,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close Demo Link',
              style: GoogleFonts.outfit(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 6;
    const dashSpace = 4;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
