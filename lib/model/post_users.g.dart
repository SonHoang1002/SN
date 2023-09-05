// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_users.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPostDataUsersCollection on Isar {
  IsarCollection<PostDataUsers> get postDataUsers => this.collection();
}

const PostDataUsersSchema = CollectionSchema(
  name: r'PostUsersSchema',
  id: -7045986472829456806,
  properties: {
    r'listUser': PropertySchema(
      id: 0,
      name: r'listUser',
      type: IsarType.string,
    )
  },
  estimateSize: _postDataUsersEstimateSize,
  serialize: _postDataUsersSerialize,
  deserialize: _postDataUsersDeserialize,
  deserializeProp: _postDataUsersDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _postDataUsersGetId,
  getLinks: _postDataUsersGetLinks,
  attach: _postDataUsersAttach,
  version: '3.1.0+1',
);

int _postDataUsersEstimateSize(
  PostDataUsers object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.listUser;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _postDataUsersSerialize(
  PostDataUsers object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.listUser);
}

PostDataUsers _postDataUsersDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PostDataUsers();
  object.id = id;
  object.listUser = reader.readStringOrNull(offsets[0]);
  return object;
}

P _postDataUsersDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _postDataUsersGetId(PostDataUsers object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _postDataUsersGetLinks(PostDataUsers object) {
  return [];
}

void _postDataUsersAttach(
    IsarCollection<dynamic> col, Id id, PostDataUsers object) {
  object.id = id;
}

extension PostDataUsersQueryWhereSort
    on QueryBuilder<PostDataUsers, PostDataUsers, QWhere> {
  QueryBuilder<PostDataUsers, PostDataUsers, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PostDataUsersQueryWhere
    on QueryBuilder<PostDataUsers, PostDataUsers, QWhereClause> {
  QueryBuilder<PostDataUsers, PostDataUsers, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PostDataUsersQueryFilter
    on QueryBuilder<PostDataUsers, PostDataUsers, QFilterCondition> {
  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition>
      listUserIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'listUser',
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition>
      listUserIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'listUser',
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition>
      listUserEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'listUser',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition>
      listUserGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'listUser',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition>
      listUserLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'listUser',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition>
      listUserBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'listUser',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition>
      listUserStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'listUser',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition>
      listUserEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'listUser',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition>
      listUserContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'listUser',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition>
      listUserMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'listUser',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition>
      listUserIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'listUser',
        value: '',
      ));
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterFilterCondition>
      listUserIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'listUser',
        value: '',
      ));
    });
  }
}

extension PostDataUsersQueryObject
    on QueryBuilder<PostDataUsers, PostDataUsers, QFilterCondition> {}

extension PostDataUsersQueryLinks
    on QueryBuilder<PostDataUsers, PostDataUsers, QFilterCondition> {}

extension PostDataUsersQuerySortBy
    on QueryBuilder<PostDataUsers, PostDataUsers, QSortBy> {
  QueryBuilder<PostDataUsers, PostDataUsers, QAfterSortBy> sortByListUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listUser', Sort.asc);
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterSortBy>
      sortByListUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listUser', Sort.desc);
    });
  }
}

extension PostDataUsersQuerySortThenBy
    on QueryBuilder<PostDataUsers, PostDataUsers, QSortThenBy> {
  QueryBuilder<PostDataUsers, PostDataUsers, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterSortBy> thenByListUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listUser', Sort.asc);
    });
  }

  QueryBuilder<PostDataUsers, PostDataUsers, QAfterSortBy>
      thenByListUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listUser', Sort.desc);
    });
  }
}

extension PostDataUsersQueryWhereDistinct
    on QueryBuilder<PostDataUsers, PostDataUsers, QDistinct> {
  QueryBuilder<PostDataUsers, PostDataUsers, QDistinct> distinctByListUser(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'listUser', caseSensitive: caseSensitive);
    });
  }
}

extension PostDataUsersQueryProperty
    on QueryBuilder<PostDataUsers, PostDataUsers, QQueryProperty> {
  QueryBuilder<PostDataUsers, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PostDataUsers, String?, QQueryOperations> listUserProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'listUser');
    });
  }
}
