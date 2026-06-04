class Venue {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final int courtCount;
  final double pricePerHour;
  final String description;
  final String operationalHours;

  Venue({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.courtCount,
    required this.pricePerHour,
    required this.description,
    required this.operationalHours,
  });
}
