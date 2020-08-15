class Dog {

  final int id;
  final String name;
  final int age;

  Dog({this.id, this.age, this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name' : name,
      'age': age
    };
  }

  @override
  String toString() {
    return 'Dog {id: $id, name: $name, age: $age}';
  }
}