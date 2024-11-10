class Todo{
  final int? id;
  final String title;
  final String description;
  final bool isDone;

  Todo({this.id, required this.title, required this.description, required this.isDone});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone ? 1:0
    };
  }

  static Todo fromMap(Map<String, dynamic> map){
    return Todo(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        isDone: map['isDone'] == 1);
  }

}
