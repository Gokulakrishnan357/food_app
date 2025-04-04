// To parse this JSON data, do
//
//     final getAlIItemsModel = getAlIItemsModelFromJson(jsonString);

import 'dart:convert';

List<GetAlIItemsModel> getAlIItemsModelFromJson(String str) =>
    List<GetAlIItemsModel>.from(
        json.decode(str).map((x) => GetAlIItemsModel.fromJson(x)));

String getAlIItemsModelToJson(List<GetAlIItemsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAlIItemsModel {
  int? id;
  String? fromOrganization;
  String? fromOnSubInventory;
  String? fromLocation;
  String? toOrganization;
  String? itemCode;
  String? lotNumber;
  String? qty1;
  Qty2? qty2;
  String? documentNo;
  String? btq;

  GetAlIItemsModel({
    this.id,
    this.fromOrganization,
    this.fromOnSubInventory,
    this.fromLocation,
    this.toOrganization,
    this.itemCode,
    this.lotNumber,
    this.qty1,
    this.qty2,
    this.documentNo,
    this.btq,
  });

  factory GetAlIItemsModel.fromJson(Map<String, dynamic> json) =>
      GetAlIItemsModel(
        id: json["id"],
        fromOrganization: json["fromOrganization"]!,
        fromOnSubInventory: json["fromOnSubInventory"]!,
        fromLocation: json["fromLocation"]!,
        toOrganization: json["toOrganization"]!,
        itemCode: json["itemCode"],
        lotNumber: json["lotNumber"]!,
        qty1: json["qty1"],
        qty2: qty2Values.map[json["qty2"]]!,
        documentNo: json["documentNo"],
        btq: json["btq"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fromOrganization": organizationValues.reverse[fromOrganization],
        "fromOnSubInventory":
            fromOnSubInventoryValues.reverse[fromOnSubInventory],
        "fromLocation": fromLocationValues.reverse[fromLocation],
        "toOrganization": organizationValues.reverse[toOrganization],
        "itemCode": itemCode,
        "lotNumber": lotNumberValues.reverse[lotNumber],
        "qty1": qty1,
        "qty2": qty2Values.reverse[qty2],
        "documentNo": documentNo,
        "btq": btq,
      };
}

enum FromLocation { PACK_HSPM }

final fromLocationValues = EnumValues({"PACK-HSPM": FromLocation.PACK_HSPM});

enum FromOnSubInventory { HSPM }

final fromOnSubInventoryValues = EnumValues({"HSPM": FromOnSubInventory.HSPM});

enum Organization { JMO, KAS, MHS, RJS, TNS, WBS }

final organizationValues = EnumValues({
  "JMO": Organization.JMO,
  "KAS": Organization.KAS,
  "MHS": Organization.MHS,
  "RJS": Organization.RJS,
  "TNS": Organization.TNS,
  "WBS": Organization.WBS
});

enum LotNumber { THE_2_B }

final lotNumberValues = EnumValues({"2B": LotNumber.THE_2_B});

enum Qty2 { EMPTY }

final qty2Values = EnumValues({"-": Qty2.EMPTY});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
