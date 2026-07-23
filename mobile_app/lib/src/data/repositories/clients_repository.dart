import '../db/app_database.dart';

class ClientsRepository {
  const ClientsRepository(this._db);

  final AppDatabase _db;

  Stream<List<Client>> watch({bool includeArchived = false}) {
    return _db.watchClients(includeArchived: includeArchived);
  }

  Future<void> create({
    required String name,
    String? address,
    String? geolocation,
    String? phone,
    String? email,
    String? description,
  }) async {
    await _db.addClient(
      name: name,
      address: address,
      geolocation: geolocation,
      phone: phone,
      email: email,
      description: description,
    );
  }

  Future<void> update(
    Client client, {
    required String name,
    String? address,
    String? geolocation,
    String? phone,
    String? email,
    String? description,
  }) async {
    await _db.updateClient(
      client,
      name: name,
      address: address,
      geolocation: geolocation,
      phone: phone,
      email: email,
      description: description,
    );
  }

  Future<void> archive(int id) async {
    await _db.archiveClient(id);
  }

  Future<void> delete(int id) async {
    await _db.deleteClient(id);
  }

  Future<List<Client>> activeList() => _db.getActiveClients();
}
