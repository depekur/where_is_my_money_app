class Currency {
  final String name;
  final String symbol;
  final String code;
  final String isoCode;

  Currency({
    required this.name,
    required this.symbol,
    required this.code,
    required this.isoCode
  });

  get dto {
    return {
      'name': name,
      'symbol': symbol,
      'code': code,
      'isoCode': isoCode,
    };
  }

  static Currency fromResponse(c) {
    return Currency(
      name: c['name'],
      symbol: c['symbol'],
      code: c['code'],
      isoCode: c['isoCode'],
    );
  }

  static Currency empty() {
    return Currency(
      name: '',
      symbol: '',
      code: '',
      isoCode: '',
    );
  }
}