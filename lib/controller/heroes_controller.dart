import 'dart:async';
import 'package:aqueduct/aqueduct.dart' as aq;
import 'package:heroes/heroes.dart';
import 'package:heroes/model/hero.dart';


class HeroesController extends aq.ResourceController {

  HeroesController(this.context);

  final aq.ManagedContext context;


  @aq.Operation.get()
  Future<aq.Response> getAllHeroes({@aq.Bind.query("name") String name}) async {
    final heroQuery = aq.Query<Hero>(context);
    if(name != null) {
      heroQuery.where((h) => h.name).contains(name, caseSensitive: false);
    }
    final heroes = await heroQuery.fetch();
    return aq.Response.ok(heroes);
  }

  @aq.Operation.get('id')
  Future<aq.Response> getHeroByID(@aq.Bind.path("id") int id) async {
      final heroQuery = Query<Hero>(context)
        ..where((h) => h.id).equalTo(id);    
      final hero = await heroQuery.fetchOne();
      if(hero == null) {
        return aq.Response.notFound();
      }
      return aq.Response.ok(hero);
  }

  @aq.Operation.post() 
  Future<aq.Response> createHero() async {
    final Map<String,dynamic> body = await request.body.decode();
    final query = Query<Hero>(context)
            ..values.name = body["name"] as String;
    final insertedHero = await query.insert();
    return Response.ok(insertedHero);
  }
}