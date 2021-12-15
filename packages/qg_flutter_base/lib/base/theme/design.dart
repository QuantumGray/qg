// import 'package:flutter/material.dart';

// class DesignSystem {
//   var _designComponents;
//   DesignSystem(this._designComponents)
//       : assert(_designComponents is DesignComponent);

//   void insert(List<DesignComponent> _newDesignComponents) {
//     _designComponents = _designComponents + _newDesignComponents;
//   }

//   DesignComponent? retrieve(DesignComponentType componentType) {
//     if (componentType is DesignComponentTypeText) {
//       for (var component in _designComponents) {
//         if (component.type == componentType.textType) {
//           return component;
//         }
//       }
//     }
//     if (componentType is DesignComponentTypeColor) {
//       for (var component in _designComponents) {
//         if (component.type == componentType.colorType) {
//           return component;
//         }
//       }
//     }
//     return null;
//   }
// }

// class DesignComponent {
//   DesignComponent.color(DesignComponentType colorType, Color color);

//   DesignComponent.textStyle(DesignComponentType textType, TextStyle textStyle);
// }

// abstract class DesignComponentType {}

// class DesignComponentTypeText extends DesignComponentType {
//   final DesignComponentTextType textType;
//   DesignComponentTypeText(this.textType);
// }

// class DesignComponentTypeColor extends DesignComponentType {
//   final DesignComponentColorType colorType;
//   DesignComponentTypeColor({required this.colorType});
// }

// enum DesignComponentColorType { primary, secondary, textDark, textLight }
// enum DesignComponentTextType { header, subheader, text }

// final designSystem = DesignSystem([
//   DesignComponent.color(
//       DesignComponentTypeColor(
//         colorType: DesignComponentColorType.primary,
//       ),
//       Colors.blue),
// ]);
