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
