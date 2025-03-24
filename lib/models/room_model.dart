class Room {
  final String id;
  final String name;
  final int online;
  final List<String> tags;
  final bool active;

  Room({
    required this.id,
    required this.name,
    required this.online,
    required this.tags,
    required this.active,
  });

  // Mock data for rooms
  static List<Room> getMockRooms() {
    return [
      Room(
        id: '1',
        name: 'Math Study Group',
        online: 24,
        tags: ['Calculus', 'Algebra'],
        active: true,
      ),
      Room(
        id: '2',
        name: 'Physics Lab',
        online: 12,
        tags: ['Mechanics', 'Electricity'],
        active: true,
      ),
      Room(
        id: '3',
        name: 'Computer Science',
        online: 18,
        tags: ['Programming', 'Algorithms'],
        active: true,
      ),
      Room(
        id: '4',
        name: 'Literature Club',
        online: 7,
        tags: ['Fiction', 'Poetry'],
        active: true,
      ),
      Room(
        id: '5',
        name: 'Chemistry Lab',
        online: 15,
        tags: ['Organic', 'Inorganic'],
        active: true,
      ),
      Room(
        id: '6',
        name: 'History Discussion',
        online: 9,
        tags: ['World War', 'Ancient'],
        active: false,
      ),
      Room(
        id: '7',
        name: 'Art Studio',
        online: 11,
        tags: ['Painting', 'Sculpture'],
        active: true,
      ),
      Room(
        id: '8',
        name: 'Language Exchange',
        online: 22,
        tags: ['Spanish', 'French', 'German'],
        active: true,
      ),
      Room(
        id: '9',
        name: 'Biology Research',
        online: 14,
        tags: ['Genetics', 'Ecology'],
        active: true,
      ),
      Room(
        id: '10',
        name: 'Economics Forum',
        online: 8,
        tags: ['Microeconomics', 'Macroeconomics'],
        active: true,
      ),
      Room(
        id: '11',
        name: 'Psychology Group',
        online: 19,
        tags: ['Clinical', 'Cognitive'],
        active: true,
      ),
      Room(
        id: '12',
        name: 'Music Theory',
        online: 6,
        tags: ['Harmony', 'Composition'],
        active: false,
      ),
    ];
  }
}