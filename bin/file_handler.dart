import 'dart:io';
import 'package:archive/archive_io.dart';

class FileHandler {
  late File _file;
  final String fileExtension = 'txt';

  static const String _mountPoint = 'D:\\files';

  File get file => _file;

  FileHandler(String name) {
    _file = File('$_mountPoint\\$name.$fileExtension');
  }

  Future<void> createFile() async {
    final isFileExists = await _file.exists();
    if (isFileExists) {
      print('Ошибка! Такой файл уже есть.');

      return ;
    }

    try {
      await _file.create(recursive: true, exclusive: true);

      print('Файл успешно создан!');
    } catch(e) {
      print('Ошибка: $e');
    }
  }

  Future<void> writeToFile<T>(T content) async {
    final isFileExists = await _file.exists();
    if (!isFileExists) {
      print('Ошибка! Создайте сначала файл.');

      return ;
    }

    try {
      await _file.writeAsString(content as String, mode: FileMode.append);

      print('Запись в файл успешно произведена!');
    } catch(e) {
      print('Ошибка: $e');
    }
  }

  Future<void> printFileContent() async {
    final isFileExists = await _file.exists();
    if (!isFileExists) {
      print('Ошибка! Создайте сначала файл.');

      return ;
    }

    try {
      var content = await _file.readAsString();

      print(content);
    } catch(e) {
      print('Ошибка: $e');
    }

  }
  Future<void> removeFile() async {
    final isFileExists = await _file.exists();
    if (!isFileExists) {
      print('Ошибка! Создайте сначала файл.');

      return ;
    }

    try {
      await _file.delete();
      print('Файл ${_file.path} удален!');
    } catch(e) {
      print('Ошибка: $e');
    }
  }
}