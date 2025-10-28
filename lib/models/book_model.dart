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
        workKey:
            json['key'] ??
            '', //assigns workKey the value from JSONs key if not null. otherwise ''
        description:
            json['description']
                is String //if description is a string, use directly
            ? json['description']
            : (json['description']
                      is Map //if description is a map try to acces and cast to String?
                  ? (json['description']['value'] as String?)
                  : null), //if neither string nor map return null
      );
    }

    return Books(
      //take map of data (JSON from firebase or openlibrary), extract fields, create and return new Books object
      id: json['id'] ?? '', //acces id key from JSON map, if null return empty
      title: json['title'] ?? '',
      author: json['author'] ?? 'Unknown author',
      year:
          parseInt(json['year']) ??
          0, //tries to convert into int (using parseInt), else 0
      genre: json['genre'] ?? '',
      tropes:
          (json['tropes'] as List?)?.map((e) => e.toString()).toList() ??
          [], //get tropes as list, if not null, convert every element to String, turn back into list. If null make empty list instead.
      coverId: parseInt(json['coverId']),
      workKey: json['workKey'] ?? '',
      description: json['description']
          ?.toString(), //if description exists, convert it to string. Otherwise null
    );
  }

  Map<String, dynamic> toJson() {
    //Save data to database, convert back to JSON
    return {
      //creates Map literal, each key corresponds to model properties
      'id': id, //id is the same as this.id
      'title': title,
      'author': author,
      'year': year,
      'genre': genre,
      'tropes': tropes,
      'coverId': coverId,
      'workKey': workKey,
      'description': description,
    }; //map created from this gets returned to book_provider and user_provider that calls on this method
  }
}
