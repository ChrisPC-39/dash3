// flutter packages pub run build_runner build --delete-conflicting-outputs
import 'package:hive/hive.dart';

part 'setup.g.dart';

@HiveType(typeId: 0)
class Setup {
  @HiveField(0)
  final String theme;

  @HiveField(1)
  final double textSize;

  @HiveField(2)
  final bool reverse;

  @HiveField(3)
  final bool useEnter;

  @HiveField(4)
  final double boxSize;

  @HiveField(5)
  final bool showIndicator;

  Setup({
    required this.theme,
    required this.textSize,
    required this.reverse,
    required this.useEnter,
    required this.boxSize,
    required this.showIndicator,
  });
}
