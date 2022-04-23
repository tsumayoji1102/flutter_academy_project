class Hospital {
  final String introduction;
  final String name;
  final String contact;
  final String address;
  final String addressNumber;

  Hospital({
    required this.introduction,
    required this.name,
    required this.address,
    required this.contact,
    required this.addressNumber,
  });

  factory Hospital.fromMap(Map<String, dynamic> map) {
    return Hospital(
      introduction: map['説明'] as String,
      name: map['名称']['表記'] as String,
      contact: map['連絡先']['表記'] as String,
      address: map['住所']['表記'] as String,
      addressNumber: map['住所']['郵便番号'] as String,
    );
  }

  @override
  String toString() {
    return super.toString();
  }
}

class Practice {
  final int id;
  final String name;
  final int age;

  Practice({
    required this.id,
    required this.name,
    required this.age,
  });

  factory Practice.fromJson(Map<String, dynamic> json) {
    return Practice(
      name: json['name'] as String,
      id: json['id'] as int,
      age: json['age'] as int,
    );
  }

  void toMap() {
    print('name: $name, id: $id, age: $age');
  }
}
