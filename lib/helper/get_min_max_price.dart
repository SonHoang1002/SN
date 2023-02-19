List<double> getMinAndMaxPrice(List<dynamic> productVariants) {
  double min = productVariants[0]["price"];
  double max = productVariants[0]["price"];
  for (int i = 0; i < productVariants.length; i++) {
    if (productVariants[i]["price"] < min) {
      min = productVariants[i]["price"];
    }
    if (productVariants[i]["price"] > max) {
      max = productVariants[i]["price"];
    }
  }
  return [min, max];
}

