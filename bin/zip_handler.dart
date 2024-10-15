import 'dart:io';
import 'package:archive/archive_io.dart';

final class ZipHandler {
  late ZipFileEncoder _encoder;
  bool _isClosed = true;

  static const String _fileExtension = 'zip';
  static const String _mountPoint = 'D:\\files';

  String get path => _encoder.zipPath;

  ZipHandler(String name) {
    _encoder = ZipFileEncoder()
      ..create('$_mountPoint\\$name.$_fileExtension');

    _isClosed = false;
  }

  Future<void> addToZip(File file) async {
    var isFileExists = await File(_encoder.zipPath).exists();
    if (!isFileExists) {
      print('Ошибка! Создайте сначала zip-файл.');

      return ;
    }

    isFileExists = await file.exists();
    if (!isFileExists) {
      print('Ошибка! Создайте сначала файл.');

      return ;
    }

    await _encoder.addFile(file);

    print('Файл успешно добавлен в архив: ${file.path}');
  }

  Future<void> closeZip() async {
    final isFileExists = await File(_encoder.zipPath).exists();
    if ((isFileExists) && (_isClosed == false)) {
      await _encoder.close();
      _isClosed = true;
    }
  }

  Future<void> printFileContent() async {
    final isFileExists = await File(_encoder.zipPath).exists();
    if (!isFileExists) {
      print('Ошибка! Создайте сначала zip-файл.');

      return ;
    }

    await closeZip();

    List<int> bytes = await File(_encoder.zipPath).readAsBytes();
    Archive archive = ZipDecoder().decodeBytes(bytes);

    for (ArchiveFile file in archive) {
      print('Файл в архиве: ${file.name}');
      print('Размер файла: ${file.size} байт');

      File extractedFile = File('$_mountPoint\\extracted_${file.name}');
      await extractedFile.writeAsBytes(file.content as List<int>);
      print('Файл ${file.name} успешно извлечён и сохранён как ${extractedFile.path}');
    }

    await removeFile();
  }

  Future<void> removeFile() async {
    final isFileExists = await File(_encoder.zipPath).exists();
    if (!isFileExists) {
      print('Ошибка! Создайте сначала zip-файл.');

      return ;
    }

    try {
      await closeZip();
      await File(_encoder.zipPath).delete();
      print('Zip-файл ${_encoder.zipPath} удален!');
    } catch(e) {
      print('Ошибка: $e');
    }
  }
}

