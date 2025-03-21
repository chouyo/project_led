import 'package:hive/hive.dart';

import 'constants.dart';

class SpeedAdapter extends TypeAdapter<ESpeed> {
  @override
  final int typeId = 2; // Use a different typeId than Led

  @override
  ESpeed read(BinaryReader reader) {
    return ESpeed.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, ESpeed obj) {
    writer.writeInt(obj.index);
  }
}
