import 'package:equatable/equatable.dart';

class BookModel extends Equatable {
  // Supabase fields
  final String? id;
  final String? userId;
  final bool custom;

  // Core book info
  final String title;
  final List<String>? authorKey;
  final List<String>? authorName;

  // Open Library data
  final String? bookKey; // Mapped from "key"
  final String? coverEditionKey;
  final int? coverI;

  final String? coverPhotoUrl;
  final String? authorPhotoUrl;
  final String? ebookAccess;
  final int? editionCount;
  final int? firstPublishYear;
  final bool? hasFulltext;
  final List<String>? ia;
  final String? iaCollectionS;
  final List<String>? language;
  final String? lendingEditionS;
  final String? lendingIdentifierS;
  final bool? publicScanB;

  // Detail fields (from detail API)
  final String? description;
  final List<String>? subjects;
  final List<String>? publishers;
  final int? numberOfPages;
  final String? publishDate;
  final Map<String, String>? coverUrls; // small, medium, large

  // Reading progress & planning
  final DateTime? startedTime;
  final bool completed;
  final DateTime? endDate;
  final DateTime? whenToRead;
  final int? durationToRead;
  final int? currentPage;

  const BookModel({
    this.id,
    this.userId,
    this.custom = false,
    required this.title,
    this.authorKey,
    this.authorName,
    this.bookKey,
    this.coverEditionKey,
    this.coverI,
    this.coverPhotoUrl,
    this.authorPhotoUrl,
    this.ebookAccess,
    this.editionCount,
    this.firstPublishYear,
    this.hasFulltext,
    this.ia,
    this.iaCollectionS,
    this.language,
    this.lendingEditionS,
    this.lendingIdentifierS,
    this.publicScanB,
    this.description,
    this.subjects,
    this.publishers,
    this.numberOfPages,
    this.publishDate,
    this.coverUrls,
    this.startedTime,
    this.completed = false,
    this.endDate,
    this.whenToRead,
    this.durationToRead,
    this.currentPage,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    // Parse authors from detail API format
    List<String>? parseAuthorNames(dynamic authorsJson) {
      if (authorsJson is List) {
        return authorsJson
            .map((e) => e is Map ? (e['name'] as String?) ?? '' : e.toString())
            .where((name) => name.isNotEmpty)
            .toList();
      }
      return null;
    }

    // Parse subjects from detail API format
    List<String>? parseSubjects(dynamic subjectsJson) {
      if (subjectsJson is List) {
        return subjectsJson
            .map((e) => e is Map ? (e['name'] as String?) ?? '' : e.toString())
            .where((name) => name.isNotEmpty)
            .toList();
      }
      return null;
    }

    // Parse publishers from detail API format
    List<String>? parsePublishers(dynamic publishersJson) {
      if (publishersJson is List) {
        return publishersJson
            .map((e) => e is Map ? (e['name'] as String?) ?? '' : e.toString())
            .where((name) => name.isNotEmpty)
            .toList();
      }
      return null;
    }

    // Parse cover URLs from detail API format
    Map<String, String>? parseCoverUrls(dynamic coverJson) {
      if (coverJson is Map) {
        return {
          if (coverJson['small'] != null) 'small': coverJson['small'] as String,
          if (coverJson['medium'] != null)
            'medium': coverJson['medium'] as String,
          if (coverJson['large'] != null) 'large': coverJson['large'] as String,
        };
      }
      return null;
    }

    // Parse description from detail API (can be in excerpts or description field)
    String? parseDescription(Map<String, dynamic> json) {
      if (json['excerpts'] != null && json['excerpts'] is List) {
        final excerpts = json['excerpts'] as List;
        if (excerpts.isNotEmpty && excerpts.first is Map) {
          return excerpts.first['text'] as String?;
        }
      }
      if (json['description'] is String) {
        return json['description'] as String;
      }
      return null;
    }

    return BookModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      custom: json['custom'] as bool? ?? false,
      title: json['title'] as String? ?? 'Unknown Title',
      authorKey: (json['author_key'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      authorName: (json['author_name'] as List<dynamic>?) != null
          ? (json['author_name'] as List<dynamic>)
                .map((e) => e as String)
                .toList()
          : parseAuthorNames(json['authors']),
      bookKey: json['book_key'] as String? ?? json['key'] as String?,
      coverEditionKey: json['cover_edition_key'] as String?,
      coverI: json['cover_i'] as int?,
      coverPhotoUrl: json['cover_photo_url'] as String?,
      authorPhotoUrl: json['author_photo_url'] as String?,
      ebookAccess: json['ebook_access'] as String?,
      editionCount: json['edition_count'] as int?,
      firstPublishYear: json['first_publish_year'] as int?,
      hasFulltext: json['has_fulltext'] as bool?,
      ia: (json['ia'] as List<dynamic>?)?.map((e) => e as String).toList(),
      iaCollectionS: json['ia_collection_s'] as String?,
      language: (json['language'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      lendingEditionS: json['lending_edition_s'] as String?,
      lendingIdentifierS: json['lending_identifier_s'] as String?,
      publicScanB: json['public_scan_b'] as bool?,
      description: parseDescription(json),
      subjects: parseSubjects(json['subjects']),
      publishers: parsePublishers(json['publishers']),
      numberOfPages: json['number_of_pages'] as int?,
      publishDate: json['publish_date'] as String?,
      coverUrls: parseCoverUrls(json['cover']),
      startedTime: json['started_time'] != null
          ? DateTime.tryParse(json['started_time'] as String)
          : null,
      completed: json['completed'] as bool? ?? false,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'] as String)
          : null,
      whenToRead: json['when_to_read'] != null
          ? DateTime.tryParse(json['when_to_read'] as String)
          : null,
      durationToRead: json['duration_to_read'] as int?,
      currentPage: json['current_page'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'custom': custom,
      'title': title,
      'author_key': authorKey,
      'author_name': authorName,
      'book_key': bookKey,
      'cover_edition_key': coverEditionKey,
      'cover_i': coverI,
      'cover_photo_url': coverPhotoUrl,
      'author_photo_url': authorPhotoUrl,
      'ebook_access': ebookAccess,
      'edition_count': editionCount,
      'first_publish_year': firstPublishYear,
      'has_fulltext': hasFulltext,
      'ia': ia,
      'ia_collection_s': iaCollectionS,
      'language': language,
      'lending_edition_s': lendingEditionS,
      'lending_identifier_s': lendingIdentifierS,
      'public_scan_b': publicScanB,
      'description': description,
      'subjects': subjects,
      'publishers': publishers,
      'number_of_pages': numberOfPages,
      'publish_date': publishDate,
      'cover': coverUrls,
      'started_time': startedTime?.toIso8601String(),
      'completed': completed,
      'end_date': endDate?.toIso8601String(),
      'when_to_read': whenToRead?.toIso8601String(),
      'duration_to_read': durationToRead,
      'current_page': currentPage,
    };
  }

  BookModel copyWith({
    String? id,
    String? userId,
    bool? custom,
    String? title,
    List<String>? authorKey,
    List<String>? authorName,
    String? bookKey,
    String? coverEditionKey,
    int? coverI,
    String? coverPhotoUrl,
    String? authorPhotoUrl,
    String? ebookAccess,
    int? editionCount,
    int? firstPublishYear,
    bool? hasFulltext,
    List<String>? ia,
    String? iaCollectionS,
    List<String>? language,
    String? lendingEditionS,
    String? lendingIdentifierS,
    bool? publicScanB,
    String? description,
    List<String>? subjects,
    List<String>? publishers,
    int? numberOfPages,
    String? publishDate,
    Map<String, String>? coverUrls,
    DateTime? startedTime,
    bool? completed,
    DateTime? endDate,
    DateTime? whenToRead,
    int? durationToRead,
    int? currentPage,
  }) {
    return BookModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      custom: custom ?? this.custom,
      title: title ?? this.title,
      authorKey: authorKey ?? this.authorKey,
      authorName: authorName ?? this.authorName,
      bookKey: bookKey ?? this.bookKey,
      coverEditionKey: coverEditionKey ?? this.coverEditionKey,
      coverI: coverI ?? this.coverI,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
      authorPhotoUrl: authorPhotoUrl ?? this.authorPhotoUrl,
      ebookAccess: ebookAccess ?? this.ebookAccess,
      editionCount: editionCount ?? this.editionCount,
      firstPublishYear: firstPublishYear ?? this.firstPublishYear,
      hasFulltext: hasFulltext ?? this.hasFulltext,
      ia: ia ?? this.ia,
      iaCollectionS: iaCollectionS ?? this.iaCollectionS,
      language: language ?? this.language,
      lendingEditionS: lendingEditionS ?? this.lendingEditionS,
      lendingIdentifierS: lendingIdentifierS ?? this.lendingIdentifierS,
      publicScanB: publicScanB ?? this.publicScanB,
      description: description ?? this.description,
      subjects: subjects ?? this.subjects,
      publishers: publishers ?? this.publishers,
      numberOfPages: numberOfPages ?? this.numberOfPages,
      publishDate: publishDate ?? this.publishDate,
      coverUrls: coverUrls ?? this.coverUrls,
      startedTime: startedTime ?? this.startedTime,
      completed: completed ?? this.completed,
      endDate: endDate ?? this.endDate,
      whenToRead: whenToRead ?? this.whenToRead,
      durationToRead: durationToRead ?? this.durationToRead,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    custom,
    title,
    authorKey,
    authorName,
    bookKey,
    coverEditionKey,
    coverI,
    coverPhotoUrl,
    authorPhotoUrl,
    ebookAccess,
    editionCount,
    firstPublishYear,
    hasFulltext,
    ia,
    iaCollectionS,
    language,
    lendingEditionS,
    lendingIdentifierS,
    publicScanB,
    description,
    subjects,
    publishers,
    numberOfPages,
    publishDate,
    coverUrls,
    startedTime,
    completed,
    endDate,
    whenToRead,
    durationToRead,
    currentPage,
  ];
}
