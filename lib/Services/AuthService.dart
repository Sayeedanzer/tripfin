import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'ApiClient.dart';
import 'api_endpoint_urls.dart';

class AuthService {
  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";
  static const String _tokenExpiryKey = "token_expiry";


  static Future<bool> get isGuest async {
    final token = await getAccessToken();
    return token == null || token.isEmpty;
  }


  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }
  /// Check if token is expired
  static Future<bool> isTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTimestamp = prefs.getInt(_tokenExpiryKey);
    if (expiryTimestamp == null) {
      debugPrint('No expiry timestamp found, considering token expired');
      return true;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    final isExpired = now >= (expiryTimestamp);
    debugPrint('Token expiry check: now=$now, expiry=$expiryTimestamp, isExpired=$isExpired');
    return isExpired;
  }

  /// Save tokens and expiry time
  static Future<void> saveTokens(String accessToken, String refreshToken, int expiresIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setInt(_tokenExpiryKey, expiresIn);
    debugPrint('Tokens saved: accessToken=$accessToken, expiryTime=$expiresIn');
  }

  /// Refresh token
  static Future<bool> refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      debugPrint('❌ No refresh token available');
      return false;
    }
    try {
      final response = await ApiClient.post(
        APIEndpointUrls.refreshtoken,
        data: {"refresh": refreshToken},
      );
      if (response.statusCode == 200) {
        final tokenData = response.data["data"];
        final newAccessToken = tokenData["access"];
        final newRefreshToken = tokenData["refresh"];
        final expiryTime = tokenData["expiry_time"];

        if (newAccessToken == null || newRefreshToken == null || expiryTime == null) {
          debugPrint("❌ Missing token data in response: $tokenData");
          return false;
        }
        // Save the tokens with expiryTime (assuming expiry_time is in milliseconds)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_accessTokenKey, newAccessToken);
        await prefs.setString(_refreshTokenKey, newRefreshToken);
        await prefs.setInt(_tokenExpiryKey, expiryTime);
        debugPrint("✅ Token refreshed and saved successfully");
        return true;
      } else {
        debugPrint("❌ Refresh token request failed with status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Token refresh failed: $e");
      return false;
    }
  }

  /// Logout and clear tokens, redirect to sign-in screen
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_tokenExpiryKey);
    debugPrint('Tokens cleared, user logged out');
    if (navigatorKey.currentContext != null) {
      navigatorKey.currentContext!.go('/login_mobile');
    } else {
      debugPrint('⚠️ Navigator context is null, scheduling navigation...');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (navigatorKey.currentContext != null) {
          navigatorKey.currentContext!.go('/login_mobile');
        }
      });
    }
  }
}
