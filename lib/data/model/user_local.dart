class UserLocal {
  final bool statusLogin;
  final bool statusFirstLaunch;
  final String uid;
  final String idbuz;
  final String fullname;

  UserLocal({
    required this.statusLogin,
    required this.statusFirstLaunch,
    this.uid = '',
    this.idbuz = '',
    this.fullname = '',
  });
}
