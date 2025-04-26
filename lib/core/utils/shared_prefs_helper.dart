import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _isLoggedInKey = "isLoggedIn";
  static const String _lastDeviceAddressKey = "last_bluetooth_device_address";

  // Save login state
  Future<void> setUserLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  // Get login state
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false; // Default to false if not set
  }

  // Clear login state
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
  }

  // Save the last connected Bluetooth device address
  Future<void> saveLastBluetoothDevice(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastDeviceAddressKey, address);
  }

  // Get the last connected Bluetooth device address
  Future<String?> getLastBluetoothDevice() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastDeviceAddressKey);
  }

  // Clear the saved Bluetooth device
  Future<void> clearSavedBluetoothDevice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastDeviceAddressKey);
  }
}
