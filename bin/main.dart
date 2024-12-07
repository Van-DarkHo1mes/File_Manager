import 'dart:io';
import 'file_manager.dart';
import 'drive_info_manager.dart';

void main(List<String> arguments) async {
  var action = 0;
  var manager = FileManager();

  while (action != 6) {
    print('''Выберите действие или тип файла:
    1 - Файл .txt;
    2 - Файл .json;
    3 - Файл .xml;
    4 - Файл .zip;
    5 - Посмотреть данные о дисках;
    6 - Выход;''');
    stdout.write('Введите число: ');
    action = int.parse(stdin.readLineSync() ?? '5') ;

  switch (action) {
      case 1 : await manager.workWithFile();
      case 2 : await manager.workWithJson();
      case 3 : await manager.workWithXml();
      case 4 : await manager.workWithZip();
      case 5 : await DriveInfoManager.showSystemInfo();
      case 6 :
        await manager.closeZip();
        break;
      default : print('Введите число от 1 до 6!');
    }
  }
}
