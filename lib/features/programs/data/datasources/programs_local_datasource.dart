import 'dart:convert';

import 'package:calistracker/features/programs/data/models/program_model.dart';
import 'package:flutter/services.dart';

abstract class ProgramsLocalDataSource {
  Future<List<ProgramModel>> getPrograms();
}

class ProgramsLocalDataSourceImpl implements ProgramsLocalDataSource {
  ProgramsLocalDataSourceImpl({this.assetPath = 'assets/data/programs.json'});

  final String assetPath;
  Future<List<ProgramModel>>? _programs;

  @override
  Future<List<ProgramModel>> getPrograms() => _programs ??= _load();

  Future<List<ProgramModel>> _load() async {
    try {
      return await _read();
    } catch (_) {
      _programs = null; // don't cache a failure; let the next request retry
      rethrow;
    }
  }

  Future<List<ProgramModel>> _read() async {
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return (json['programs'] as List)
        .map((p) => ProgramModel.fromJson(p as Map<String, dynamic>))
        .toList();
  }
}
