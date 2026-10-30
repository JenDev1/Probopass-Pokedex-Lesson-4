class Pokemon {
  final int id;
  final String name;
  final int height;
  final int weight;
  final int baseExperience;
  final String imageUrl;
  final List<String> types;
  final List<String> abilities;
  final List<PokemonStat> stats;
  final List<PokemonMove> moves;

  Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.baseExperience,
    required this.imageUrl,
    required this.types,
    required this.abilities,
    required this.stats,
    required this.moves,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] ?? {};
    final other = sprites['other'] ?? {};
    final artwork = other['official-artwork'] ?? {};

    return Pokemon(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      baseExperience: json['base_experience'] ?? 0,
      imageUrl: artwork['front_default'] ?? sprites['front_default'] ?? '',
      types: (json['types'] as List? ?? [])
          .map<String>((e) => e['type']['name'].toString())
          .toList(),
      abilities: (json['abilities'] as List? ?? [])
          .map<String>((e) => e['ability']['name'].toString())
          .toList(),
      stats: (json['stats'] as List? ?? [])
          .map<PokemonStat>((e) => PokemonStat.fromJson(e))
          .toList(),
      moves: (json['moves'] as List? ?? [])
          .map<PokemonMove>((e) => PokemonMove.fromJson(e))
          .toList(),
    );
  }
}

class PokemonStat {
  final String name;
  final int value;

  PokemonStat({required this.name, required this.value});

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      name: json['stat']?['name'] ?? 'Unknown',
      value: json['base_stat'] ?? 0,
    );
  }
}

class PokemonMove {
  final String name;
  final List<MoveLearnDetail> learnDetails;

  PokemonMove({
    required this.name,
    required this.learnDetails,
  });

  factory PokemonMove.fromJson(Map<String, dynamic> json) {
    return PokemonMove(
      name: json['move']?['name'] ?? 'Unknown',
      learnDetails: (json['version_group_details'] as List? ?? [])
          .map<MoveLearnDetail>(
            (e) => MoveLearnDetail.fromJson(e),
          )
          .toList(),
    );
  }
}

class MoveLearnDetail {
  final int level;
  final String method;
  final String versionGroup;

  MoveLearnDetail({
    required this.level,
    required this.method,
    required this.versionGroup,
  });

  factory MoveLearnDetail.fromJson(Map<String, dynamic> json) {
    return MoveLearnDetail(
      level: json['level_learned_at'] ?? 0,
      method: json['move_learn_method']?['name'] ?? 'Unknown',
      versionGroup: json['version_group']?['name'] ?? 'Unknown',
    );
  }
}
