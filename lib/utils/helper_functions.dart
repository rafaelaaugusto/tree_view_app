import '../models/asset_model.dart';
import '../models/location_model.dart';

List<LocationModel> removeLocationsDuplicates(List<LocationModel> locations) {
  final Set<String> ids = {};
  final List<LocationModel> uniqueLocations = [];

  for (var location in locations) {
    if (!ids.contains(location.id)) {
      ids.add(location.id);
      uniqueLocations.add(location);
    }
  }
  return uniqueLocations;
}

List<AssetModel> removeAssetsDuplicates(List<AssetModel> assets) {
  final Set<String> ids = {};
  final List<AssetModel> uniqueAssets = [];

  for (var asset in assets) {
    if (!ids.contains(asset.id)) {
      ids.add(asset.id);
      uniqueAssets.add(asset);
    }
  }
  return uniqueAssets;
}
