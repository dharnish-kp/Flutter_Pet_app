import 'dart:convert';

class PetItem {
  final String id;
  final String name;
  final String breedOrCategory;
  final String ageOrWeight;
  final String price;
  final String imageUrl;
  final String type; // 'puppy', 'adoption', 'accessory'
  final bool isVaccinated;
  final String description;

  PetItem({
    required this.id,
    required this.name,
    required this.breedOrCategory,
    required this.ageOrWeight,
    required this.price,
    required this.imageUrl,
    required this.type,
    this.isVaccinated = true,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'breedOrCategory': breedOrCategory,
      'ageOrWeight': ageOrWeight,
      'price': price,
      'imageUrl': imageUrl,
      'type': type,
      'isVaccinated': isVaccinated,
      'description': description,
    };
  }

  factory PetItem.fromMap(Map<String, dynamic> map) {
    return PetItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      breedOrCategory: map['breedOrCategory'] ?? '',
      ageOrWeight: map['ageOrWeight'] ?? '',
      price: map['price'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      type: map['type'] ?? 'puppy',
      isVaccinated: map['isVaccinated'] ?? true,
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory PetItem.fromJson(String source) => PetItem.fromMap(json.decode(source));
}

final List<PetItem> samplePuppies = [
  PetItem(
    id: 'p1',
    name: 'Labrador Puppy',
    breedOrCategory: 'Golden Labrador',
    ageOrWeight: '50 Days',
    price: '₹14,500',
    imageUrl: 'https://images.unsplash.com/photo-1591769225440-811ad7d6eab2?w=500',
    type: 'puppy',
    description: 'Playful, healthy, active puppy with first vaccination completed.',
  ),
  PetItem(
    id: 'p2',
    name: 'Beagle Tri-Color',
    breedOrCategory: 'Beagle',
    ageOrWeight: '60 Days',
    price: '₹18,000',
    imageUrl: 'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8?w=500',
    type: 'puppy',
    description: 'Lineage beagle with proper deworming certificate.',
  ),
  PetItem(
    id: 'p3',
    name: 'German Shepherd',
    breedOrCategory: 'GSD Long Coat',
    ageOrWeight: '2 Months',
    price: '₹22,000',
    imageUrl: 'https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?w=500',
    type: 'puppy',
    description: 'Heavy bone structure, playful and active pedigree pup.',
  ),
];

final List<PetItem> sampleAdoptions = [
  PetItem(
    id: 'a1',
    name: 'Milo & Bruno',
    breedOrCategory: 'Indie Rescues',
    ageOrWeight: '3 Months',
    price: 'Free Adoption',
    imageUrl: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=500',
    type: 'adoption',
    description: 'Rescued puppies looking for a caring home in Eddapadi/Poolampatti region.',
  ),
  PetItem(
    id: 'a2',
    name: 'Snowy',
    breedOrCategory: 'Persian Cross Kitten',
    ageOrWeight: '45 Days',
    price: 'Free Adoption',
    imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=500',
    type: 'adoption',
    description: 'Friendly litter-trained kitten seeking loving guardians.',
  ),
];

final List<PetItem> sampleAccessories = [
  PetItem(
    id: 'acc1',
    name: 'Royal Canin Maxi Puppy',
    breedOrCategory: 'Premium Pet Food',
    ageOrWeight: '4 kg pack',
    price: '₹2,850',
    imageUrl: 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=500',
    type: 'accessory',
    description: 'Vet-approved complete nutritional food for growing puppies.',
  ),
  PetItem(
    id: 'acc2',
    name: 'Padded Harness & Leash Set',
    breedOrCategory: 'Collars & Gear',
    ageOrWeight: 'Medium / Large',
    price: '₹750',
    imageUrl: 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=500',
    type: 'accessory',
    description: 'Reflective nylon harness with anti-pull chest padding.',
  ),
  PetItem(
    id: 'acc3',
    name: 'Organic Pet Shampoo',
    breedOrCategory: 'Grooming Care',
    ageOrWeight: '500 ml',
    price: '₹420',
    imageUrl: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=500',
    type: 'accessory',
    description: 'Neem & Aloe vera anti-tick herbal formula.',
  ),
];