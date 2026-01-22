import '../models/guide_model.dart';

// [TEACHING NOTE]: This is our "Data Source".
// Usually, this data comes from a server (API).
// Since we are building an Offline-First app, we hardcode it here
// so it is always available, even without internet.
class GuideData {
  static List<GuideModel> disasterGuides = [
    GuideModel(
      title: "Earthquake",
      description: "Drop, Cover, and Hold On. Stay away from windows. If outdoors, move to an open area away from buildings and trees.",
      wikiUrl: "https://en.wikipedia.org/wiki/Earthquake_preparedness",
    ),
    GuideModel(
      title: "Flood",
      description: "Move to higher ground immediately. Do not walk or drive through flowing water (6 inches can knock you down). Turn off utilities.",
      wikiUrl: "https://en.wikipedia.org/wiki/Flood_control",
    ),
    GuideModel(
      title: "Fire",
      description: "Stay low to avoid smoke. Touch doors with the back of your hand before opening. If clothes catch fire: Stop, Drop, and Roll.",
      wikiUrl: "https://en.wikipedia.org/wiki/Fire_safety",
    ),
    GuideModel(
      title: "Cyclone",
      description: "Secure loose items outside. Board up windows. Listen to battery-operated radio. Stay indoors in the strongest part of the house.",
      wikiUrl: "https://en.wikipedia.org/wiki/Tropical_cyclone_preparedness",
    ),
    GuideModel(
      title: "Medical Emergency",
      description: "Check for danger, response, breathing, and pulse. Call for help immediately. Administer CPR if trained and necessary.",
      wikiUrl: "https://en.wikipedia.org/wiki/First_aid",
    ),
  ];
}