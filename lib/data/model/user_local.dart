class UserLocal {
  final bool statusLogin;
  final bool statusFirstLaunch;
  final String uid;
  final String idbuz;
  final String fullname;
  final String lastUpdate;
  final String imgUrl;

  UserLocal({
    required this.statusLogin,
    required this.statusFirstLaunch,
    this.uid = '',
    this.idbuz = '',
    this.fullname = '',
    this.lastUpdate = '',
    this.imgUrl = '',
  });

  UserLocal copyWith({
    bool? statusLogin,
    bool? statusFirstLaunch,
    String? uid,
    String? idbuz,
    String? fullname,
    String? lastUpdate,
  }) {
    return UserLocal(
      statusLogin: statusLogin ?? this.statusLogin,
      statusFirstLaunch: statusFirstLaunch ?? this.statusFirstLaunch,
      uid: uid ?? this.uid,
      idbuz: idbuz ?? this.idbuz,
      fullname: fullname ?? this.fullname,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
