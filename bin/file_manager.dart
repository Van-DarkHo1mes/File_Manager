import 'dart:io';
import 'file_handler.dart';
import 'json_handler.dart';
import 'xml_handler.dart';
import 'zip_handler.dart';
import 'person.dart';

final class FileManager {
  FileHandler? fileHandler;
  JsonHandler? jsonHandler;
  XmlHandler? xmlHandler;
  ZipHandler? zipHandler;

  static String getFileParameter() {
    String name;
    do {
      stdout.write('Введите название файла (только буквы): ');
      name = stdin.readLineSync() ?? 'default';
      if (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(name)) {
        print('Ошибка: название должно содержать только буквы.');
      }
    } while (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(name));

    return name;
  }

  static T getFileContent<T>(int condition) {
    late T content;

    switch (condition) {
      case 0:
        stdout.write('Введите данные для записи в файл (только буквы): ');
        String data;
        do {
          data = stdin.readLineSync() ?? 'default';
          if (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(data)) {
            print('Ошибка: данные должны содержать только буквы.');
          }
        } while (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(data));
        content = data as T;
        break;

      case 1:
        String firstName, secondName;
        int age;

        do {
          stdout.write('Введите имя (только буквы): ');
          firstName = stdin.readLineSync() ?? 'default';
          if (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(firstName)) {
            print('Ошибка: имя должно содержать только буквы.');
          }
        } while (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(firstName));

        do {
          stdout.write('Введите фамилию (только буквы): ');
          secondName = stdin.readLineSync() ?? 'default';
          if (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(secondName)) {
            print('Ошибка: фамилия должна содержать только буквы.');
          }
        } while (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(secondName));

        stdout.write('Введите возраст: ');
        age = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

        content = Person(firstName, secondName, age) as T;
        break;

      case 2:
        String elementName, elementContent;

        do {
          stdout.write('Введите имя элемента (только буквы): ');
          elementName = stdin.readLineSync() ?? 'default';
          if (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(elementName)) {
            print('Ошибка: имя элемента должно содержать только буквы.');
          }
        } while (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(elementName));

        stdout.write('Введите содержание элемента: ');
        elementContent = stdin.readLineSync() ?? 'default';

        content = (elementName, elementContent) as T;
        break;
    }

    return content;
  }

  int chooseAction(int maxOption) {
    int action;
    do {
      stdout.write('Введите число от 1 до $maxOption: ');
      var input = stdin.readLineSync();
      action = int.tryParse(input ?? '') ?? -1;
      if (action < 1 || action > maxOption) {
        print('Ошибка: введите число от 1 до $maxOption.');
      }
    } while (action < 1 || action > maxOption);

    return action;
  }

  Future<void> createFile() async {
    var fileName = getFileParameter();
    fileHandler = FileHandler(fileName);
    await fileHandler!.createFile();
  }

  Future<void> createJsonFile() async {
    var fileName = getFileParameter();
    jsonHandler = JsonHandler(fileName);
    await jsonHandler!.createFile();
  }

  Future<void> createXmlFile() async {
    var fileName = getFileParameter();
    xmlHandler = XmlHandler(fileName);
    await xmlHandler!.createFile();
  }

  Future<void> writeToFile<T extends FileHandler>(T? file) async {
    final isFileExists = await file?.file.exists() ?? false;
    if (!isFileExists) {
      print('Создайте сначала файл!');
      return ;
    }

    var condition = 0;
    if (file is JsonHandler) {
      condition = 1;
    } else if (file is XmlHandler) {
      condition = 2;
    }

    var content = getFileContent(condition);
    await file?.writeToFile(content);
  }

  Future<void> printContent<T extends FileHandler>(T? file) async {
    final isFileExists = await file?.file.exists() ?? false;
    if (!isFileExists) {
      print('Создайте сначала файл!');
      return ;
    }

    await file?.printFileContent();
  }

  Future<void> removeFile<T extends FileHandler>(T? file) async {
    final isFileExists = await file?.file.exists() ?? false;
    if (!isFileExists) {
      print('Создайте сначала файл!');
      return ;
    }

    await file?.removeFile();
  }

  Future<void> createZipFile() async {
    if (zipHandler != null) {
      final isZipExists = await File(zipHandler!.path).exists() ?? false;
      if (isZipExists) {
        await closeZip();
      }
    }

    var fileName = getFileParameter();
    zipHandler = ZipHandler(fileName);
  }

