import 'package:stream_feed/src/core/api/feed_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/activity.dart';
import 'package:stream_feed/src/core/models/activity_marker.dart';
import 'package:stream_feed/src/core/models/enriched_activity.dart';
import 'package:stream_feed/src/core/models/enrichment_flags.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/models/filter.dart';
import 'package:stream_feed/src/core/models/personalized_feed.dart';
import 'package:stream_feed/src/core/util/default.dart';

import 'package:stream_feed/src/client/feed.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// {@template flatFeed}
///Flat is the default feed type -
///and the only feed type that you can follow.
///
///It's not possible to follow either aggregated or notification feeds.
///
/// You can create new feed groups based on the flat type in the dashboard.
/// {@endtemplate}
class FlatFeed extends Feed {
  /// Initialize a feed object
  FlatFeed(
    FeedId feedId,
    FeedAPI feed, {
    Token? userToken,
    String? secret,
    FeedSubscriber? subscriber,
  }) : super(
          feedId,
          feed,
          userToken: userToken,
          secret: secret,
          subscriber: subscriber,
        );

  ///Retrieves one activity from a feed
  Future<Activity> getActivityDetail(String activityId) async {
    final activities = await getActivities(
        limit: 1,
        filter: Filter()
            .idLessThanOrEqual(activityId)
            .idGreaterThanOrEqual(activityId));
    return activities.first;
  }

  ///Retrieves one activity from a feed
  Future<EnrichedActivity> getEnrichedActivityDetail(String activityId) async {
    final activities = await getEnrichedActivities(
        limit: 1,
        filter: Filter()
            .idLessThanOrEqual(activityId)
            .idGreaterThanOrEqual(activityId));
    return activities.first;
  }

  ///Retrieve activities
  ///# Example:
  /// Read Jack's timeline
  ///```dart
  ///  var activities = await jack.getActivities(limit: 10);
  /// ```
  Future<List<Activity>> getActivities({
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    String? ranking,
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...Default.marker.params,
      if (ranking != null) 'ranking': ranking,
      if (session != null) 'session': session,
    };
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);
    final result = await feed.getActivities(token, feedId, options);
    final data = (result.data!['results'] as List)
        .map((e) => Activity.fromJson(e))
        .toList(growable: false);
    return data;
  }

  /// Retrieve activities with reaction enrichment
  ///
  /// # Examples
  /// - read bob's timeline and include most recent reactions
  /// to all activities and their total count
  /// ```dart
  ///await client.flatFeed('timeline', 'bob').getEnrichedActivities(
  ///     flags: EnrichmentFlags().withRecentReactions().withReactionCounts(),
  ///   );
  /// ```
  /// - read bob's timeline and include most recent reactions
  /// to all activities and her own reactions
  /// ```dart
  /// await client.flatFeed('timeline', 'bob').getEnrichedActivities(
  ///      flags: EnrichmentFlags()
  ///         .withOwnReactions()
  ///         .withRecentReactions()
  ///         .withReactionCounts(),
  ///   );
  /// ```
  Future<List<EnrichedActivity>> getEnrichedActivities({
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    EnrichmentFlags? flags,
    String? ranking, //TODO: no way to parameterized marker?
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset, //TODO:add session everywhere
      ...filter?.params ?? Default.filter.params,
      ...Default.marker.params,
      if (flags != null) ...flags.params,
      if (ranking != null) 'ranking': ranking,
      if (session != null) 'session': session,
    };
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);
    final result = await feed.getEnrichedActivities(token, feedId, options);
    final data = (result.data['results'] as List)
        .map((e) => EnrichedActivity.fromJson(e))
        .toList(growable: false);
    return data;
  }

  Future<PersonalizedFeed> personalizedFeed({
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    ActivityMarker? marker,
    EnrichmentFlags? flags,
    String? ranking,
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...marker?.params ?? Default.marker.params,
      if (ranking != null) 'ranking': ranking,
      if (session != null) 'session': session,
    };
    final token = userToken ??
        TokenHelper.buildAnyToken(secret!, TokenAction.any,
            userId: feedId.userId);

    return feed.personalizedFeed(token, options);
  }
}
