import 'package:flutter/material.dart';
import '../models/venue.dart';
import '../models/booking.dart';

class BookingProvider with ChangeNotifier {
  final List<Venue> _venues = [
    Venue(
      id: 'apex-padel',
      name: 'Apex Padel Arena',
      location: 'Kuningan, Jakarta Selatan',
      imageUrl: 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=800&auto=format&fit=crop',
      courtCount: 4,
      pricePerHour: 150000,
      description: 'Elite indoor and outdoor padel facility in the heart of Jakarta. Features 4 panoramic courts, premium pro-shop, and a modern lounge area.',
      operationalHours: '06:00 - 22:00',
    ),
    Venue(
      id: 'vantage-padel',
      name: 'Vantage Padel Club',
      location: 'Senayan, Jakarta Pusat',
      imageUrl: 'https://images.unsplash.com/photo-1592919505780-303950717480?w=800&auto=format&fit=crop',
      courtCount: 2,
      pricePerHour: 180000,
      description: 'Exclusive padel club located in the Senayan sports complex. Offering premium glass-walled courts and professional coaching staff.',
      operationalHours: '07:00 - 23:00',
    ),
    Venue(
      id: 'padel-zone',
      name: 'Padel Zone Indonesia',
      location: 'PIK, Jakarta Utara',
      imageUrl: 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=800&auto=format&fit=crop',
      courtCount: 3,
      pricePerHour: 120000,
      description: 'Vibrant seaside padel experience at Pantai Indah Kapuk. Enjoy high-quality outdoor courts with sea breeze, perfect for casual and competitive play.',
      operationalHours: '06:00 - 24:00',
    ),
  ];

  final List<Booking> _bookings = [];

  BookingProvider() {
    // Populate with some mock bookings
    final today = DateTime.now();
    
    _bookings.addAll([
      Booking(
        id: 'PDL-2026-001',
        venueId: 'apex-padel',
        venueName: 'Apex Padel Arena',
        courtName: 'Court A (Indoor)',
        customerName: 'Ahmad Rafiq',
        customerPhone: '6281234567890',
        bookingDate: today,
        timeSlot: '08:00 - 09:00',
        status: BookingStatus.confirmed,
      ),
      Booking(
        id: 'PDL-2026-002',
        venueId: 'apex-padel',
        venueName: 'Apex Padel Arena',
        courtName: 'Court A (Indoor)',
        customerName: 'Budi Santoso',
        customerPhone: '628112223334',
        bookingDate: today,
        timeSlot: '19:00 - 20:00',
        status: BookingStatus.pending,
      ),
      Booking(
        id: 'PDL-2026-003',
        venueId: 'vantage-padel',
        venueName: 'Vantage Padel Club',
        courtName: 'Court 1',
        customerName: 'Citra Kirana',
        customerPhone: '62855667788',
        bookingDate: today,
        timeSlot: '17:00 - 18:00',
        status: BookingStatus.completed,
      ),
      Booking(
        id: 'PDL-2026-004',
        venueId: 'padel-zone',
        venueName: 'Padel Zone Indonesia',
        courtName: 'VIP Glass Court',
        customerName: 'Daniel Wijaya',
        customerPhone: '62877889900',
        bookingDate: today.add(const Duration(days: 1)),
        timeSlot: '20:00 - 21:00',
        status: BookingStatus.confirmed,
      ),
    ]);
  }

  List<Venue> get venues => _venues;
  List<Booking> get bookings => _bookings;

  List<String> getCourtsForVenue(String venueId) {
    if (venueId == 'apex-padel') {
      return ['Court A (Indoor)', 'Court B (Indoor)', 'Court C (Outdoor)', 'Court D (Outdoor)'];
    } else if (venueId == 'vantage-padel') {
      return ['Court 1', 'Court 2'];
    } else if (venueId == 'padel-zone') {
      return ['Standard Court A', 'Standard Court B', 'VIP Glass Court'];
    }
    return ['Court 1'];
  }

  List<String> getAvailableTimeSlotsForVenue(String venueId) {
    int startHour = 6;
    int endHour = 22;
    if (venueId == 'apex-padel') {
      startHour = 6; endHour = 22;
    } else if (venueId == 'vantage-padel') {
      startHour = 7; endHour = 23;
    } else if (venueId == 'padel-zone') {
      startHour = 6; endHour = 24;
    }

    final List<String> slots = [];
    for (int i = startHour; i < endHour; i++) {
      final startStr = i.toString().padLeft(2, '0') + ':00';
      final endStr = (i + 1).toString().padLeft(2, '0') + ':00';
      slots.add('$startStr - $endStr');
    }
    return slots;
  }

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void updateBookingStatus(String id, BookingStatus status) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index].status = status;
      notifyListeners();
    }
  }

  bool isSlotBooked(String venueId, String courtName, DateTime date, String slot) {
    return _bookings.any((b) =>
        b.venueId == venueId &&
        b.courtName == courtName &&
        b.bookingDate.year == date.year &&
        b.bookingDate.month == date.month &&
        b.bookingDate.day == date.day &&
        b.timeSlot == slot &&
        b.status != BookingStatus.cancelled);
  }
}
