import 'package:stormberry/internals.dart';

import 'db_models.dart';

extension Repositories on Database {
  UserRepository get users => UserRepository._(this);
}

final registry = ModelRegistry({});

abstract class UserRepository
    implements
        ModelRepository,
        KeyedModelRepositoryInsert<UserInsertRequest>,
        ModelRepositoryUpdate<UserUpdateRequest>,
        ModelRepositoryDelete<int> {
  factory UserRepository._(Database db) = _UserRepository;

  Future<User?> queryUser(int id);
  Future<List<User>> queryUsers([QueryParams? params]);
}

class _UserRepository extends BaseRepository
    with
        KeyedRepositoryInsertMixin<UserInsertRequest>,
        RepositoryUpdateMixin<UserUpdateRequest>,
        RepositoryDeleteMixin<int>
    implements UserRepository {
  _UserRepository(Database db) : super(db: db);

  @override
  Future<User?> queryUser(int id) {
    return queryOne(id, UserQueryable());
  }

  @override
  Future<List<User>> queryUsers([QueryParams? params]) {
    return queryMany(UserQueryable(), params);
  }

  @override
  Future<List<int>> insert(
      Database db, List<UserInsertRequest> requests) async {
    if (requests.isEmpty) return [];
    var rows = await db.query(requests
        .map((r) => "SELECT nextval('users_id_seq') as \"id\"")
        .join('\nUNION ALL\n'));
    var autoIncrements = rows.map((r) => r.toColumnMap()).toList();

    await db.query(
      'INSERT INTO "users" ( "id", "name", "email", "phone_number", "created_date" )\n'
      'VALUES ${requests.map((r) => '( ${registry.encode(autoIncrements[requests.indexOf(r)]['id'])}, ${registry.encode(r.name)}, ${registry.encode(r.email)}, ${registry.encode(r.phoneNumber)}, ${registry.encode(r.createdDate)} )').join(', ')}\n',
    );

    return autoIncrements.map<int>((m) => registry.decode(m['id'])).toList();
  }

  @override
  Future<void> update(Database db, List<UserUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    await db.query(
      'UPDATE "users"\n'
      'SET "name" = COALESCE(UPDATED."name"::text, "users"."name"), "email" = COALESCE(UPDATED."email"::text, "users"."email"), "phone_number" = COALESCE(UPDATED."phone_number"::text, "users"."phone_number"), "created_date" = COALESCE(UPDATED."created_date"::timestamp, "users"."created_date")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${registry.encode(r.id)}, ${registry.encode(r.name)}, ${registry.encode(r.email)}, ${registry.encode(r.phoneNumber)}, ${registry.encode(r.createdDate)} )').join(', ')} )\n'
      'AS UPDATED("id", "name", "email", "phone_number", "created_date")\n'
      'WHERE "users"."id" = UPDATED."id"',
    );
  }

  @override
  Future<void> delete(Database db, List<int> keys) async {
    if (keys.isEmpty) return;
    await db.query(
      'DELETE FROM "users"\n'
      'WHERE "users"."id" IN ( ${keys.map((k) => registry.encode(k)).join(',')} )',
    );
  }
}

class UserInsertRequest {
  UserInsertRequest(
      {required this.name,
      required this.email,
      required this.phoneNumber,
      required this.createdDate});
  String name;
  String email;
  String phoneNumber;
  DateTime createdDate;
}

class UserUpdateRequest {
  UserUpdateRequest(
      {required this.id,
      this.name,
      this.email,
      this.phoneNumber,
      this.createdDate});
  int id;
  String? name;
  String? email;
  String? phoneNumber;
  DateTime? createdDate;
}

class UserQueryable extends KeyedViewQueryable<User, int> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(int key) => registry.encode(key);

  @override
  String get tableName => 'users_view';

  @override
  String get tableAlias => 'users';

  @override
  User decode(TypedMap map) => UserView(
      id: map.get('id', registry.decode),
      name: map.get('name', registry.decode),
      email: map.get('email', registry.decode),
      phoneNumber: map.get('phone_number', registry.decode),
      createdDate: map.get('created_date', registry.decode));
}

class UserView implements User {
  UserView(
      {required this.id,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.createdDate});

  @override
  final int id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String phoneNumber;
  @override
  final DateTime createdDate;
}
