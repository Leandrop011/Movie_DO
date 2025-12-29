class PushMessages {
  final String messageId;
  final String tittle;
  final String body;
  final DateTime sentData;
  final Map<String, dynamic>? data;
  final String? imageUrl;

  PushMessages({
    required this.messageId, 
    required this.tittle, 
    required this.body, 
    required this.sentData, 
    this.data, 
    this.imageUrl
  });

  @override
  String toString(){
    return '''
    messageId: $messageId
    title: $tittle
    body: $body
    sentDate: $sentData
    data: $data
    image: $imageUrl
          ''';
  }
}