import 'flavors.dart';

import 'main.dart' as runner;

Future<void> main() async {
  FlavorConfig.appFlavor = Flavor.preproduction;
  await runner.main();
}
