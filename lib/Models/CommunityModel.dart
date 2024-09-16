import 'package:cloud_firestore/cloud_firestore.dart';

class Community {
  final String communityId;
  final String symptomName;
  final String description;
  final List<String> requests;
  final List<String> members;
  final String creatorEmail; // New field for creator's email

  Community({
    required this.communityId,
    required this.symptomName,
    required this.description,
    required this.requests,
    required this.members,
    required this.creatorEmail,
  });

  factory Community.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Community(
      communityId: doc.id,
      symptomName: data['symptomName'] ?? 'Unknown',
      description: data['description'] ?? '',
      requests: List<String>.from(data['requests'] ?? []),
      members: List<String>.from(data['members'] ?? []),
      creatorEmail: data['creatorEmail'] ?? '', // Fetch creatorEmail from Firestore
    );
  }
}
