import 'package:flutter_test/flutter_test.dart';
import 'package:hquality/storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});

  test('StorageService clear', () async {
    final storageService = StorageService();
    storageService.set(key: "test_key", obj: {"test": "value"});
    storageService.set(key: "test_key2", obj: {"test2": "value2"});
    storageService.set(key: "test_key3", obj: {"test2": "value3"});
    storageService.clear();
    final value = await storageService.get("test_key");
    expect(value, null);
    final value2 = await storageService.get("test_key2");
    expect(value2, null);
    final value3 = await storageService.get("test_key3");
    expect(value3, null);
  });
  
  test('StorageService remove', () async {
    final storageService = StorageService();
    storageService.set(key: "test_key", obj: {"test": "value"});
    storageService.remove(key: "test_key");
    final value = await storageService.get("test_key");
    expect(value, null);
  });

  test('StorageService set and get', () async {
    final storageService = StorageService();
    storageService.set(key: "test_key", obj: {"test": "value"});
    final value = await storageService.get("test_key");
    expect(value, {"test": "value"});
  });

}
