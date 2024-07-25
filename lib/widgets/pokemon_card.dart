import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/models/pokemon.dart';
import 'package:riverpod_flutter/providers/pokemon_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonCard extends ConsumerWidget {

  late FavoritePokemonProvider _favoritePokemonProvider;

  final String pokemonURL;
  PokemonCard({super.key, required this.pokemonURL});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    _favoritePokemonProvider = ref.watch(favoritePokemonProvider.notifier);

    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));

    return pokemon.when(
        data: (data){
          return _card(context, false, data);
        },
        error: (e,s){
          return Text('Error');
        },
        loading: (){
          return _card(context, true, null);
        });
  }

  Widget _card(BuildContext context, bool isLoading, Pokemon? pokemon){
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: true,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
          vertical: MediaQuery.of(context).size.height * 0.01
        ),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.01
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 2,
              blurRadius: 10
            )
          ],
          color: Theme.of(context).primaryColor
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pokemon?.name?.toUpperCase() ?? "Pokemon",
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
                Text(
                  "#${pokemon?.id?.toString()}",
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Expanded(child: CircleAvatar(
              backgroundImage: pokemon != null
                  ?NetworkImage(pokemon.sprites!.frontDefault!)
              : null,
              radius: MediaQuery.of(context).size.height * 0.05,
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${pokemon?.moves?.length} Moves",
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: (){
                    _favoritePokemonProvider.removeFavoritePokemon(pokemonURL);
                  },
                    child: Icon(Icons.favorite,color: Colors.red,))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
