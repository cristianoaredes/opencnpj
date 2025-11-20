// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WidgetModel _$WidgetModelFromJson(Map<String, dynamic> json) => WidgetModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
);

Map<String, dynamic> _$WidgetModelToJson(WidgetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
    };
