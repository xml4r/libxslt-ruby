/* $Id: libxslt.c 42 2007-12-07 06:09:35Z transami $ */

/* Please see the LICENSE file for copyright and distribution information */

#include "libxslt.h"
#include "libxml/xmlversion.h"

VALUE cLibXSLT;
VALUE cXSLT;
VALUE eXSLTError;

/*
 * Document-class: LibXSLT::XSLT
 *
 * The libxslt gem provides Ruby language bindings for GNOME's Libxslt
 * toolkit. It is free software, released under the MIT License.
 *
 * Using the bindings is straightforward:
 *
 *  stylesheet_doc = XML::Document.file('stylesheet_file')
 *  stylesheet = XSLT::Stylesheet.new(stylesheet_doc)
 *
 *  xml_doc = XML::Document.file('xml_file')
 *  result = stylesheet.apply(xml_doc)
 *
 */

#ifdef RDOC_NEVER_DEFINED
  cLibXSLT = rb_define_module("XSLT");
#endif


#if defined(_WIN32)
__declspec(dllexport)
#endif

void
Init_libxslt_ruby(void) {
  LIBXML_TEST_VERSION;

  cLibXSLT = rb_define_module("LibXSLT");
  cXSLT = rb_define_module_under(cLibXSLT, "XSLT");

  rb_define_const(cXSLT, "MAX_DEPTH", INT2NUM(xsltMaxDepth));
  rb_define_const(cXSLT, "MAX_SORT", INT2NUM(XSLT_MAX_SORT));
  rb_define_const(cXSLT, "ENGINE_VERSION", rb_str_new2(xsltEngineVersion));
  rb_define_const(cXSLT, "LIBXSLT_VERSION", INT2NUM(xsltLibxsltVersion));
  rb_define_const(cXSLT, "LIBXML_VERSION", INT2NUM(xsltLibxmlVersion));
  rb_define_const(cXSLT, "XSLT_NAMESPACE", rb_str_new2((const char*)XSLT_NAMESPACE));
  rb_define_const(cXSLT, "DEFAULT_VENDOR", rb_str_new2(XSLT_DEFAULT_VENDOR));
  rb_define_const(cXSLT, "DEFAULT_VERSION", rb_str_new2(XSLT_DEFAULT_VERSION));
  rb_define_const(cXSLT, "DEFAULT_URL", rb_str_new2(XSLT_DEFAULT_URL));
  rb_define_const(cXSLT, "NAMESPACE_LIBXSLT", rb_str_new2((const char*)XSLT_LIBXSLT_NAMESPACE));
  rb_define_const(cXSLT, "NAMESPACE_NORM_SAXON", rb_str_new2((const char*)XSLT_NORM_SAXON_NAMESPACE));
  rb_define_const(cXSLT, "NAMESPACE_SAXON", rb_str_new2((const char*)XSLT_SAXON_NAMESPACE));
  rb_define_const(cXSLT, "NAMESPACE_XT", rb_str_new2((const char*)XSLT_XT_NAMESPACE));
  rb_define_const(cXSLT, "NAMESPACE_XALAN", rb_str_new2((const char*)XSLT_XALAN_NAMESPACE));

  eXSLTError = rb_define_class_under(cLibXSLT, "XSLTError", rb_eRuntimeError);

  ruby_init_xslt_stylesheet();

  /* Now load exslt. */
  exsltRegisterAll();
}
