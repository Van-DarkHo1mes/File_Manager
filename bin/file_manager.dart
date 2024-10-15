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
    stdout.write('Введите название файла: ');
    String name = stdin.readLineSync() ?? 'default';

    return name;
  }

  static T getFileContent<T>(int condition) {
    late T content;

    stdout.write('Введите данные для записи в файл: ');
    switch (condition) {
      case 0:
        content = (stdin.readLineSync() ?? 'default') as T;
      case 1:
        stdout.write('Введите имя: ');
        var firstName = stdin.readLineSync() ?? 'default';
        stdout.write('Введите фамилию: ');
        var secondName = stdin.readLineSync() ?? 'default';
        stdout.write('Введите возраст: ');
        var age = int.parse(stdin.readLineSync() ?? '0');
        content = Person(firstName, secondName, age) as T;
      case 2:
        stdout.write('Введите имя элемента: ');
        var elementName = stdin.readLineSync() ?? 'default';
        stdout.write('Введите содержание элемента: ');
        var elementContent = stdin.readLineSync() ?? 'default';
        content = (elementName, elementContent) as T;
    }


    return content;
  }

  int chooseAction() {
    var action = 0;

    print('''Выберите действие с файлом:
  1 - Создать файл;
  2 - Записать в файл;
  3 - Прочитать файл;
  4 - Удалить файл;
  5 - Добавить файл в архив;
  6 - Назад;''');
    stdout.write('Введите число: ');
    action = int.parse(stdin.readLineSync() ?? '6') ;

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
  var action = 0;
  while (action != 6) {
    action = chooseAction();

    switch (action) {
      case 1: await createFile();
      case 2: await writeToFile(fileHandler);
      case 3: await printContent(fileHandler);
      case 4: await removeFile(fileHandler);
      case 5: await writeToZipFile(fileHandler);
      case 6: break;
      default: print('Введите число от 1 до 6!');
    }
  }
  }

  Future<void> workWithJson() async {
    var action = 0;

    while (action != 6) {
      action = chooseAction();

      switch (action) {
        case 1: await createJsonFile();
        case 2: await writeToFile(jsonHandler);
        case 3: await printContent(jsonHandler);
        case 4: await removeFile(jsonHandler);
        case 5: await writeToZipFile(jsonHandler);
        case 6: break;
        default: print('Введите число от 1 до 6!');
      }
    }
  }

  Future<void> workWithXml() async {
    var action = 0;

    while (action != 6) {
      action = chooseAction();

      switch (action) {
        case 1: await createXmlFile();
        case 2: await writeToFile(xmlHandler);
        case 3: await printContent(xmlHandler);
        case 4: await removeFile(xmlHandler);
        case 5: await writeToZipFile(xmlHandler);
        case 6: break;
        default: print('Введите число от 1 до 6!');
      }
    }
  }

  Future<void> workWithZip() async {
    var action = 0;

    while (action != 4) {
      print('''Выберите действие с zip-файлом:
    1 - Создать файл;
    2 - Разархивировать файл;
    3 - Удалить файл;
    4 - Назад;''');
      stdout.write('Введите число: ');
      action = int.parse(stdin.readLineSync() ?? '4') ;

      switch (action) {
        case 1: await createZipFile();
        case 2: await printZipFile();
        case 3: await removeZipFile();
        case 4: break;
        default: print('Введите число от 1 до 4!');
      }
    }
  }
}