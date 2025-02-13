import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/models/pokemon.dart';
import 'package:riverpod_flutter/providers/pokemon_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonURL;

  late FavoritePokemonProvider _favoritePokemonProvider;
  late List<String> _favoritePokemon;

  PokemonListTile({super.key, required this.pokemonURL});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    _favoritePokemonProvider = ref.watch(favoritePokemonProvider.notifier);
    
    _favoritePokemon = ref.watch(favoritePokemonProvider);

    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));

    return pokemon.when(
        data: (data){
          return _tile(context,false,data);
        },
        error: (e,s){
          return Text('Error $e');
        },
        loading: (){
          return _tile(context,true,null);
        });
  }

  Widget _tile(BuildContext context,bool isLoading, Pokemon? pokemon){
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        leading: pokemon != null ?
          CircleAvatar(
            backgroundImage: NetworkImage(
              pokemon.sprites!.frontDefault!,
            ),
          ): CircleAvatar(),
        title: Text(
            pokemon != null
                ?pokemon.name!.toUpperCase()
        :"currently loading name for pokemon"),
      subtitle: Text('Has ${pokemon?.moves?.length.toString() ?? 0}'),
      trailing: IconButton(
        onPressed: (){
          if(_favoritePokemon.contains(pokemonURL)){
            _favoritePokemonProvider.removeFavoritePokemon(pokemonURL);
          }else{
            _favoritePokemonProvider.addFavoritePokemon(pokemonURL);
          }
        },
        icon: _favoritePokemon.contains(pokemonURL)?
            Icon(Icons.favorite):
        Icon(Icons.favorite_border),
        color: Colors.red,
      ),),
    );
  }
}
