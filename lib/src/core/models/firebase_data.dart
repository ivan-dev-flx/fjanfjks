class FirebaseData {
  FirebaseData({
    this.invoice = false,
    // this.paywall1 = '',
    // this.paywall2 = '',
    // this.paywall3 = '',
  });

  final bool invoice;
  // final String paywall1;
  // final String paywall2;
  // final String paywall3;

  factory FirebaseData.fromJson(Map<String, dynamic> json) {
    return FirebaseData(
      invoice: json['invoice'],
      // paywall1: json['paywall_1'],
      // paywall2: json['paywall_2'],
      // paywall3: json['paywall_3'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoice': invoice,
      // 'paywall_1': paywall1,
      // 'paywall_2': paywall2,
      // 'paywall_3': paywall3,
    };
  }
}
