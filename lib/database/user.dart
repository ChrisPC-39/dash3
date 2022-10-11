// flutter packages pub run build_runner build --delete-conflicting-outputs
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class User {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int color;

  User({
    required this.name,
    required this.color,
  });
}
