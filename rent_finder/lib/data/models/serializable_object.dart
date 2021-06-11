abstract class SerializableObject {
  SerializableObject();
  SerializableObject.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}
