import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../util/user_details.dart';
import '../bottom_bar/bottom_bar_screen.dart';

class BiometricsPasswordScreen extends StatefulWidget {
  const BiometricsPasswordScreen({Key? key}) : super(key: key);

  @override
  State<BiometricsPasswordScreen> createState() => _BiometricsPasswordScreenState();
}

class _BiometricsPasswordScreenState extends State<BiometricsPasswordScreen> {

  final UserDetails _userDetails = UserDetails();
  bool? biometricsSecurity;
  final LocalAuthentication auth = LocalAuthentication();

  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBiometrics().then((value) {
      print(" biometricsSecurity 2     ${biometricsSecurity}");
      biometricsSecurity == true ? _checkBiometrics() : null;
    });
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
      _canCheckBiometrics == true ? _authenticateWithBiometrics( ) : null;
    });
  }
  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
        'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
      // print(object);
    } on PlatformException catch (e) {
      print("Authenticating    = = = ${e}");
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }
    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    if(message == "Authorized") {
      Get.offAll(()=>BottomBarScreen());
    }else{
    }
    print(" message   == ${message}");
    setState(() {
      _authorized = message;
    });
  }


  Future<void> getBiometrics() async {
    biometricsSecurity = await _userDetails.getBoolean(title: "biometricSecurity") ;
    print("biometricsSecurity  ===   ${biometricsSecurity}");
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}
enum _SupportState {
  unknown,
  supported,
  unsupported,
}

