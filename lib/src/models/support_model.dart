
class SupportModel {
    String? url;
    String? text;

    SupportModel({
        this.url,
        this.text,
    });

    factory SupportModel.fromJson(Map<String, dynamic> json) => SupportModel(
        url: json['url'],
        text: json['text'],
    );

    Map<String, dynamic> toJson() => {
        'url': url,
        'text': text,
    };
}