import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pet_model.dart';

class PetRepository {
  static final PetRepository _instance = PetRepository._internal();
  factory PetRepository() => _instance;

  PetRepository._internal() {
    loadSavedData();
  }

  final ValueNotifier<List<PetItem>> puppiesNotifier = ValueNotifier<List<PetItem>>([]);
  final ValueNotifier<List<PetItem>> adoptionsNotifier = ValueNotifier<List<PetItem>>([]);
  final ValueNotifier<List<PetItem>> accessoriesNotifier = ValueNotifier<List<PetItem>>([]);

  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? savedPups = prefs.getStringList('saved_puppies');
    final List<String>? savedAdopts = prefs.getStringList('saved_adoptions');
    final List<String>? savedAccs = prefs.getStringList('saved_accessories');

    if (savedPups != null && savedPups.isNotEmpty) {
      puppiesNotifier.value = savedPups.map((s) => PetItem.fromJson(s)).toList();
    } else {
      puppiesNotifier.value = [...samplePuppies];
    }

    if (savedAdopts != null && savedAdopts.isNotEmpty) {
      adoptionsNotifier.value = savedAdopts.map((s) => PetItem.fromJson(s)).toList();
    } else {
      adoptionsNotifier.value = [...sampleAdoptions];
    }

    if (savedAccs != null && savedAccs.isNotEmpty) {
      accessoriesNotifier.value = savedAccs.map((s) => PetItem.fromJson(s)).toList();
    } else {
      accessoriesNotifier.value = [...sampleAccessories];
    }
  }

  Future<void> _persist(String key, List<PetItem> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, list.map((item) => item.toJson()).toList());
  }

  Future<void> addItem({
    required String name,
    required String breedOrCategory,
    required String ageOrWeight,
    required String price,
    required String imageUrl,
    required String type,
    required bool isVaccinated,
    required String description,
  }) async {
    final cleanImage = imageUrl.trim().isNotEmpty
        ? imageUrl.trim()
        : (type == 'puppy'
            ? 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=500'
            : (type == 'adoption'
                ? 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=500'
                : 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=500'));

    final newItem = PetItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      breedOrCategory: breedOrCategory,
      ageOrWeight: ageOrWeight,
      price: price,
      imageUrl: cleanImage,
      type: type,
      isVaccinated: isVaccinated,
      description: description,
    );

    if (type == 'puppy') {
      puppiesNotifier.value = [newItem, ...puppiesNotifier.value];
      await _persist('saved_puppies', puppiesNotifier.value);
    } else if (type == 'adoption') {
      adoptionsNotifier.value = [newItem, ...adoptionsNotifier.value];
      await _persist('saved_adoptions', adoptionsNotifier.value);
    } else if (type == 'accessory') {
      accessoriesNotifier.value = [newItem, ...accessoriesNotifier.value];
      await _persist('saved_accessories', accessoriesNotifier.value);
    }
  }

  Future<void> deleteItem(String id, String type) async {
    if (type == 'puppy') {
      puppiesNotifier.value = puppiesNotifier.value.where((p) => p.id != id).toList();
      await _persist('saved_puppies', puppiesNotifier.value);
    } else if (type == 'adoption') {
      adoptionsNotifier.value = adoptionsNotifier.value.where((p) => p.id != id).toList();
      await _persist('saved_adoptions', adoptionsNotifier.value);
    } else if (type == 'accessory') {
      accessoriesNotifier.value = accessoriesNotifier.value.where((p) => p.id != id).toList();
      await _persist('saved_accessories', accessoriesNotifier.value);
    }
  }
}