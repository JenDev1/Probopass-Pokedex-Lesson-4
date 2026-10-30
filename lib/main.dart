import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'pokemon_model.dart';

void main() => runApp(const PokemonApp());

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokedex',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5278F5),
        ),
      ),
      home: const PokemonScreen(),
    );
  }
}

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  Pokemon? pokemon;

  bool isLoading = false;
  String? errorMessage;
  String moveSearch = '';

  final TextEditingController pokemonSearchController =
      TextEditingController(text: 'probopass');

  static const blue = Color(0xFF5278F5);
  static const ink = Color(0xFF202943);
  static const muted = Color(0xFF8992A8);
  static const page = Color(0xFFF5F7FC);

  @override
  void initState() {
    super.initState();
    fetchPokemon('probopass');
  }

  @override
  void dispose() {
    pokemonSearchController.dispose();
    super.dispose();
  }

  Future<void> fetchPokemon([String name = 'probopass']) async {
    final pokemonName = name.trim().toLowerCase();

    if (pokemonName.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a Pokémon name.';
      });
      return;
    }

    if (isLoading) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final url = Uri.https(
        'pokeapi.co',
        '/api/v2/pokemon/${Uri.encodeComponent(pokemonName)}',
      );

      final response = await http.get(url);

      if (response.statusCode == 404) {
        throw Exception(
          'Pokémon "$pokemonName" was not found. Please check the spelling.',
        );
      }

      if (response.statusCode != 200) {
        throw Exception(
          'Server error. Status code: ${response.statusCode}',
        );
      }

      final decodedData = jsonDecode(response.body);

      if (decodedData is! Map<String, dynamic>) {
        throw const FormatException('Invalid Pokémon data.');
      }

      final result = Pokemon.fromJson(decodedData);

      if (!mounted) return;

      setState(() {
        pokemon = result;
        isLoading = false;
        errorMessage = null;
        pokemonSearchController.text = result.name;
        moveSearch = '';
      });
    } on FormatException {
      if (!mounted) return;

      setState(() {
        errorMessage = 'The Pokémon data could not be processed.';
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  String titleCase(String value) {
    return value
        .split('-')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  Color typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'rock':
        return const Color(0xFFB79A58);
      case 'steel':
        return const Color(0xFF7186A8);
      case 'fire':
        return const Color(0xFFF07861);
      case 'water':
        return const Color(0xFF5798F5);
      case 'grass':
        return const Color(0xFF55B98A);
      case 'electric':
        return const Color(0xFFE8B943);
      case 'psychic':
        return const Color(0xFFD879B0);
      case 'ghost':
        return const Color(0xFF8575C9);
      case 'ice':
        return const Color(0xFF68C9D5);
      case 'dragon':
        return const Color(0xFF7772D9);
      case 'ground':
        return const Color(0xFFD49A69);
      case 'fighting':
        return const Color(0xFFD56C67);
      case 'poison':
        return const Color(0xFFAC78CA);
      case 'fairy':
        return const Color(0xFFE59AB9);
      case 'bug':
        return const Color(0xFF9BAF4D);
      case 'flying':
        return const Color(0xFF829CE5);
      default:
        return blue;
    }
  }

  Widget buildPokemonSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Search Pokémon',
          style: TextStyle(
            color: ink,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: pokemonSearchController,
                enabled: !isLoading,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => fetchPokemon(value),
                decoration: InputDecoration(
                  hintText: 'Enter Pokémon name...',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: blue,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Color(0xFFEDF0F7),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Color(0xFFEDF0F7),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: blue),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => fetchPokemon(
                          pokemonSearchController.text,
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Icon(Icons.search_rounded),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: page,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 15, 22, 10),
              child: buildPokemonSearch(),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: blue),
                    )
                  : errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.cloud_off_rounded,
                                  size: 56,
                                  color: muted,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: ink,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => fetchPokemon(
                                    pokemonSearchController.text,
                                  ),
                                  child: const Text('Try again'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : pokemon == null
                          ? const Center(
                              child: Text('No Pokémon found'),
                            )
                          : buildContent(pokemon!),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContent(Pokemon p) {
    final accent = typeColor(
      p.types.isNotEmpty ? p.types.first : 'normal',
    );

    final filteredMoves = p.moves.where((move) {
      return move.name.toLowerCase().contains(
            moveSearch.trim().toLowerCase(),
          );
    }).toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.catching_pokemon_rounded,
                        color: blue,
                        size: 27,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'POKÉDEX',
                            style: TextStyle(
                              color: ink,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.4,
                            ),
                          ),
                          Text(
                            'Discover your Pokémon',
                            style: TextStyle(
                              color: muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: isLoading
                          ? null
                          : () => fetchPokemon(
                                pokemonSearchController.text,
                              ),
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Pokémon information card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accent,
                        accent.withOpacity(0.72),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -30,
                        top: 10,
                        child: Icon(
                          Icons.catching_pokemon_rounded,
                          size: 190,
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(23),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#${p.id.toString().padLeft(3, '0')}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              titleCase(p.name),
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              children: p.types.map((type) {
                                return Chip(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.23),
                                  label: Text(
                                    titleCase(type),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            Center(
                              child: Image.network(
                                p.imageUrl,
                                height: 205,
                                width: 225,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const SizedBox(
                                  height: 205,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                sectionTitle('About', 'Basic information'),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: infoCard(
                        Icons.straighten_rounded,
                        'HEIGHT',
                        '${p.height / 10} m',
                        blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: infoCard(
                        Icons.monitor_weight_outlined,
                        'WEIGHT',
                        '${p.weight / 10} kg',
                        const Color(0xFF43B69A),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                infoCard(
                  Icons.bolt_rounded,
                  'BASE EXPERIENCE',
                  '${p.baseExperience} XP',
                  const Color(0xFFE6AD38),
                ),

                const SizedBox(height: 28),
                sectionTitle(
                  'Abilities',
                  '${p.abilities.length} available',
                ),
                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(17),
                  decoration: whiteCard(),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: p.abilities.map((ability) {
                      return Chip(
                        avatar: const Icon(
                          Icons.auto_awesome_rounded,
                          color: blue,
                          size: 17,
                        ),
                        label: Text(titleCase(ability)),
                        backgroundColor: const Color(0xFFF0F3FF),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 28),
                sectionTitle('Base Stats', 'Battle attributes'),
                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(19),
                  decoration: whiteCard(),
                  child: Column(
                    children: p.stats.map((stat) {
                      final progress = (stat.value / 150).clamp(0.0, 1.0);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    titleCase(stat.name),
                                    style: const TextStyle(
                                      color: muted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${stat.value}',
                                  style: const TextStyle(
                                    color: ink,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 9),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                backgroundColor: const Color(0xFFEDF0F7),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 28),
                sectionTitle('All Moves', '${p.moves.length} moves'),
                const SizedBox(height: 14),

                // Search within Pokémon moves
                TextField(
                  onChanged: (value) {
                    setState(() => moveSearch = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search moves...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: blue,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(
                        color: Color(0xFFEDF0F7),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(
                        color: Color(0xFFEDF0F7),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: blue),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                ...filteredMoves.map((move) {
                  final details = move.learnDetails
                      .map((detail) {
                        final method = titleCase(detail.method);

                        if (detail.method == 'level-up') {
                          return '$method • Lv. ${detail.level}';
                        }

                        return method;
                      })
                      .toSet()
                      .take(3)
                      .join(' • ');

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: whiteCard(),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      leading: Container(
                        width: 43,
                        height: 43,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F3FF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.flash_on_rounded,
                          color: blue,
                        ),
                      ),
                      title: Text(
                        titleCase(move.name),
                        style: const TextStyle(
                          color: ink,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        details.isEmpty
                            ? 'Learning details unavailable'
                            : details,
                        style: const TextStyle(
                          color: muted,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  );
                }),

                if (filteredMoves.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text('No moves found.'),
                    ),
                  ),

                const SizedBox(height: 25),
                Center(
                  child: Text(
                    'POKÉDEX • #${p.id}',
                    style: const TextStyle(
                      color: Color(0xFFABB2C3),
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration whiteCard() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: const Color(0xFFEDF0F7),
      ),
      boxShadow: [
        BoxShadow(
          color: ink.withOpacity(0.025),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  Widget sectionTitle(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: ink,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            color: muted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget infoCard(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: whiteCard(),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 10,
                    letterSpacing: 0.7,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
