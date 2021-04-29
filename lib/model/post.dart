
class Post
{
    int? id;
    

    Post(Map<String, dynamic> json){
       this.id = json['id'];
    }
}