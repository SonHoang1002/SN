List<int> getMinAndMaxPrice(List<dynamic> productVariants) {
  List<dynamic> primaryList = productVariants;

  if (productVariants == null || productVariants.isEmpty) {
    return [0, 0];
  }
  double min = primaryList[0]["price"];
  double max = primaryList[0]["price"];
  for (int i = 0; i < primaryList.length; i++) {
    if (primaryList[i]["price"] < min) {
      min = primaryList[i]["price"];
    }
    if (primaryList[i]["price"] > max) {
      max = primaryList[i]["price"];
    }
  }
  return [int.parse(min.toStringAsFixed(0)), int.parse(max.toStringAsFixed(0))];
}
