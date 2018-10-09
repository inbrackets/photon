import 'dart:html';

class TrustedNodeValidator implements NodeValidator {
  NodeValidatorBuilder _validator;
  TrustedNodeValidator () {
    _validator = NodeValidatorBuilder.common();
    _validator..allowCustomElement("null");
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
    if (attributeName.startsWith(RegExp(r"pro-"))) {
      return true;
    } else if (attributeName.startsWith(RegExp(r"on"))) {
      return true;
    }
    return _validator.allowsAttribute(element, attributeName, value);
  }
}