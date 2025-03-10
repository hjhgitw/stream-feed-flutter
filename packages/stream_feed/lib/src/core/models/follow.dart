import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'follow.g.dart';

///
@JsonSerializable()
class Follow extends Equatable {
  ///
  const Follow({
    required this.feedId,
    required this.targetId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new instance from a json
  factory Follow.fromJson(Map<String, dynamic> json) => _$FollowFromJson(json);

  /// The combination of feed slug and user id separated by a colon
  ///For example: flat:1
  final String feedId;

  /// the id of the feed you want to follow
  final String targetId;

  ///Date at which the follow relationship was created
  final DateTime createdAt;

  ///Date at which the follow relationship was updated
  final DateTime updatedAt;

  @override
  List<Object?> get props => [feedId, targetId, createdAt, updatedAt];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FollowToJson(this);
}