  Future<void> writeToZipFile<T extends FileHandler>(T? file) async {
    final isFileExists = await file?.file.exists() ?? false;
    if (!isFileExists) {
      print('Создайте сначала файл!');
      return ;
    }
    if (zipHandler == null) {
      return ;
    }
    final isZipExists = await File(zipHandler!.path).exists() ?? false;
    if (!isZipExists) {
      print('Создайте сначала zip-файл!');
      return ;
    }

    await zipHandler!.addToZip(File(file!.file.path));
  }

  Future<void> closeZip() async {
    if (zipHandler == null) {
      return ;
    }
    final isZipExists = await File(zipHandler!.path).exists() ?? false;
    if (!isZipExists) {
      print('Создайте сначала zip-файл!');
      return ;
    }

    await zipHandler!.closeZip();
  }

  Future<void> printZipFile() async {
    final isZipExists = await File(zipHandler!.path).exists() ?? false;
    if ((!isZipExists) && (zipHandler == null)) {
      print('Создайте сначала zip-файл!');
      return ;
    }

    await zipHandler!.printFileContent();
  }

  Future<void> removeZipFile() async {
    if (zipHandler == null) {
      return ;
    }
    final isZipExists = await File(zipHandler!.path).exists() ?? false;
    if (!isZipExists) {
      print('Создайте сначала zip-файл!');
      return ;
    }

    await zipHandler!.removeFile();
  }

  Future<void> workWithFile() async {
    int action = 0;
    while (action != 6) {
      print('''Выберите действие с файлом:
    1 - Создать файл;
    2 - Записать в файл;
    3 - Прочитать файл;
    4 - Удалить файл;
    5 - Добавить файл в архив;
    6 - Назад;''');
      action = chooseAction(6);

      switch (action) {
        case 1:
          await createFile();
          break;
        case 2:
          await writeToFile(fileHandler);
          break;
        case 3:
          await printContent(fileHandler);
          break;
        case 4:
          await removeFile(fileHandler);
          break;
        case 5:
          await writeToZipFile(fileHandler);
          break;
        case 6:
          break;
        default:
          print('Введите корректное действие от 1 до 6!');
      }
    }
  }

  Future<void> workWithJson() async {
    int action = 0;
    while (action != 6) {
      print('''Выберите действие с JSON-файлом:
    1 - Создать файл;
    2 - Записать в файл;
    3 - Прочитать файл;
    4 - Удалить файл;
    5 - Добавить файл в архив;
    6 - Назад;''');
      action = chooseAction(6);

      switch (action) {
        case 1:
          await createJsonFile();
          break;
        case 2:
          await writeToFile(jsonHandler);
          break;
        case 3:
          await printContent(jsonHandler);
          break;
        case 4:
          await removeFile(jsonHandler);
          break;
        case 5:
          await writeToZipFile(jsonHandler);
          break;
        case 6:
          break;
        default:
          print('Введите корректное действие от 1 до 6!');
      }
    }
  }

  Future<void> workWithXml() async {
    int action = 0;
    while (action != 6) {
      print('''Выберите действие с XML-файлом:
    1 - Создать файл;
    2 - Записать в файл;
    3 - Прочитать файл;
    4 - Удалить файл;
    5 - Добавить файл в архив;
    6 - Назад;''');
      action = chooseAction(6);

      switch (action) {
        case 1:
          await createXmlFile();
          break;
        case 2:
          await writeToFile(xmlHandler);
          break;
        case 3:
          await printContent(xmlHandler);
          break;
        case 4:
          await removeFile(xmlHandler);
          break;
        case 5:
          await writeToZipFile(xmlHandler);
          break;
        case 6:
          break;
        default:
          print('Введите корректное действие от 1 до 6!');
      }
    }
  }

  Future<void> workWithZip() async {
    int action = 0;
    while (action != 4) {
      print('''Выберите действие с zip-файлом:
    1 - Создать файл;
    2 - Разархивировать файл;
    3 - Удалить файл;
    4 - Назад;''');
      action = chooseAction(4);

      switch (action) {
        case 1:
          await createZipFile();
          break;
        case 2:
          await printZipFile();
          break;
        case 3:
          await removeZipFile();
          break;
        case 4:
          break;
        default:
          print('Введите корректное действие от 1 до 4!');
      }
    }
  }
}