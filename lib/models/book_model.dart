//bookmodel
class Books {
  String id; //properties (instance fields) for the class
  String title;
  String author;
  int year;
  String genre;
  List<String> tropes; //list of trope strings
  int? coverId; //ok to not have a coverId
  String workKey; //unique identifier
  String? description; //ok to not have a description

  Books({
    //lets you create an instance of books with no arguments
    this.id = "",
    this.title = "",
    this.author = "",
    this.year = 0,
    this.genre = "",
    this.tropes = const [],
    this.coverId,
    this.workKey = "",
    this.description,
  });

  String get coverUrl =>
      coverId !=
          null //getter (read only) for coverId
      //if coverId is not null, build cover using this URL, otherwise use placeholder
      ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
      : 'https://via.placeholder.com/60x100';

  factory Books.fromJson(Map<String, dynamic> json) {
    //creates books instance from JSON Map<String, dynamic>
    int? parseInt(dynamic v) {
      //helperfuction to convert to int? to avoid crashes if JSON contains a number as int/double/string
      if (v == null) return null; //if null return null
      if (v is int) return v; //if int return int
      if (v is double)
        return v.toInt(); //if double return int (drop the fractional)
      if (v is String) return int.tryParse(v); //if string try to to parse
      return null; //otherwise return null
    }

    final bool
    isOpenLibrary = //checks if incoming JSON looks like an OpenLibrary response
        json.containsKey('author_name') || //usual fields in OpenLibrary
        json.containsKey('cover_i') ||
        json.containsKey('first_publish_year') ||
        (json['key'] != null &&
            (json['key'] as String).startsWith(
              '/works/',
            )); //OpenLibrary has keys that start with /works/

    if (isOpenLibrary) {
      //if JSON is determined to be from OpenLibrary, build book instance
      return Books(
        id: json['key'] ?? '', //id is openlibrary's key, '' as fallback
        title:
            json['title'] ??
            'Unknown title', //title is openlibrary's title, if not available make it unknown title
        author: //openlibrary returns a list of authors, take the first one
            (json['author_name'] is List && //checks if field is a list
                (json['author_name'] as List)
                    .isNotEmpty) //checks that the list is not empty
            ? (json['author_name'][0]?.toString() ??
                  'Unknown author') //take first author element, if null return unknown author
            : 'Unknown author',
        year:
            parseInt(json['first_publish_year']) ??
            0, //parse first_publish_year safely, default 0
        genre: '', //openlibrary does not have genre and tropes fields
        tropes: [],
        coverId: parseInt(
          json['cover_i'],
        ), //coverId parsed from open library's cover_i
        workKey: json['key'] ?? '',
        description: json['description'] is String
            ? json['description']
            : (json['description'] is Map
                  ? (json['description']['value'] as String?)
                  : null),
      );
    }

    return Books(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? 'Unknown author',
      year: parseInt(json['year']) ?? 0,
      genre: json['genre'] ?? '',
      tropes:
          (json['tropes'] as List?)?.map((e) => e.toString()).toList() ?? [],
      coverId: parseInt(json['coverId']),
      workKey: json['workKey'] ?? '',
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'year': year,
      'genre': genre,
      'tropes': tropes,
      'coverId': coverId,
      'workKey': workKey,
      'description': description,
    };
  }
}
