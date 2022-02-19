import 'package:macro_builder/builder.dart';
import 'package:build/build.dart';

Builder typesBuilder(_) => TypesMacroBuilder([]);
Builder declarationsBuilder(_) => DeclarationsMacroBuilder([]);
Builder definitionsBuilder(_) => DefinitionsMacroBuilder([]);
