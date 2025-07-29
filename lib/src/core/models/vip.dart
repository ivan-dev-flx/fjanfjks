class Vip {
  final bool isVip;
  final bool loading;
  final dynamic offering; // Замените на правильный тип (например, Offering?)

  const Vip({
    this.isVip = false,
    this.loading = false,
    this.offering,
  });

  Vip copyWith({
    bool? isVip,
    bool? loading,
    dynamic offering,
  }) {
    return Vip(
      isVip: isVip ?? this.isVip,
      loading: loading ?? this.loading,
      offering: offering ?? this.offering,
    );
  }

  @override
  String toString() {
    return 'Vip(isVip: $isVip, loading: $loading, offering: $offering)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vip &&
        other.isVip == isVip &&
        other.loading == loading &&
        other.offering == offering;
  }

  @override
  int get hashCode {
    return isVip.hashCode ^ loading.hashCode ^ offering.hashCode;
  }
}
