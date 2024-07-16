import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/controllers/home_page_controller.dart';
import 'package:riverpod_flutter/models/page_data.dart';

final _homePageControllerProvider = StateNotifierProvider<HomePageController,HomePageData>((ref){
  return HomePageController(HomePageData.initial());
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  late HomePageController _homePageController;
  late HomePageData _homePageData;

  @override
  Widget build(BuildContext context) {

    _homePageController = ref.watch(_homePageControllerProvider.notifier);
    _homePageData = ref.watch(_homePageControllerProvider);

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
                _allPokemonList(context)
              ],
            ),
          ),
        ));
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
              itemCount: 0,
                itemBuilder: (context, index){
                  return ListTile();
                }),
          )
        ],
      ),
    );
  }
}
