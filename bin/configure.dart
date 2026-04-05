import 'dart:io';
import 'dart:isolate';
import 'package:yaml/yaml.dart';

void _log(String msg)  => print('  $msg');
void _step(String msg) => print('\n[$msg]');
void _ok(String msg)   => print('  ✅ $msg');
void _warn(String msg) => print('  ⚠️  $msg');

void main() async {

  print('━━━━━━━━━━━━━━');
  print('  Deprecated  ');
  print('━━━━━━━━━━━━━━');
  _step('Android');
  _log("Build process will always check for latest version, if available will be downloaded");
  _step('iOS');
  _log("run `pod update EdfaPgSdk` terminal command in `./ios` directory to update the pod");
  _log("  - Check for the latest version at https://cocoapods.org/pods/EdfaPgSdk");
  
  return;

  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('  Configuring Edfapay Payment Gateway Native'  );
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  // Locate plugin root
  _step('Resolving plugin root');
  final pluginUri = await Isolate.resolvePackageUri(
    Uri.parse('package:edfapg_sdk/edfapg_sdk.dart'),
  );

  if (pluginUri == null) {
    throw Exception('Could not resolve edfapg_sdk package root');
  }

  final pluginRoot = Directory(pluginUri.toFilePath())
      .parent  // lib
      .parent
      .path; // plugin root

  _log('Plugin root: $pluginRoot');

  // Read consumer pubspec
  _step('Reading pubspec.yaml');
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    throw Exception(
      'pubspec.yaml not found. Run this from your project root: dart run edfapg_sdk:configure',
    );
  }

  final pubspec = loadYaml(pubspecFile.readAsStringSync());
  _log('Project: ${pubspec['name']} v${pubspec['version']}');

  final native = pubspec['edfapay_properties'];
  if (native == null) {
    _warn('edfapay_properties not found in pubspec.yaml — native versions cannot be overridden');
  }

  // ANDROID
  _step('Configuring Android');
  final androidVersion = native?['pg_android'];
  if (androidVersion == null) {
    _warn('"edfapay_properties.pg_android" not found — skipping android version override');
  } else {
    final androidFile = File('$pluginRoot/android/edfapay_properties.properties');
    androidFile.parent.createSync(recursive: true);
    androidFile.writeAsStringSync('EDFAPG_SDK_VERSION=$androidVersion\n');
    _ok('Android native SDK version set to $androidVersion');
  }

  // IOS
  _step('Configuring iOS');
  final iosVersion = native?['pg_ios'];
  if (iosVersion == null) {
    _warn('"edfapay_properties.pg_ios" not found — skipping iOS version override');
  } else {
    final iosFile = File('$pluginRoot/ios/edfapay_properties.rb');
    iosFile.parent.createSync(recursive: true);
    iosFile.writeAsStringSync("EDFAPG_SDK_VERSION = '$iosVersion'\n");
    _ok('iOS native SDK version set to $iosVersion');
  }

  // Run platform cache-clear script
  _step('Clearing Native Cache');
  final binDir = '$pluginRoot/bin';
  ProcessResult result;
  if (Platform.isWindows) {
    result = await Process.run('cmd', ['/c', '$binDir\\win_clear_cache.bat'], runInShell: true);
  } else if (Platform.isMacOS) {
    result = await Process.run('bash', ['$binDir/mac_clear_cache.sh'], runInShell: true);
  } else if (Platform.isLinux) {
    result = await Process.run('bash', ['$binDir/linux_clear_cache.sh'], runInShell: true);
  } else {
    _warn('Unsupported platform — skipping cache clear');
    result = ProcessResult(0, 0, '', '');
  }

  if ((result.stdout as String).isNotEmpty){
    var logs_success = result.stdout.toString().split("\n").map((str)=> " $str");
    logs_success.forEach((l){
      _ok(l);
    });
  }

  if ((result.stderr as String).isNotEmpty) {
    var logs_error = result.stdout.toString().split("\n").map((str) => " $str");
    logs_error.forEach((l){
      _warn(l);
    });
  }

  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('  ✅ Successfully Configured'  );
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
}
