/// Parses positive VND prices from a TextField.
///
/// Accepts plain numbers (4200000), thousand-grouped numbers (4.200.000,
/// 4,200,000), and decimal values using a dot (125000.50).
abstract final class PriceParser {
  static double? parse(String input) {
    final raw = input.trim().replaceAll(' ', '');
    if (raw.isEmpty) return null;

    final grouped = RegExp(r'^\d{1,3}([.,]\d{3})+$');
    final normalized = grouped.hasMatch(raw)
        ? raw.replaceAll('.', '').replaceAll(',', '')
        : raw;
    final price = double.tryParse(normalized);
    if (price == null || !price.isFinite || price <= 0) return null;
    return price;
  }
}
