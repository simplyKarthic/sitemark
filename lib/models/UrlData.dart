
class AccountUrlData{

  AccountUrlData({required this.urlId});

  List<UrlData> urlId = [];

  factory AccountUrlData.fromJson(Map<String, dynamic> json) =>
      AccountUrlData(
        urlId: List<UrlData>.from(json["urlId"].map((x) => UrlData.fromJson(x))),
      );

}





class UrlData{

  int count;
  String image;
  String link;
  String name;

  UrlData({
     required this.count,
    required this.image,
    required this.link,
    required this.name,
  });

  factory UrlData.fromJson(Map<String, dynamic>? data) =>
      UrlData(
          count: data!['count'] ?? 0,
          image: data['image'] ?? '',
          link: data['link'] ?? '',
          name: data['name'] ?? ''
      );

  Map<String, dynamic> toJson()=>{
    'count': count,
    'image': image,
    'link': link,
    'name': name
  };


}