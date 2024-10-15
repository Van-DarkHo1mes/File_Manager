import 'dart:async';
import 'dart:convert';
import 'dart:io';

final class DriveInfoManager {
  static Future<void> showSystemInfo() async {
    final drivesInfo = await getDrivesOnWindows();
    drivesInfo.forEach(print);
  }

  static Future<List<String>> getDrivesOnWindows() async {
    final result = await Process.run('wmic', [
      'logicaldisk',
      'get',
      'caption,filesystem,freespace,size,volumename'
    ], stdoutEncoding: const SystemEncoding());

    final output = result.stdout as String;

    final lines = LineSplitter.split(output)
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    if (lines.length < 2) {
      return ['No logical disks found'];
    }

    final headers = lines.first.split(RegExp(r'\s+')).map((h) => h.trim());
    final drivesData = lines.skip(1).map((line) {
      final driveInfo = line.split(RegExp(r'\s+')).map((info) => info.trim()).toList();
      final driveMap = <String, String>{};

      for (var i = 0; i < headers.length && i < driveInfo.length; i++) {
        driveMap[headers.elementAt(i)] = driveInfo[i];
      }

      return formatDriveInfo(driveMap);
    }).toList();

    return drivesData;
  }

  static String formatDriveInfo(Map<String, String> driveInfo) {
    final caption = driveInfo['Caption'] ?? 'Unknown';
    final volumeName = driveInfo['VolumeName'] ?? 'Unknown';
    final fileSystem = driveInfo['FileSystem'] ?? 'Unknown';
    final freeSpace = driveInfo['FreeSpace'] ?? 'Unknown';
    final size = driveInfo['Size'] ?? 'Unknown';

    return '''
Диск: $caption
Метка тома: $volumeName
Файловая система: $fileSystem
Свободное место: ${formatBytes(freeSpace)}
Общий размер: ${formatBytes(size)}
''';
  }

  static String formatBytes(String? bytes) {
    if (bytes == null || bytes.isEmpty || bytes == 'Unknown') return 'Unknown';
    final num size = int.tryParse(bytes) ?? 0;

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = 0;
    var adjustedSize = size.toDouble();

    while (adjustedSize >= 1024 && i < suffixes.length - 1) {
      adjustedSize /= 1024;
      i++;
    }
    return '${adjustedSize.toStringAsFixed(2)} ${suffixes[i]}';
  }
}
