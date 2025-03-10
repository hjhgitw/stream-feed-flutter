import 'package:stream_feed/src/core/models/feed_id.dart';

class Routes {
  static const _addToManyPath = 'feed/add_to_many';
  static const _followManyPath = 'follow_many';
  static const _unfollowManyPath = 'unfollow_many';
  static const _activitiesPath = 'activities';
  static const _personalizationPath = 'personalization';
  static const _enrichPersonalizationPath = 'enrich/personalization';
  static const _personalizationFeedPath =
      '$_enrichPersonalizationPath/$_feedPath';
  static const _enrichActivitiesPath = 'enrich/$_activitiesPath';
  static const _activityUpdatePath = 'activity';
  static const _reactionsPath = 'reaction';
  static const _usersPath = 'user';
  static const _collectionsPath = 'collections';
  static const _openGraphPath = 'og';
  static const _feedPath = 'feed';
  static const _enrichedFeedPath = 'enrich/$_feedPath';
  static const _filesPath = 'files';
  static const _imagesPath = 'images';
  static const _refreshPath = 'refresh';

  static const _statsFollowPath = 'stats/follow/';

  static String buildFeedUrl(FeedId feed, [String path = '']) =>
      '$_feedPath/${feed.slug}/${feed.userId}/$path';

  static String buildPersonalizationURL(String resource, [String path = '']) =>
      '$_personalizationPath/$_feedPath/$resource/$path';

  static String buildEnrichedFeedUrl(FeedId feed, [String path = '']) =>
      '$_enrichedFeedPath/${feed.slug}/${feed.userId}/$path';

  static String get enrichedActivitiesUrl => _enrichActivitiesPath;

  static String buildCollectionsUrl([String? path = '']) =>
      '$_collectionsPath/$path';

  static String buildReactionsUrl([String path = '']) =>
      '$_reactionsPath/$path';

  static String buildRefreshCDNUrl([String? path = '']) =>
      '$path/$_refreshPath/';

  static String buildUsersUrl([String path = '']) => '$_usersPath/$path';

  static String get filesUrl => _filesPath;

  static String get imagesUrl => _imagesPath;

  static String get openGraphUrl => _openGraphPath;

  static String get activityUpdateUrl => _activityUpdatePath;

  static String get personalizedFeedUrl => _personalizationFeedPath;

  static String get addToManyUrl => _addToManyPath;

  static String get followManyUrl => _followManyPath;

  static String get unfollowManyUrl => _unfollowManyPath;

  static String get activitesUrl => _activitiesPath;

  static String get statsFollowUrl => _statsFollowPath;
}
