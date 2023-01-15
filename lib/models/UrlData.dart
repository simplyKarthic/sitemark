class UrlData{

  final int count;
  final String image;
  final String link;
  final String name;

  UrlData({
      this.count,
     this.image,
     this.link,
     this.name,
  });

  factory UrlData.fromJson(Map<String, dynamic> data) =>
      UrlData(
          count: data['count'] ?? 0,
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


  factory UrlData.initial(){
    return UrlData(
      count: 0,
      image: '',
      link: 'sitemark.com',
      name: 'sitemark'
    );
  }
}