final class Person {
  final String firstName;
  final String secondName;
  final int age;

  Person(this.firstName, this.secondName, this.age);

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      json['firstName'],
      json['secondName'],
      json['age'],
    );
  }

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'secondName': secondName,
    'age': age,
  };

  @override
  String toString() {
    return 'Person:\n имя: $firstName\n фамилия: $secondName\n возраст: $age\n';
  }
}