import 'package:xml/xml.dart';
import 'file_handler.dart';

final class XmlHandler extends FileHandler {
  @override
  final String fileExtension = 'xml';

  XmlHandler(super.name);

  @override
  Future<void> createFile() async {
    final isFileExists = await file.exists();
    if (isFileExists) {
      print('Ошибка! Такой файл уже есть.');

      return ;
    }

    try {
      await file.create(recursive: true, exclusive: true);
      await file.writeAsString('''<?xml version="1.0" encoding="UTF-8"?>
<root></root>''');

      print('Файл успешно создан!');
    } catch(e) {
      print('Ошибка: $e');
    }
  }

  @override
  Future<void> writeToFile<T>(T content) async {
    if (content is! (String, String)) {
      throw ArgumentError();
    }

    var elementName = (content as (String, String)).$1;
    var elementContent = (content as (String, String)).$2;

    var xmlDocument = XmlDocument.parse(await file.readAsString());
    var newElement = XmlElement(XmlName(elementName), [], [XmlText(elementContent)]);
    xmlDocument.rootElement.children.add(newElement);

    await super.writeToFile(xmlDocument.toXmlString(pretty: true));
  }
}