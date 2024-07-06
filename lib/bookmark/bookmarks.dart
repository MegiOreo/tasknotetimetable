

class Bookmark {
  late String linkName;
  late String link;

  Bookmark({required this.linkName, required this.link});

  // factory Bookmark.fromJson(Map<String, dynamic> json) {
  //   return Bookmark(json['linkName'] ?? '', json['link'] ?? '');
  // }

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        linkName: json["linkName"],
        link: json["links"]
      );

  Map<String, dynamic> toJson() {
    return {
      'linkName': linkName,
      'link': link,
    };
  }
}
