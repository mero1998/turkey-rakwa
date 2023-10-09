

class Fees {
  int? id;
  String? address;
  bool? inRadius;
  List<String>? range;
  num? costPerKm;
  num? costTotal;
  bool? rangeFound;
  num? distance;
  num? realCostM;



  Fees.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    inRadius = json['inRadius'];
    // range = json['range'].cast<String>();
    costPerKm = json['cost_per_km'];
    costTotal = json['cost_total'];
    rangeFound = json['rangeFound'];
    distance = json['distance'];
    realCostM = json['real_cost_m'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['inRadius'] = this.inRadius;
    data['range'] = this.range;
    data['cost_per_km'] = this.costPerKm;
    data['cost_total'] = this.costTotal;
    data['rangeFound'] = this.rangeFound;
    data['distance'] = this.distance;
    data['real_cost_m'] = this.realCostM;
    return data;
  }
}
