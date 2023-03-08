// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  Post({
    required this.id,
    required this.createdAt,
    required this.backdatedTime,
    this.inReplyToId,
    this.inReplyToAccountId,
    required this.sensitive,
    required this.spoilerText,
    required this.visibility,
    required this.language,
    this.postType,
    required this.repliesCount,
    required this.offComment,
    required this.reblogsCount,
    required this.favouritesCount,
    required this.reactions,
    required this.repliesTotal,
    required this.score,
    required this.hidden,
    required this.notify,
    required this.processing,
    required this.commentModeration,
    this.viewerReaction,
    required this.reblogged,
    required this.muted,
    required this.bookmarked,
    this.pinned,
    required this.content,
    this.card,
    this.inReplyToParentId,
    this.reblog,
    required this.application,
    required this.account,
    this.statusBackground,
    this.statusActivity,
    this.tagablePage,
    this.place,
    this.pageOwner,
    this.album,
    this.event,
    this.project,
    this.course,
    this.series,
    this.sharedEvent,
    this.sharedProject,
    this.sharedRecruit,
    this.sharedCourse,
    this.sharedPage,
    this.sharedGroup,
    this.targetAccount,
    required this.mediaAttachments,
    required this.mentions,
    required this.tags,
    required this.replies,
    required this.favourites,
    required this.emojis,
    required this.statusTags,
    this.poll,
    this.lifeEvent,
    required this.statusQuestion,
    this.statusTarget,
  });

  String id;
  DateTime createdAt;
  DateTime backdatedTime;
  dynamic inReplyToId;
  dynamic inReplyToAccountId;
  bool sensitive;
  String spoilerText;
  String visibility;
  String language;
  dynamic postType;
  int repliesCount;
  bool offComment;
  int reblogsCount;
  int favouritesCount;
  List<Reaction> reactions;
  int repliesTotal;
  String score;
  bool hidden;
  bool notify;
  String processing;
  String commentModeration;
  dynamic viewerReaction;
  bool reblogged;
  bool muted;
  bool bookmarked;
  dynamic pinned;
  String content;
  dynamic card;
  dynamic inReplyToParentId;
  dynamic reblog;
  Application application;
  Account account;
  dynamic statusBackground;
  dynamic statusActivity;
  dynamic tagablePage;
  dynamic place;
  dynamic pageOwner;
  dynamic album;
  dynamic event;
  dynamic project;
  dynamic course;
  dynamic series;
  dynamic sharedEvent;
  dynamic sharedProject;
  dynamic sharedRecruit;
  dynamic sharedCourse;
  dynamic sharedPage;
  dynamic sharedGroup;
  dynamic targetAccount;
  List<AvatarMedia> mediaAttachments;
  List<dynamic> mentions;
  List<dynamic> tags;
  List<dynamic> replies;
  List<dynamic> favourites;
  List<dynamic> emojis;
  List<dynamic> statusTags;
  dynamic poll;
  dynamic lifeEvent;
  StatusQuestion statusQuestion;
  dynamic statusTarget;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        backdatedTime: DateTime.parse(json["backdated_time"]),
        inReplyToId: json["in_reply_to_id"],
        inReplyToAccountId: json["in_reply_to_account_id"],
        sensitive: json["sensitive"],
        spoilerText: json["spoiler_text"],
        visibility: json["visibility"],
        language: json["language"],
        postType: json["post_type"],
        repliesCount: json["replies_count"],
        offComment: json["off_comment"],
        reblogsCount: json["reblogs_count"],
        favouritesCount: json["favourites_count"],
        reactions: List<Reaction>.from(
            json["reactions"].map((x) => Reaction.fromJson(x))),
        repliesTotal: json["replies_total"],
        score: json["score"],
        hidden: json["hidden"],
        notify: json["notify"],
        processing: json["processing"],
        commentModeration: json["comment_moderation"],
        viewerReaction: json["viewer_reaction"],
        reblogged: json["reblogged"],
        muted: json["muted"],
        bookmarked: json["bookmarked"],
        pinned: json["pinned"],
        content: json["content"],
        card: json["card"],
        inReplyToParentId: json["in_reply_to_parent_id"],
        reblog: json["reblog"],
        application: Application.fromJson(json["application"]),
        account: Account.fromJson(json["account"]),
        statusBackground: json["status_background"],
        statusActivity: json["status_activity"],
        tagablePage: json["tagable_page"],
        place: json["place"],
        pageOwner: json["page_owner"],
        album: json["album"],
        event: json["event"],
        project: json["project"],
        course: json["course"],
        series: json["series"],
        sharedEvent: json["shared_event"],
        sharedProject: json["shared_project"],
        sharedRecruit: json["shared_recruit"],
        sharedCourse: json["shared_course"],
        sharedPage: json["shared_page"],
        sharedGroup: json["shared_group"],
        targetAccount: json["target_account"],
        mediaAttachments: List<AvatarMedia>.from(
            json["media_attachments"].map((x) => AvatarMedia.fromJson(x))),
        mentions: List<dynamic>.from(json["mentions"].map((x) => x)),
        tags: List<dynamic>.from(json["tags"].map((x) => x)),
        replies: List<dynamic>.from(json["replies"].map((x) => x)),
        favourites: List<dynamic>.from(json["favourites"].map((x) => x)),
        emojis: List<dynamic>.from(json["emojis"].map((x) => x)),
        statusTags: List<dynamic>.from(json["status_tags"].map((x) => x)),
        poll: json["poll"],
        lifeEvent: json["life_event"],
        statusQuestion: StatusQuestion.fromJson(json["status_question"]),
        statusTarget: json["status_target"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "backdated_time": backdatedTime.toIso8601String(),
        "in_reply_to_id": inReplyToId,
        "in_reply_to_account_id": inReplyToAccountId,
        "sensitive": sensitive,
        "spoiler_text": spoilerText,
        "visibility": visibility,
        "language": language,
        "post_type": postType,
        "replies_count": repliesCount,
        "off_comment": offComment,
        "reblogs_count": reblogsCount,
        "favourites_count": favouritesCount,
        "reactions": List<dynamic>.from(reactions.map((x) => x.toJson())),
        "replies_total": repliesTotal,
        "score": score,
        "hidden": hidden,
        "notify": notify,
        "processing": processing,
        "comment_moderation": commentModeration,
        "viewer_reaction": viewerReaction,
        "reblogged": reblogged,
        "muted": muted,
        "bookmarked": bookmarked,
        "pinned": pinned,
        "content": content,
        "card": card,
        "in_reply_to_parent_id": inReplyToParentId,
        "reblog": reblog,
        "application": application.toJson(),
        "account": account.toJson(),
        "status_background": statusBackground,
        "status_activity": statusActivity,
        "tagable_page": tagablePage,
        "place": place,
        "page_owner": pageOwner,
        "album": album,
        "event": event,
        "project": project,
        "course": course,
        "series": series,
        "shared_event": sharedEvent,
        "shared_project": sharedProject,
        "shared_recruit": sharedRecruit,
        "shared_course": sharedCourse,
        "shared_page": sharedPage,
        "shared_group": sharedGroup,
        "target_account": targetAccount,
        "media_attachments":
            List<dynamic>.from(mediaAttachments.map((x) => x.toJson())),
        "mentions": List<dynamic>.from(mentions.map((x) => x)),
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "replies": List<dynamic>.from(replies.map((x) => x)),
        "favourites": List<dynamic>.from(favourites.map((x) => x)),
        "emojis": List<dynamic>.from(emojis.map((x) => x)),
        "status_tags": List<dynamic>.from(statusTags.map((x) => x)),
        "poll": poll,
        "life_event": lifeEvent,
        "status_question": statusQuestion.toJson(),
        "status_target": statusTarget,
      };
}

