import '../models/first_aid_model.dart';

class FirstAidData {
  static List<FirstAidModel> guides = [
    FirstAidModel(
      title: "Burns",
      content: "Cool the burn under cold running water for at least 10 minutes.",
      doAndDont: "DO: Cover with sterile dressing.\nDON'T: Apply ice directly to the burn.",
    ),
    FirstAidModel(
      title: "Bleeding",
      content: "Apply direct pressure to the wound using a clean cloth.",
      doAndDont: "DO: Keep the injured part elevated.\nDON'T: Remove objects embedded deep.",
    ),
    FirstAidModel(
      title: "CPR",
      content: "Push hard and fast in the center of the chest (100-120 bpm).",
      doAndDont: "DO: Call emergency services first.\nDON'T: Stop until help arrives.",
    ),
  ];
}