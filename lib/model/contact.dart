class Contact {
  int id;
  String name, phone, email;

  Contact(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email});

  Map<String, Object?> toMap() {
    var map = <String, Object?>{'name': name, 'phone': phone, 'email': email};
    if (id != 0) {
      map['id'] = id;
    }
    return map;
  }

  static fromMap(Map<String, Object?> map) {
    return Contact(
        id: int.parse(map['id'].toString()),
        name: map['name'].toString(),
        phone: map['phone'].toString(),
        email: map['email'].toString());
  }

  @override
  String toString() {
    return "[Id: $id. Name: $name. Phone: $phone. eMail: $email";
  }
}
