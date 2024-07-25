import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/controllers/home_page_controller.dart';
import 'package:riverpod_flutter/models/page_data.dart';
import 'package:riverpod_flutter/models/pokemon.dart';
import 'package:riverpod_flutter/providers/pokemon_data_provider.dart';
import 'package:riverpod_flutter/widgets/pokemon_card.dart';
import 'package:riverpod_flutter/widgets/pokemon_list_tile.dart';

final _homePageControllerProvider = StateNotifierProvider<HomePageController,HomePageData>((ref){
  return HomePageController(HomePageData.initial());
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  final ScrollController _allPokemonListScrollController = ScrollController();

  late HomePageController _homePageController;
  late HomePageData _homePageData;

  late List<String> _favoritePokemonList;
  
  @override
  void initState() {
    super.initState();
    _allPokemonListScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _allPokemonListScrollController.removeListener(_scrollListener);
    _allPokemonListScrollController.dispose();
    super.dispose();
  }

  void _scrollListener(){
    if(_allPokemonListScrollController.offset >=
    _allPokemonListScrollController.position.maxScrollExtent * 1 &&
        !_allPokemonListScrollController.position.outOfRange){
      print('oooooo');
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {

    _homePageController = ref.watch(_homePageControllerProvider.notifier);
    _homePageData = ref.watch(_homePageControllerProvider);

    _favoritePokemonList = ref.watch(favoritePokemonProvider);

    return Scaffold(
      body: buildUI(
        context,
      ),
    );
  }

  Widget buildUI(BuildContext context){
    return SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _favoritePokemonsList(context),
                _allPokemonList(context)
              ],
            ),
          ),
        ));
  }

  Widget _favoritePokemonsList(BuildContext context){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Favorite',style: TextStyle(fontSize: 25),),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(_favoritePokemonList.isNotEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.48,
                    child: GridView.builder(
                      // scrollDirection: Axis.horizontal,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2
                        ),
                        itemCount: _favoritePokemonList.length,
                        itemBuilder: (context,index){
                          String pokemonURL = _favoritePokemonList[index];
                          return PokemonCard(pokemonURL: pokemonURL);
                        }),
                  ),
                if(_favoritePokemonList.isEmpty)
                  const Text('No favorite pokemon')
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _allPokemonList(BuildContext context){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('All Pokemon', style: TextStyle(
            fontSize: 25
          ),),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.60,
            child: ListView.builder(
              controller: _allPokemonListScrollController,
              itemCount: _homePageData.data?.results?.length ?? 0,
                itemBuilder: (context, index){
                  PokemonListResult pokemon = _homePageData.data!.results![index];
                  return PokemonListTile(pokemonURL: pokemon.url.toString());
                }),
          )
        ],
      ),
    );
  }
}
