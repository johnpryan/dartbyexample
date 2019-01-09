//library dartbyexample_transformer;
//
//import 'dart:async';
//import 'package:barback/barback.dart';
//
//class BracketTransformer extends Transformer {
//  BracketTransformer.asPlugin();
//
//  apply(Transform transform) {
//    final asset = transform.primaryInput;
//
//    return asset.readAsString().then((content) {
//      transform.consumePrimary();
//      var replacedContent = content.replaceAll('<', '&lt;');
//      replacedContent = replacedContent.replaceAll('>', '&gt;');
//      transform.addOutput(new Asset.fromString(asset.id, replacedContent));
//      return replacedContent;
//    });
//  }
//
//  Future<bool> isPrimary(AssetId id) {
//    return new Future.value(id.path.endsWith('.dart'));
//  }
//}
