import 'dart:convert';

import 'package:calistracker/features/programs/data/models/program_model.dart';
import 'package:flutter/services.dart';

abstract class ProgramsLocalDataSource {
  Future<List<ProgramModel>> getPrograms();
}

class ProgramsLocalDataSourceImpl implements ProgramsLocalDataSource {
  const ProgramsLocalDataSourceImpl({
    this.assetPath = 'assets/data/programs.json',
  });

  final String assetPath;

  @override
  Future<List<ProgramModel>> getPrograms() async {
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return (json['programs'] as List)
        .map((p) => ProgramModel.fromJson(p as Map<String, dynamic>))
        .toList();
  }
}