class Account {
  Account({
    required this.id,
    required this.username,
    required this.acct,
    required this.displayName,
    required this.locked,
    required this.bot,
    required this.discoverable,
    required this.group,
    required this.createdAt,
    required this.note,
    required this.followersCount,
    required this.followingCount,
    required this.statusesCount,
    required this.lastStatusAt,
    required this.friendsCount,
    required this.theme,
    required this.avatarStatic,
    required this.emojis,
    this.banner,
    required this.avatarMedia,
    required this.fields,
  });

  String id;
  String username;
  String acct;
  String displayName;
  bool locked;
  bool bot;
  bool discoverable;
  bool group;
  DateTime createdAt;
  String note;
  int followersCount;
  int followingCount;
  int statusesCount;
  DateTime lastStatusAt;
  int friendsCount;
  String theme;
  String avatarStatic;
  List<dynamic> emojis;
  dynamic banner;
  AvatarMedia avatarMedia;
  List<dynamic> fields;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json["id"],
        username: json["username"],
        acct: json["acct"],
        displayName: json["display_name"],
        locked: json["locked"],
        bot: json["bot"],
        discoverable: json["discoverable"],
        group: json["group"],
        createdAt: DateTime.parse(json["created_at"]),
        note: json["note"],
        followersCount: json["followers_count"],
        followingCount: json["following_count"],
        statusesCount: json["statuses_count"],
        lastStatusAt: DateTime.parse(json["last_status_at"]),
        friendsCount: json["friends_count"],
        theme: json["theme"],
        avatarStatic: json["avatar_static"],
        emojis: List<dynamic>.from(json["emojis"].map((x) => x)),
        banner: json["banner"],
        avatarMedia: AvatarMedia.fromJson(json["avatar_media"]),
        fields: List<dynamic>.from(json["fields"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "acct": acct,
        "display_name": displayName,
        "locked": locked,
        "bot": bot,
        "discoverable": discoverable,
        "group": group,
        "created_at": createdAt.toIso8601String(),
        "note": note,
        "followers_count": followersCount,
        "following_count": followingCount,
        "statuses_count": statusesCount,
        "last_status_at":
            "${lastStatusAt.year.toString().padLeft(4, '0')}-${lastStatusAt.month.toString().padLeft(2, '0')}-${lastStatusAt.day.toString().padLeft(2, '0')}",
        "friends_count": friendsCount,
        "theme": theme,
        "avatar_static": avatarStatic,
        "emojis": List<dynamic>.from(emojis.map((x) => x)),
        "banner": banner,
        "avatar_media": avatarMedia.toJson(),
        "fields": List<dynamic>.from(fields.map((x) => x)),
      };
}

class AvatarMedia {
  AvatarMedia({
    required this.id,
    required this.type,
    required this.url,
    required this.previewUrl,
    this.remoteUrl,
    this.previewRemoteUrl,
    this.textUrl,
    required this.meta,
    this.description,
    required this.blurhash,
    required this.statusId,
    this.showUrl,
    required this.createdAt,
    this.frame,
  });

