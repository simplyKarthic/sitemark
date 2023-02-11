class UrlData{

  final String title;
  final String description;
  final Uri imageUrl;
  final int viewCount;
  final String posterTime;
  final String profileName;

  UrlData({
      this.title,
     this.description,
     this.imageUrl,
     this.viewCount,
    this.posterTime,
    this.profileName
  });

  factory UrlData.fromJson(Map<String, dynamic> data) =>
      UrlData(
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          viewCount: data['viewCount'] ?? 0,
          posterTime: data['posterTime'] ?? '',
          profileName: data['profileName'] ?? ''
      );

  Map<String, dynamic> toJson()=>{
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
    'viewCount': viewCount,
    'posterTime': posterTime,
    'profileName': profileName
  };


  factory UrlData.initial(){
    return UrlData(
        title: '',
        description: '',
        imageUrl: Uri.parse(''),
        viewCount: 0,
        posterTime: '',
        profileName: ''
    );
  }
}