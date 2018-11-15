import 'dart:html';

class TrustedNodeValidator implements NodeValidator {
  NodeValidatorBuilder _validator;
  TrustedNodeValidator () {
    _validator = NodeValidatorBuilder.common();
    allowCustomElement("NULL");
    allowCustomElement("LIST");
  }

  allowCustomElement(String tagName,
      {UriPolicy uriPolicy,
        Iterable<String> attributes,
        Iterable<String> uriAttributes}) {

    _validator..allowCustomElement(tagName,
    attributes: attributes, uriPolicy: uriPolicy, uriAttributes: uriAttributes);
  }

  bool allowsElement(Element element) {
    return _validator.allowsElement(element);
  }

  bool allowsAttribute(element, attributeName, value) {
    if (attributeName.startsWith(RegExp(r"p-"))) {
      return true;
    } else if (attributeName.startsWith(RegExp(r"on"))) {
      return true;
    } else if (attributeName == "style") {
      return true;
    } else if (attributeName == "contenteditable") {
      return true;
    } else if (element is TextAreaElement && attributeName == "value") {
      return true;
    }
    return _validator.allowsAttribute(element, attributeName, value);
  }
}

class TrustedNodeValidatorAll implements NodeValidator {
  bool allowsElement(Element element) => true;
  bool allowsAttribute(element, attributeName, value) => true;
}