import '../models/asset_model.dart';
import '../models/location_model.dart';
import 'tree_builder.dart';

TreeNode filterByEnergySensor(
  List<LocationModel> locationsData,
  List<AssetModel> assetsData,
  Function(int) resultCount,
) {
  final components = assetsData
      .where(
        (component) =>
            component.status != Status.alert &&
            component.gatewayId != null &&
            component.sensorType != null,
      )
      .toList();

  resultCount(components.length);

  return filterAssetsAndLocations(
    locationsData,
    assetsData,
    components,
  );
}

TreeNode filterByCriticalAssets(
  List<LocationModel> locationsData,
  List<AssetModel> assetsData,
  Function(int) resultCount,
) {
  final components = assetsData
      .where((component) => component.status == Status.alert)
      .toList();

  resultCount(components.length);

  return filterAssetsAndLocations(
    locationsData,
    assetsData,
    components,
  );
}

TreeNode filterByText(
  List<LocationModel> locationsData,
  List<AssetModel> assetsData,
  String term,
) {
  final assetsWithTerm = assetsData
      .where((asset) => asset.name.toLowerCase().contains(term))
      .toList();
  final subAssets = filterAssetsByAssets(assetsData, assetsWithTerm);
  final assets = filterAssetsByAssets(assetsData, subAssets);

  List<AssetModel> uniqueAssets = removeAssetsDuplicates([
    ...assets,
    ...subAssets,
    ...assetsWithTerm,
  ]);

  return buildTree(
    locationsData: locationsData,
    assetsData: uniqueAssets,
    term: term,
  );
}

TreeNode filterAssetsAndLocations(
  List<LocationModel> locationsData,
  List<AssetModel> assetsData,
  List<AssetModel> components,
) {
  final subAssets = filterAssetsByAssets(assetsData, components);
  final assets = filterAssetsByAssets(assetsData, subAssets);

  return buildTree(
    locationsData: locationsData,
    assetsData: [...assets, ...subAssets],
    componentsData: components,
    shouldFilter: true,
  );
}

List<AssetModel> filterAssetsByAssets(
  List<AssetModel> allAssets,
  List<AssetModel> parentAssets,
) {
  final parentIds = parentAssets.map((asset) => asset.parentId).toSet();

  return allAssets.where((asset) => parentIds.contains(asset.id)).toList();
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
