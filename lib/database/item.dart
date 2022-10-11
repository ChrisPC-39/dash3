// flutter packages pub run build_runner build --delete-conflicting-outputs
import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 1)
class Item {
  @HiveField(0)
  final String content;

  @HiveField(1)
  final bool isSelected;

  @HiveField(2)
  final bool isEditing;

  Item({
    required this.content,
    required this.isEditing,
    required this.isSelected,
  });
}
