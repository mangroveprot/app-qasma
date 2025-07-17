abstract class DbModel<T> {
  Map<String, dynamic> toDb();
  T fromDb(Map<String, dynamic> map);
  int get id;
}
