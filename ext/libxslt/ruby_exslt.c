/* http://xmlsoft.org/XSLT/html/libxslt-extensions.html */

#include "libxslt.h"

/* Helper method to retrieve (and possibly initialize)
   the module function registry hash for +namespace+ */
static VALUE
ruby_xslt_module_function_hash(VALUE namespace) {
  VALUE ns_hash, func_hash;

  if ((ns_hash = rb_ivar_get(cXSLT, rb_intern("@module_function_registry"))) == Qnil) {
    ns_hash = rb_ivar_set(cXSLT, rb_intern("@module_function_registry"), rb_hash_new());
  }

  if ((func_hash = rb_hash_aref(ns_hash, namespace)) == Qnil) {
    func_hash = rb_hash_aset(ns_hash, namespace, rb_hash_new());
  }

  return func_hash;
}

/* Helper method for xsltRegisterExtModuleFunction callback */
static void
ruby_xslt_module_function_callback(xmlXPathParserContextPtr ctxt, int nargs) {
  VALUE callback, args[nargs];
  const xmlChar *namespace, *name;
  int i;

  if (ctxt == NULL || ctxt->context == NULL) {
    return;
  }

  namespace = ctxt->context->functionURI;
  name = ctxt->context->function;

  callback = rb_hash_aref(
    ruby_xslt_module_function_hash(rb_str_new2((char *)namespace)),
    rb_str_new2((char *)name)
  );

  if (callback == Qnil) {
    rb_raise(rb_eArgError, "name `%s' not registered", name);
  }

  for (i = nargs - 1; i >= 0; i--) {
    args[i] = rxml_xpath_to_value(ctxt->context, valuePop(ctxt));
  }

  valuePush(ctxt, rxml_xpath_from_value(
    rb_funcall2(callback, rb_intern("call"), nargs, args)
  ));
}

/* call-seq:
 *   XSLT.register_module_function(namespace, name) { ... } -> Proc or nil
 *
 * Registers +name+ as extension module function in +namespace+ with the
 * block as callback. Returns the callback if successful, or +nil+ otherwise.
 *
 * The callback will be called with whatever XPath expression you pass
 * into the function converted to a Ruby object. Its return value will
 * be converted to an XPath expression again.
 *
 * Example:
 *
 *  # register your extension function
 *  XSLT.register_module_function('http://ex.ns', 'ex-func') { |xp|
 *    xp.to_a.join('|').upcase
 *  }
 *
 *  # then use it in your stylesheet
 *  <xsl:stylesheet ... xmlns:ex="http://ex.ns">
 *    ...
 *    <xsl:value-of select="ex:ex-func(.)" />
 *    <!-- the current node as upper case string -->
 *  </xsl:stylesheet>
 */
static VALUE
ruby_xslt_register_module_function(VALUE class, VALUE namespace, VALUE name) {
  VALUE callback;

  if (!rb_block_given_p()) {
    rb_raise(rb_eArgError, "no block given");
  }

  if (xsltRegisterExtModuleFunction(
    BAD_CAST StringValuePtr(name),
    BAD_CAST StringValuePtr(namespace),
    ruby_xslt_module_function_callback
  ) != 0) {
    return Qnil;
  }

  callback = rb_block_proc();

  rb_hash_aset(ruby_xslt_module_function_hash(namespace), name, callback);
  return callback;
}

/* call-seq:
 *   XSLT.unregister_module_function(namespace, name) -> Proc or nil
 *
 * Unregisters +name+ as extension module function in +namespace+.
 * Returns the previous callback if successful, or +nil+ otherwise.
 */
static VALUE
ruby_xslt_unregister_module_function(VALUE class, VALUE namespace, VALUE name) {
  VALUE func_hash, callback;

  func_hash = ruby_xslt_module_function_hash(namespace);

  if ((callback = rb_hash_aref(func_hash, name)) == Qnil) {
    return Qnil;
  }

  if (xsltUnregisterExtModuleFunction(
    BAD_CAST StringValuePtr(name),
    BAD_CAST StringValuePtr(namespace)
  ) != 0) {
    return Qnil;
  }

  rb_hash_aset(func_hash, name, Qnil);
  return callback;
}

/* call-seq:
 *   XSLT.registered_module_function?(namespace, name) -> true or false
 *
 * Returns +true+ if +name+ is currently registered as extension module
 * function in +namespace+, or +false+ otherwise.
 */
static VALUE
ruby_xslt_registered_module_function_p(VALUE class, VALUE namespace, VALUE name) {
  return RTEST(rb_hash_aref(ruby_xslt_module_function_hash(namespace), name));
}

void
ruby_init_exslt() {
  /* [HACK] Enclosing classes/modules for RDoc:
   *   cLibXSLT = rb_define_module("LibXSLT");
   *   cXSLT = rb_define_module_under(cLibXSLT, "XSLT");
   */

  rb_define_singleton_method(cXSLT, "register_module_function", ruby_xslt_register_module_function, 2);
  rb_define_singleton_method(cXSLT, "unregister_module_function", ruby_xslt_unregister_module_function, 2);
  rb_define_singleton_method(cXSLT, "registered_module_function?", ruby_xslt_registered_module_function_p, 2);
}
