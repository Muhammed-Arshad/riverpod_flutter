import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_flutter/models/page_data.dart';
import 'package:riverpod_flutter/models/pokemon.dart';

import '../services/http_services.dart';

class HomePageController extends StateNotifier<HomePageData>{

  final GetIt _getIt = GetIt.instance;

  late HttpServices _httpServices;

  HomePageController(super._state){
    _httpServices = _getIt.get<HttpServices>();
    _setup();
  }

  Future<void> _setup() async{
    await loadData();
  }

  Future<void> loadData() async{
    if(state.data == null){
      Response? res = await _httpServices.get('https://pokeapi.co/api/v2/pokemon?limit=20&offset=0');
      if(res != null && res.data != null){
        PokemonListData data = PokemonListData.fromJson(res.data);
        state = state.copyWith(data: data);
      }else{

      }
    }else{

    }
  }
}