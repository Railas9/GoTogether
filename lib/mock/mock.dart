
import 'package:go_together/models/user.dart';

class Mock {
  static User userGwen = User(
    id:1,
    username:"gwenael95",
    mail:"gwenael.mw@gmail.com",
    role:"ADMIN",
  );

  static User user2 = User(
    id:2,
    username:"gwenael2",
    mail:"gwenael.mw@orange.fr",
    role:"USER",
  );
}
