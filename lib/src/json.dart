import 'enum.dart';

Obj deserialize(Map<String, dynamic> map) {
  switch (map['type']) {
    case ObjEnum.Num:
      return Num.fromJson(map);
    case ObjEnum.BigNum:
      return BigNum.fromJson(map);
    case ObjEnum.Op:
      return Op.fromJson(map);
    case ObjEnum.Fun:
      return Fun.fromJson(map);
    case ObjEnum.ParL:
      return ParL();
    case ObjEnum.ParR:
      return ParR();
    default:
      return Undefined.fromJson(map);
  }
}
