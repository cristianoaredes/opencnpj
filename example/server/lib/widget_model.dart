import 'package:json_annotation/json_annotation.dart';

part 'widget_model.g.dart';

@JsonSerializable()
class WidgetModel {
  final String id;
  final String name;
  final String description;
  final double price;

  WidgetModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory WidgetModel.fromJson(Map<String, dynamic> json) =>
      _$WidgetModelFromJson(json);

  Map<String, dynamic> toJson() => _$WidgetModelToJson(this);
}
