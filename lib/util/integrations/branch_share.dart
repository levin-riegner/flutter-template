import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_template/util/integrations/branch_api.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ShareRequest extends Equatable {
  final String route;
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? slug;

  const ShareRequest({
    required this.route,
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.slug,
  });

  @override
  List<Object?> get props => [
        route,
        id,
        title,
        description,
        imageUrl,
        slug,
      ];
}

class BranchShareHelper {
  final String uriScheme;

  const BranchShareHelper({
    required this.uriScheme,
  });

  static const bool _defaultPubliclyIndex = true;
  static const List<String> _defaultKeywords = ["fluttertemplate"];
  static const String _defaultChannel = "app";
  static const String _defaultFeature = "share";
  static const String _defaultCampaign = "";

  (
    BranchUniversalObject buo,
    BranchLinkProperties lp,
  ) _buildBuoAndLp(
    ShareRequest request,
  ) {
    final buo = BranchUniversalObject(
      canonicalIdentifier: request.route,
      title: request.title,
      contentDescription: request.description ?? "",
      imageUrl: request.imageUrl ?? "",
      keywords: _defaultKeywords,
      publiclyIndex: _defaultPubliclyIndex,
    );
    final linkProperties = BranchLinkProperties(
      channel: _defaultChannel,
      feature: _defaultFeature,
      campaign: _defaultCampaign,
      alias: request.slug ?? "",
    );
    linkProperties.addControlParam(
      BranchApi.deeplinkPathKey,
      "$uriScheme:/${request.route}",
    );
    return (buo, linkProperties);
  }

  Future<bool> shareItem(
    BuildContext context,
    ShareRequest request,
  ) async {
    Flogger.i("Share item: ${request.route}");
    // TODO: Analytics share item?
    final (buo, lp) = _buildBuoAndLp(request);
    const shareTitle = "Check this out!"; // TODO: Add share title
    final response = await FlutterBranchSdk.getShortUrl(
      buo: buo,
      linkProperties: lp,
    );
    if (!response.success) {
      Flogger.w("Branch getShortUrl error: $response");
      return false;
    }
    final shareText = "$shareTitle\n${response.result!}";
    final result = await Share.share(shareText);
    return result.status == ShareResultStatus.success;
  }
}
