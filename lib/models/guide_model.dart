// [TEACHING NOTE]: This is a "Model".
// It acts like a blueprint or a contract.
// It guarantees that every guide we create has a title, description, and link.
class GuideModel {
  final String title;
  final String description; // This text is available OFFLINE
  final String wikiUrl;     // This link requires ONLINE access

  GuideModel({
    required this.title,
    required this.description,
    required this.wikiUrl,
  });
}