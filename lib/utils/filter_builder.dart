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

  final assetsWithSubAssets = assetsData
      .where((asset) => assets.any((ass) => asset.id == ass.parentId))
      .toList();

  final locations = locationsData
      .where((loc) => loc.name.toLowerCase().contains(term))
      .toList();

  final locationsWithSubLocations = locationsData
      .where((loc) => locations.any((subLoc) => loc.id == subLoc.parentId))
      .toList();

  final locationsWithAssets = locationsData
      .where((loc) => assets.any((comp) => loc.id == comp.locationId))
      .toList();

  final locationsWithSubAssets = locationsData
      .where(
          (loc) => assetsWithSubAssets.any((ass) => loc.id == ass.locationId))
      .toList();

  final locationsWithSubLocationsWithAssets = locationsData
      .where(
          (loc) => locationsWithAssets.any((comp) => loc.id == comp.parentId))
      .toList();

  final locationsWithSubLocationsWithSubAssets = locationsData
      .where((loc) =>
          locationsWithSubAssets.any((comp) => loc.id == comp.parentId))
      .toList();

  final assets2 = assetsData
      .where(
          (asset) => assetsWithSubAssets.any((ass) => asset.id == ass.parentId))
      .toList();

  final locationsWithSubAssets2 = locationsData
      .where((loc) => assets2.any((ass) => loc.id == ass.locationId))
      .toList();

  final locationsWithSubAssets3 = locationsData
      .where(
          (loc) => locationsWithSubAssets2.any((ass) => loc.id == ass.parentId))
      .toList();

  return buildTree([
    ...locations,
    ...locationsWithAssets,
    ...locationsWithSubLocations,
    ...locationsWithSubAssets,
    ...locationsWithSubLocationsWithAssets,
    ...locationsWithSubLocationsWithSubAssets,
    ...locationsWithSubAssets2,
    ...locationsWithSubAssets3,
  ], [
    ...assets,
    ...assetsWithSubAssets,
    ...assets2,
  ]);
}

TreeNode applyFilter(
  List<LocationModel> locationsData,
  List<AssetModel> assetsData,
  List<AssetModel> components,
) {
  final assetsWithComponents = assetsData
      .where((asset) => components.any((comp) => asset.id == comp.parentId))
      .toList();

  final assetsWithSubAssets = assetsData
      .where((asset) =>
          assetsWithComponents.any((ass) => asset.id == ass.parentId))
      .toList();

  final locationsWithComponents = locationsData
      .where((loc) => components.any((comp) => loc.id == comp.locationId))
      .toList();

  final locationsWithAssets = locationsData
      .where(
          (loc) => assetsWithSubAssets.any((ass) => loc.id == ass.locationId))
      .toList();

  final locationsWithSubAssets = locationsData
      .where(
          (loc) => assetsWithComponents.any((ass) => loc.id == ass.locationId))
      .toList();

  final locationsWithSubLocations = locationsData
      .where((loc) =>
          locationsWithComponents.any((comp) => loc.id == comp.parentId))
      .toList();

  final locationsWithSubLocationsWithAssets = locationsData
      .where(
          (loc) => locationsWithAssets.any((comp) => loc.id == comp.parentId))
      .toList();

  final locationsWithSubLocationsWithSubAssets = locationsData
      .where((loc) =>
          locationsWithSubAssets.any((comp) => loc.id == comp.parentId))
      .toList();

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
