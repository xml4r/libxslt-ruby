/* $Id: libxslt.c 42 2007-12-07 06:09:35Z transami $ */

/* Please see the LICENSE file for copyright and distribution information */

#include "libxslt.h"
#include "libxml/xmlversion.h"

VALUE cLibXSLT;
VALUE eXSLTError;

/*
 * Document-class: XSLT
 * 
 * The libxslt gem provides Ruby language bindings for GNOME's Libxslt
 * toolkit. It is free software, released under the MIT License.
 *
 * Using the bindings is straightforward:
 *
 *  stylesheet_doc = LibXML::Document.file('stylesheet_file')
 *  stylesheet = LibXSLT::Stylesheet.new(stylesheet_doc)
 *
 *  xml_doc = LibXML::Document.file('xml_file')
 *  result = stylesheet.apply(xml_doc)
 * 
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

  rb_define_const(cLibXSLT, "MAX_DEPTH", INT2NUM(xsltMaxDepth));
  rb_define_const(cLibXSLT, "MAX_SORT", INT2NUM(XSLT_MAX_SORT));
  rb_define_const(cLibXSLT, "ENGINE_VERSION", rb_str_new2(xsltEngineVersion));
  rb_define_const(cLibXSLT, "LIBXSLT_VERSION", INT2NUM(xsltLibxsltVersion));
  rb_define_const(cLibXSLT, "LIBXML_VERSION", INT2NUM(xsltLibxmlVersion));
  rb_define_const(cLibXSLT, "XSLT_NAMESPACE", rb_str_new2((const char*)XSLT_NAMESPACE));
  rb_define_const(cLibXSLT, "DEFAULT_VENDOR", rb_str_new2(XSLT_DEFAULT_VENDOR));
  rb_define_const(cLibXSLT, "DEFAULT_VERSION", rb_str_new2(XSLT_DEFAULT_VERSION));
  rb_define_const(cLibXSLT, "DEFAULT_URL", rb_str_new2(XSLT_DEFAULT_URL));
  rb_define_const(cLibXSLT, "NAMESPACE_LIBXSLT", rb_str_new2((const char*)XSLT_LIBXSLT_NAMESPACE));
  rb_define_const(cLibXSLT, "NAMESPACE_NORM_SAXON", rb_str_new2((const char*)XSLT_NORM_SAXON_NAMESPACE));
  rb_define_const(cLibXSLT, "NAMESPACE_SAXON", rb_str_new2((const char*)XSLT_SAXON_NAMESPACE));
  rb_define_const(cLibXSLT, "NAMESPACE_XT", rb_str_new2((const char*)XSLT_XT_NAMESPACE));
  rb_define_const(cLibXSLT, "NAMESPACE_XALAN", rb_str_new2((const char*)XSLT_XALAN_NAMESPACE));

  eXSLTError = rb_define_class_under(cLibXSLT, "XSLTError", rb_eRuntimeError);

  ruby_init_xslt_stylesheet();
  ruby_init_xslt_transform_context();
}
