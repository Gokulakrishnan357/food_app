import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AmdStorage {
  final storage = EncryptedSharedPreferences();

  // Save data as a String (convert any value to String before saving)
  Future<void> createCache(String key, dynamic value) async {
    String stringValue = value.toString();
    print("Saving to cache: Key = $key, Value = $stringValue"); // Debug log
    await storage.setString(key, stringValue);
  }

  // Read data and ensure it's returned as a String
  Future<String?> readCache(String key) async {
    var readdata = await storage.getString(key);
    print("Reading from cache: Key = $key, Retrieved Value = $readdata");
    return readdata;
  }

  // Remove a specific cache entry
  Future<void> removeCache(String key) async {
    print("Removing cache for Key = $key");
    await storage.remove(key);
  }

  // Clear all EncryptedSharedPreferences storage
  Future<bool> clearAll() async {
    print("Clearing all encrypted storage");
    return await storage.clear();
  }

  // Clear all SharedPreferences storage
  Future<void> clearCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Clearing all shared preferences");
    await prefs.clear();
  }

  // Save onboarding and login state
  Future<void> saveUserState(bool hasSeenOnboarding, bool isLoggedIn) async {
    await createCache('hasSeenOnboarding', hasSeenOnboarding);
    await createCache('isLoggedIn', isLoggedIn);
  }

  // Retrieve onboarding and login state
  Future<Map<String, bool>> getUserState() async {
    String? seenOnboardingStr = await readCache('hasSeenOnboarding');
    String? loggedInStr = await readCache('isLoggedIn');

    bool hasSeenOnboarding = seenOnboardingStr == 'true';
    bool isLoggedIn = loggedInStr == 'true';

    return {
      'hasSeenOnboarding': hasSeenOnboarding,
      'isLoggedIn': isLoggedIn,
    };
  }
}

