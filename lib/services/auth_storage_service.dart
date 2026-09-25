import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_account.dart';

/// Service for managing persistent user accounts and active sessions with Hive
class AuthStorageService {
  static const String usersBoxName = 'users_auth_box';
  static const String sessionBoxName = 'session_auth_box';

  static Box? _usersBox;
  static Box? _sessionBox;
  static bool _isInitialized = false;

  /// Default seed accounts available out of the box
  static final List<UserAccount> defaultSeedAccounts = [
    UserAccount(
      firstName: "Vivek",
      lastName: "Bisht",
      email: "vivek5832017@gmail.com",
      phone: "8171152213",
      countryCode: "+91",
      password: "Password123",
      isVerified: true,
      assessmentScore: 100,
    ),
    UserAccount(
      firstName: "Alex",
      lastName: "Developer",
      email: "demo@11jobs.com",
      phone: "9999999999",
      countryCode: "+1",
      password: "Password123",
      isVerified: true,
      assessmentScore: 100,
    ),
  ];

  /// Initialize Hive and open boxes
  static Future<void> init([String? customPath]) async {
    if (_isInitialized && _usersBox != null && _usersBox!.isOpen) {
      return;
    }

    try {
      if (customPath != null) {
        Hive.init(customPath);
      } else {
        await Hive.initFlutter();
      }
    } catch (e) {
      // Fallback for tests or already initialized Hive instance
      try {
        if (!kIsWeb) {
          Hive.init('.');
        }
      } catch (_) {}
    }

    try {
      _usersBox = await Hive.openBox(usersBoxName);
      _sessionBox = await Hive.openBox(sessionBoxName);
    } catch (e) {
      debugPrint("Hive openBox error: $e");
    }

    _isInitialized = true;
    await seedDefaultUsersIfEmpty();
  }

  /// Seed initial demo/verified accounts if the box has no users
  static Future<void> seedDefaultUsersIfEmpty() async {
    if (_usersBox == null || !_usersBox!.isOpen) return;

    if (_usersBox!.isEmpty) {
      for (final account in defaultSeedAccounts) {
        await saveUser(account);
      }
    }
  }

  /// Get all registered users from Hive
  static List<UserAccount> getAllUsers() {
    if (_usersBox == null || !_usersBox!.isOpen) {
      return List.from(defaultSeedAccounts);
    }

    final users = <UserAccount>[];
    for (var key in _usersBox!.keys) {
      final rawData = _usersBox!.get(key);
      if (rawData is Map) {
        try {
          users.add(UserAccount.fromMap(rawData));
        } catch (e) {
          debugPrint("Error parsing user account: $e");
        }
      }
    }

    if (users.isEmpty) {
      return List.from(defaultSeedAccounts);
    }

    return users;
  }

  /// Save a new user or overwrite an existing account in Hive
  static Future<void> saveUser(UserAccount account) async {
    if (_usersBox == null || !_usersBox!.isOpen) {
      await init();
    }

    final key = _makeKey(account.email, account.phone);
    await _usersBox?.put(key, account.toMap());
  }

  /// Update an existing user in Hive
  static Future<void> updateUser(UserAccount account) async {
    await saveUser(account);
  }

  /// Find user by email (case-insensitive)
  static UserAccount? findUserByEmail(String email) {
    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty) return null;

    final users = getAllUsers();
    for (final u in users) {
      if (u.email.trim().toLowerCase() == cleanEmail) {
        return u;
      }
    }
    return null;
  }

  /// Find user by phone number digits
  static UserAccount? findUserByPhone(String phone) {
    final cleanDigits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanDigits.length < 5) return null;

    final users = getAllUsers();
    for (final u in users) {
      final uDigits = u.phone.replaceAll(RegExp(r'[^0-9]'), '');
      if (uDigits.length >= 5) {
        if (cleanDigits == uDigits) {
          return u;
        }
        if (cleanDigits.length >= 7 && uDigits.length >= 7) {
          if (cleanDigits.endsWith(uDigits) || uDigits.endsWith(cleanDigits)) {
            return u;
          }
        }
      }
    }
    return null;
  }

  /// Check if an email is already registered in Hive
  static bool emailExists(String email) {
    return findUserByEmail(email) != null;
  }

  /// Check if a phone number is already registered in Hive
  static bool phoneExists(String phone) {
    return findUserByPhone(phone) != null;
  }

  /// Save active user session
  static Future<void> saveCurrentSession(UserAccount account) async {
    if (_sessionBox == null || !_sessionBox!.isOpen) {
      await init();
    }
    await _sessionBox?.put('current_user', account.toMap());
  }

  /// Retrieve active user session
  static UserAccount? getCurrentSession() {
    if (_sessionBox == null || !_sessionBox!.isOpen) return null;
    final data = _sessionBox?.get('current_user');
    if (data is Map) {
      try {
        return UserAccount.fromMap(data);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Clear active session (Logout)
  static Future<void> clearSession() async {
    if (_sessionBox != null && _sessionBox!.isOpen) {
      await _sessionBox?.delete('current_user');
    }
  }

  /// Clear all stored data (for tests / reset)
  static Future<void> clearAll() async {
    if (_usersBox != null && _usersBox!.isOpen) {
      await _usersBox?.clear();
    }
    if (_sessionBox != null && _sessionBox!.isOpen) {
      await _sessionBox?.clear();
    }
    await seedDefaultUsersIfEmpty();
  }

  static String _makeKey(String email, String phone) {
    if (email.trim().isNotEmpty) {
      return email.trim().toLowerCase();
    }
    final cleanDigits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return "user_$cleanDigits";
  }
}
