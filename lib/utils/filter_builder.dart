import '../models/asset_model.dart';
import '../models/location_model.dart';
import 'tree_builder.dart';

TreeNode applyEnergySensorFilter(
  List<LocationModel> locationsData,
  List<AssetModel> assetsData,
) {
  final components = assetsData
      .where(
        (component) =>
            component.status != Status.alert &&
            component.gatewayId != null &&
            component.sensorType != null,
      )
      .toList();

  return applyFilter(locationsData, assetsData, components);
}

TreeNode applyCriticalAssetsFilter(
  List<LocationModel> locationsData,
  List<AssetModel> assetsData,
) {
  final components = assetsData
      .where((component) => component.status == Status.alert)
      .toList();

  return applyFilter(locationsData, assetsData, components);
}

TreeNode applyTextFilter(
  List<LocationModel> locationsData,
  List<AssetModel> assetsData,
  String term,
) {
  final assets = assetsData
      .where((asset) => asset.name.toLowerCase().contains(term))
      .toList();

  final locations = locationsData
      .where((loc) => loc.name.toLowerCase().contains(term))
      .toList();

  final assetsWithSubAssets = filterAssetsByAssets(assetsData, assets);
  final components = filterAssetsByAssets(assetsData, assetsWithSubAssets);

  final locationsWithAssets = filterLocationsByAssets(locationsData, assets);
  final locationsWithSubAssets =
      filterLocationsByAssets(locationsData, assetsWithSubAssets);
  final subLocationsWithComponents =
      filterLocationsByAssets(locationsData, components);

  final locationsWithSubLocations =
      filterLocationsByLocations(locationsData, locations);
  final locationsWithSubLocationsWithAssets =
      filterLocationsByLocations(locationsData, locationsWithAssets);
  final locationsWithSubLocationsWithSubAssets =
      filterLocationsByLocations(locationsData, locationsWithSubAssets);
  final locationsWithsubLocationsWithComponents =
      filterLocationsByLocations(locationsData, subLocationsWithComponents);

  return buildTree([
    ...locations,
    ...locationsWithAssets,
    ...locationsWithSubLocations,
    ...locationsWithSubAssets,
    ...locationsWithSubLocationsWithAssets,
    ...locationsWithSubLocationsWithSubAssets,
    ...subLocationsWithComponents,
    ...locationsWithsubLocationsWithComponents,
  ], [
    ...assets,
    ...assetsWithSubAssets,
    ...components,
  ]);
}

TreeNode applyFilter(
  List<LocationModel> locationsData,
  List<AssetModel> assetsData,
  List<AssetModel> components,
) {
  final assetsWithComponents = filterAssetsByAssets(assetsData, components);
  final assetsWithSubAssets =
      filterAssetsByAssets(assetsData, assetsWithComponents);

  final locationsWithComponents =
      filterLocationsByAssets(locationsData, components);
  final locationsWithAssets =
      filterLocationsByAssets(locationsData, assetsWithSubAssets);
  final locationsWithSubAssets =
      filterLocationsByAssets(locationsData, assetsWithComponents);

  final locationsWithSubLocations =
      filterLocationsByLocations(locationsData, locationsWithComponents);
  final locationsWithSubLocationsWithAssets =
      filterLocationsByLocations(locationsData, locationsWithAssets);
  final locationsWithSubLocationsWithSubAssets =
      filterLocationsByLocations(locationsData, locationsWithSubAssets);

  return buildTree([
    ...locationsWithComponents,
    ...locationsWithAssets,
    ...locationsWithSubAssets,
    ...locationsWithSubLocations,
    ...locationsWithSubLocationsWithAssets,
    ...locationsWithSubLocationsWithSubAssets,
  ], [
    ...assetsWithComponents,
    ...assetsWithSubAssets,
    ...components,
  ]);
}

List<AssetModel> filterAssetsByAssets(
    List<AssetModel> assetsData, List<AssetModel> assets) {
  return assetsData
      .where((asset) => assets.any((subAsset) => asset.id == subAsset.parentId))
      .toList();
}

List<LocationModel> filterLocationsByAssets(
    List<LocationModel> locationsData, List<AssetModel> assets) {
  return locationsData
      .where((loc) => assets.any((asset) => loc.id == asset.locationId))
      .toList();
}

List<LocationModel> filterLocationsByLocations(
    List<LocationModel> locationsData, List<LocationModel> locations) {
  return locationsData
      .where((loc) => locations.any((subLoc) => loc.id == subLoc.parentId))
      .toList();
}
