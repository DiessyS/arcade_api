import 'package:objectbox/objectbox.dart';

@Entity()
class Teste {
  @Id()
  int id = 0;

  double latitude = 0.0;
  double longitude = 0.0;
  double altitude = 0.0;
}
