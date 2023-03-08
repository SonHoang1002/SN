Function(int num) shortenLargeNumber = (int num) {
  if (num >= 1000000000) {
    return '${(num / 1000000000).toStringAsFixed(1).replaceAll(RegExp(r'/\.0$/'), '')}G';
  }
  if (num >= 1000000) {
    return '${(num / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'/\.0$/'), '')}M';
  }
  if (num >= 1000) {
    return '${(num / 1000).toStringAsFixed(1).replaceAll(RegExp(r'/\.0$/'), '')}K';
  }
  return num;
};
Function(int num) convertNumberToVND = (int num) {
  return num.toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
};
