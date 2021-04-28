import 'package:build/build.dart';
import 'package:markdown/markdown.dart';
import 'package:tavern/src/extensions.dart';

Builder markdownBuilder(_) => MarkdownBuilder();

class MarkdownBuilder implements Builder {
  Future build(BuildStep buildStep) async {
    var inputId = buildStep.inputId;

    var outputId = inputId.changeExtension(Extensions.htmlContent);
    var markdownContent = await buildStep.readAsString(inputId);
    var htmlContent =
        markdownToHtml(markdownContent, extensionSet: ExtensionSet.gitHubWeb);

    await buildStep.writeAsString(outputId, htmlContent);
  }

  Map<String, List<String>> get buildExtensions => {
        Extensions.withPartials: [Extensions.htmlContent]
      };
}
