import 'package:flutter_test/flutter_test.dart';
import 'package:hquality/storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});

  test('StorageService set and get', () async {
    final storageService = StorageService();
    storageService.set(key: "test_key", obj: {"test": "value"});
    final value = await storageService.get("test_key");
    expect(value, {"test": "value"});
  });

  test('StorageService remove', () async {
    final storageService = StorageService();
    storageService.set(key: "test_key", obj: {"test": "value"});
    storageService.remove(key: "test_key");
    final value = await storageService.get("test_key");
    expect(value, null);
  });
}
