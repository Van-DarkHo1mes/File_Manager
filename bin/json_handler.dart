import 'dart:convert';
import 'file_handler.dart';
import 'person.dart';

class JsonHandler extends FileHandler {
  @override
  final String fileExtension = 'json';

  JsonHandler(super.name);

  @override
  Future<void> writeToFile<T>(T content) async {
    if (content is! Person) {
      throw ArgumentError();
    }

    String jsonString = '${jsonEncode((content as Person).toJson())}\n';

    await super.writeToFile(jsonString);
  }

  @override
  Future<void> printFileContent() async {
    final isFileExists = await file.exists();
    if (!isFileExists) {
      print('Ошибка! Создайте сначала файл.');

      return ;
    }

    final content = await file.readAsString();
    final listString = content.toString().split('\n');

    listString.removeLast();

    final List<Person> listPersons = [];
    for (var element in listString) {
      listPersons.add(Person.fromJson(jsonDecode(element)));
    }

    print('Данные файла:\n');
    for (var person in listPersons) {
      print(person.toString());
    }
  }
}