  String id;
  String type;
  String url;
  String previewUrl;
  dynamic remoteUrl;
  dynamic previewRemoteUrl;
  dynamic textUrl;
  Meta meta;
  String? description;
  String blurhash;
  String statusId;
  String? showUrl;
  DateTime createdAt;
  dynamic frame;

  factory AvatarMedia.fromJson(Map<String, dynamic> json) => AvatarMedia(
        id: json["id"],
        type: json["type"],
        url: json["url"],
        previewUrl: json["preview_url"],
        remoteUrl: json["remote_url"],
        previewRemoteUrl: json["preview_remote_url"],
        textUrl: json["text_url"],
        meta: Meta.fromJson(json["meta"]),
        description: json["description"],
        blurhash: json["blurhash"],
        statusId: json["status_id"],
        showUrl: json["show_url"],
        createdAt: DateTime.parse(json["created_at"]),
        frame: json["frame"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "url": url,
        "preview_url": previewUrl,
        "remote_url": remoteUrl,
        "preview_remote_url": previewRemoteUrl,
        "text_url": textUrl,
        "meta": meta.toJson(),
        "description": description,
        "blurhash": blurhash,
        "status_id": statusId,
        "show_url": showUrl,
        "created_at": createdAt.toIso8601String(),
        "frame": frame,
      };
}

class Meta {
  Meta({
    required this.original,
    required this.small,
  });

  Original original;
  Original small;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        original: Original.fromJson(json["original"]),
        small: Original.fromJson(json["small"]),
      );

  Map<String, dynamic> toJson() => {
        "original": original.toJson(),
        "small": small.toJson(),
      };
}

class Original {
  Original({
    required this.width,
    required this.height,
    required this.size,
    required this.aspect,
    required this.averageColor,
  });

  int width;
  int height;
  String size;
  double aspect;
  String averageColor;

  factory Original.fromJson(Map<String, dynamic> json) => Original(
        width: json["width"],
        height: json["height"],
        size: json["size"],
        aspect: json["aspect"]?.toDouble(),
        averageColor: json["average_color"],
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
        "size": size,
        "aspect": aspect,
        "average_color": averageColor,
      };
}

class Application {
  Application({
    required this.name,
    this.website,
  });

  String name;
  dynamic website;

  factory Application.fromJson(Map<String, dynamic> json) => Application(
        name: json["name"],
        website: json["website"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "website": website,
      };
}

class Reaction {
  Reaction({
    required this.type,
    this.likesCount,
    this.hahasCount,
    this.angrysCount,
    this.lovesCount,
    this.sadsCount,
    this.wowsCount,
    this.yaysCount,
  });

  String type;
  int? likesCount;
  int? hahasCount;
  int? angrysCount;
  int? lovesCount;
  int? sadsCount;
  int? wowsCount;
  int? yaysCount;

  factory Reaction.fromJson(Map<String, dynamic> json) => Reaction(
        type: json["type"],
        likesCount: json["likes_count"],
        hahasCount: json["hahas_count"],
        angrysCount: json["angrys_count"],
        lovesCount: json["loves_count"],
        sadsCount: json["sads_count"],
        wowsCount: json["wows_count"],
        yaysCount: json["yays_count"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "likes_count": likesCount,
        "hahas_count": hahasCount,
        "angrys_count": angrysCount,
        "loves_count": lovesCount,
        "sads_count": sadsCount,
        "wows_count": wowsCount,
        "yays_count": yaysCount,
      };
}

class StatusQuestion {
  StatusQuestion({
    required this.content,
    this.color,
  });

  String content;
  dynamic color;

  factory StatusQuestion.fromJson(Map<String, dynamic> json) => StatusQuestion(
        content: json["content"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "color": color,
      };
}
