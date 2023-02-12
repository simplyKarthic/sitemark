class UrlData{

  final String title;
  final String description;
  final String imageUrl;

  UrlData({
      this.title,
     this.description,
     this.imageUrl,
  });

  factory UrlData.fromJson(Map<String, dynamic> data) =>
      UrlData(
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
      );

  Map<String, dynamic> toJson()=>{
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
  };


  factory UrlData.initial(){
    return UrlData(
        title: '',
        description: '',
        imageUrl: '',
    );
  }
}