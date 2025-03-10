import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/lookup_attribute.dart';
import 'package:stream_feed/src/core/models/filter.dart';
import 'package:stream_feed/src/core/models/paginated_reactions.dart';
import 'package:stream_feed/src/core/models/reaction.dart';
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/src/core/util/routes.dart';

/// The http layer api for CRUD operations on Reactions
class ReactionsAPI {
  /// [ReactionsAPI] constructor
  const ReactionsAPI(this._client);

  final StreamHttpClient _client;

  ///Add reaction
  Future<Reaction> add(Token token, Reaction reaction) async {
    checkArgument(reaction.activityId != null || reaction.parent != null,
        'Reaction has to either have an activity ID or parent');
    checkArgument(reaction.activityId == null || reaction.parent == null,
        "Reaction can't have both activity ID and parent");
    if (reaction.activityId != null) {
      checkArgument(reaction.activityId!.isNotEmpty,
          "Reaction activity ID can't be empty");
    }
    if (reaction.parent != null) {
      checkArgument(
          reaction.parent!.isNotEmpty, "Reaction parent can't be empty");
    }
    checkNotNull(reaction.kind, "Reaction kind can't be null");
    checkArgument(reaction.kind!.isNotEmpty, "Reaction kind can't be empty");
    final result = await _client.post<Map<String, dynamic>>(
      Routes.buildReactionsUrl(),
      headers: {'Authorization': '$token'},
      data: reaction,
    );
    return Reaction.fromJson(result.data!);
  }

  /// Get reaction
  Future<Reaction> get(Token token, String id) async {
    checkArgument(id.isNotEmpty, "Reaction id can't be empty");
    final result = await _client.get<Map<String, dynamic>>(
      Routes.buildReactionsUrl('$id/'),
      headers: {'Authorization': '$token'},
    );
    return Reaction.fromJson(result.data!);
  }

  /// Delete reaction
  Future<Response> delete(Token token, String id) async {
    checkArgument(id.isNotEmpty, "Reaction id can't be empty");
    return _client.delete(
      Routes.buildReactionsUrl('$id/'),
      headers: {'Authorization': '$token'},
    );
  }

  ///read reactions and filter them
  /// Parameters:
  /// - [lookupAttr]: name of the reaction attribute to paginate on.
  /// Can be activity_id, reaction_id or user_id.
  /// - [lookupValue]: value to use
  /// depending if paginating reactions for an activity,
  /// from a user or reactions of a reaction.
  /// - [kind]: type of reaction( e.g.: like).
  Future<List<Reaction>> filter(
    Token token,
    LookupAttribute lookupAttr,
    String lookupValue,
    Filter filter,
    int limit,
    String kind,
  ) async {
    checkArgument(lookupValue.isNotEmpty, "Lookup value can't be empty");
    final result = await _client.get<Map>(
      Routes.buildReactionsUrl('${lookupAttr.attr}/$lookupValue/$kind'),
      headers: {'Authorization': '$token'},
      queryParameters: {
        'limit': limit.toString(),
        ...filter.params,
        'with_activity_data': lookupAttr == LookupAttribute.activityId,
      },
    );
    final data = (result.data!['results'] as List)
        .map((e) => Reaction.fromJson(e))
        .toList(growable: false);
    return data;
  }

  ///paginated reactions and filter them
  Future<PaginatedReactions> paginatedFilter(
    Token token,
    LookupAttribute lookupAttr,
    String lookupValue,
    Filter filter,
    int limit,
    String kind,
  ) async {
    checkArgument(lookupValue.isNotEmpty, "Lookup value can't be empty");

    final result = await _client.get(
      Routes.buildReactionsUrl('${lookupAttr.attr}/$lookupValue/$kind'),
      headers: {'Authorization': '$token'},
      queryParameters: {
        'limit': limit.toString(),
        ...filter.params,
        'with_activity_data': lookupAttr == LookupAttribute.activityId,
      },
    );
    return PaginatedReactions.fromJson(result.data);
  }

  /// Next reaction pagination returned by [PaginatedReactions].next
  Future<PaginatedReactions> nextPaginatedFilter(
      Token token, String next) async {
    checkArgument(next.isNotEmpty, "Next url can't be empty");
    final result = await _client.get(
      next,
      headers: {'Authorization': '$token'},
    );
    return PaginatedReactions.fromJson(result.data);
  }

  /// update a reaction
  Future<Reaction> update(Token token, Reaction updatedReaction) async {
    checkArgument(updatedReaction.id!.isNotEmpty, "Reaction id can't be empty");
    final targetFeedIds = updatedReaction.targetFeeds
        ?.map((e) => e.toString())
        .toList(growable: false);

    final reactionId = updatedReaction.id;
    final data = updatedReaction.data;
    final response = await _client.put<Map<String, dynamic>>(
      Routes.buildReactionsUrl('$reactionId/'),
      headers: {'Authorization': '$token'},
      data: {
        if (data != null && data.isNotEmpty) 'data': data,
        if (targetFeedIds?.isNotEmpty == true) 'target_feeds': targetFeedIds,
      },
    );

    return Reaction.fromJson(response.data!);
  }
}
