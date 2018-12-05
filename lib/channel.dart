import 'package:aqueduct/managed_auth.dart';
import 'package:heroes/controller/register_controller.dart';

import 'controller/heroes_controller.dart';
import 'heroes.dart';
import 'model/user.dart';


/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class HeroesChannel extends ApplicationChannel {

  ManagedContext context;
  AuthServer authServer;

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    final config = HeroConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore
        .fromConnectionInfo(
          config.database.username,
          config.database.password,
          config.database.host,
          config.database.port,
          config.database.databaseName);
    context = ManagedContext(dataModel, persistentStore);

    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);

  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  
  @override
  Controller get entryPoint {
    final router = Router();
    router
      .route("/heroes")
      .link(() => HeroesController(context));
    router
      .route("/heroes/:id")
      .link(()=>HeroesController(context));
    router
      .route("/example")
      .linkFunction((request) async {
        return Response.ok({"key": "value"});
      });
    router
      .route('/register')
      .link(() => RegisterController(context, authServer));
    return router;
  }

}

class HeroConfig extends Configuration {
  HeroConfig(String path) : super.fromFile(File(path));
  DatabaseConfiguration database;
}