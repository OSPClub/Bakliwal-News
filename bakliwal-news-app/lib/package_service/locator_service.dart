import 'package:get_it/get_it.dart';

import 'package:bakliwal_news_app/repository/auth_repo.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<AuthRepo>(AuthRepo());
}
