abstract class LocalStorage {
  Future<void> saveUser(Map<String, dynamic> userData);
  Future<Map<String, dynamic>?> getUser(String email);
  Future<void> updateUser(String email, Map<String, dynamic> userData);
  Future<void> deleteUser(String email);
}