/* $Id: ruby_xslt_stylesheet.c 42 2007-12-07 06:09:35Z transami $ */

/* See the LICENSE file for copyright and distribution information. */

#include "libxslt.h"
#include "ruby_xslt_stylesheet.h"

/*
 * Document-class: XML::XSLT::Stylesheet
 * 
 * The XML::XSLT::Stylesheet represents a XSL stylesheet that
 * can be used to transform an XML document.  For usage information
 * refer to XML::XSLT::Stylesheet#apply
 *
*/


VALUE cXSLTStylesheet;

VALUE
ruby_xslt_stylesheet_document_klass() {
  VALUE mXML = rb_const_get(rb_cObject, rb_intern("XML"));
  return rb_const_get(mXML, rb_intern("Document"));
}


void
ruby_xslt_stylesheet_free(xsltStylesheetPtr xstylesheet) {
  xsltFreeStylesheet(xstylesheet);
}

VALUE
ruby_xslt_stylesheet_alloc(VALUE klass) {
  return Data_Wrap_Struct(cXSLTStylesheet,
                          NULL, ruby_xslt_stylesheet_free,
                          NULL);
}
                          

/* call-seq:
 *    XSLT::Stylesheet.new(document) -> XSLT::Stylesheet
 * 
 * Creates a new XSLT stylesheet based on the provided document.
 *
 *  stylesheet_doc = XML::Document.file('stylesheet_file')
 *  stylesheet = XSLT::Stylesheet.new(stylesheet_doc)
 *
 */
VALUE
ruby_xslt_stylesheet_initialize(VALUE self, VALUE document) {
  ruby_xml_document_t *rdocument;

  if (!rb_obj_is_kind_of(document, ruby_xslt_stylesheet_document_klass()))
    rb_raise(rb_eTypeError, "Must pass in an XML::Document instance.");
    
  Data_Get_Struct(document, ruby_xml_document_t, rdocument);
  DATA_PTR(self) = xsltParseStylesheetDoc(rdocument->doc);
  return self;
}

/* Helper method to convert Ruby params to C params */
char **
ruby_xslt_coerce_params(VALUE params) {
  char** result;
  size_t length;
  size_t i;

  length = RARRAY(params)->len;
  result = ALLOC_N(char *, length + 2);

  for (i=0; i<length; i++) {
    VALUE str = rb_String(RARRAY(params)->ptr[i]);
    result[i] = ALLOC_N(char, strLen + 1);
    memset(result[i], 0, strLen + 1);
    strncpy(result[i], RSTRING(str)->ptr, strLen);
  }
  
  /* Null terminate the array */
  result[i] = NULL;
  result[i+1] = NULL;
  
  return result;
}  
   

/* call-seq: 
 *   stylesheet.apply(document) -> XML::Document
 * 
 * Apply this stylesheet transformation to the provided document.
 *
 *  stylesheet_doc = XML::Document.file('stylesheet_file')
 *  stylesheet = XSLT::Stylesheet.new(stylesheet_doc)
 *
 *  xml_doc = XML::Document.file('xml_file')
 *  result = stylesheet.apply(xml_doc)
 */
VALUE
ruby_xslt_stylesheet_apply(int argc, VALUE *argv, VALUE self) {
  ruby_xml_document_t *rdocument;
  xsltStylesheetPtr xstylesheet;
  xmlDocPtr result;
  VALUE document;
  VALUE params;
  int i;
  
  char** pParams;

  if (argc > 2 || argc < 1)
    rb_raise(rb_eArgError, "wrong number of arguments (need 1 or 2)");
    
  document = argv[0];
  
  if (!rb_obj_is_kind_of(document, ruby_xslt_stylesheet_document_klass()))
    rb_raise(rb_eTypeError, "Must pass in an XML::Document instance.");

  /* Make sure params is a flat array */
  params = (argc == 2 ? argv[1]: Qnil);
  params = rb_Array(params);
  rb_funcall(params, rb_intern("flatten!"), 0);
  pParams = ruby_xslt_coerce_params(params);
  
  Data_Get_Struct(document, ruby_xml_document_t, rdocument);
  Data_Get_Struct(self, xsltStylesheet, xstylesheet);
  
  result = xsltApplyStylesheet(xstylesheet, rdocument->doc, pParams);
  
  for (i=0; i<(RARRAY(params)->len+2); i++) {
    ruby_xfree(pParams[i]);
  }
  ruby_xfree(pParams);
    
  return ruby_xml_document_wrap(result);
}


/* call-seq: 
 *   sheet.debug(to = $stdout) => (true|false)
 * 
 * Output a debug dump of this stylesheet to the specified output
 * stream (an instance of IO, defaults to $stdout). Requires
 * libxml/libxslt be compiled with debugging enabled. If this
 * is not the case, a warning is triggered and the method returns
 * false.
 */
/*VALUE
ruby_xslt_stylesheet_debug(int argc, VALUE *argv, VALUE self) {
#ifdef LIBXML_DEBUG_ENABLED
  OpenFile *fptr;
  VALUE io;
  FILE *out;
  ruby_xml_document_t *parsed;
  ruby_xslt_stylesheet *xss;

  Data_Get_Struct(self, ruby_xslt_stylesheet, xss);
  if (NIL_P(xss->parsed))
    rb_raise(eXMLXSLTStylesheetRequireParsedDoc, "must have a parsed XML result");

  switch (argc) {
  case 0:
    io = rb_stdout;
    break;
  case 1:
    io = argv[0];
    if (rb_obj_is_kind_of(io, rb_cIO) == Qfalse)
      rb_raise(rb_eTypeError, "need an IO object");
    break;
  default:
    rb_raise(rb_eArgError, "wrong number of arguments (0 or 1)");
  }

  Data_Get_Struct(xss->parsed, ruby_xml_document_t, parsed);
  if (parsed->doc == NULL)
    return(Qnil);

  GetOpenFile(io, fptr);
  rb_io_check_writable(fptr);
  out = GetWriteFile(fptr);
  xmlDebugDumpDocument(out, parsed->doc);
  return(Qtrue);
#else
  rb_warn("libxml/libxslt was compiled without debugging support.  Please recompile libxml/libxslt and their Ruby modules");
  return(Qfalse);
#endif
}
*/

// TODO should this automatically apply the sheet if not already,
//      given that we're unlikely to do much else with it?

/* call-seq: 
 *   sheet.print(to = $stdout) => number_of_bytes
 * 
 * Output the result of the transform to the specified output
 * stream (an IO instance, defaults to $stdout). You *must* call
 * +apply+ before this method or an exception will be raised.
 */
/*VALUE
ruby_xslt_stylesheet_print(int argc, VALUE *argv, VALUE self) {
  OpenFile *fptr;
  VALUE io;
  FILE *out;
  ruby_xml_document_t *parsed;
  ruby_xslt_stylesheet *xss;
  int bytes;

  Data_Get_Struct(self, ruby_xslt_stylesheet, xss);
  if (NIL_P(xss->parsed))
    rb_raise(eXMLXSLTStylesheetRequireParsedDoc, "must have a parsed XML result");

  switch (argc) {
  case 0:
    io = rb_stdout;
    break;
  case 1:
    io = argv[0];
    if (rb_obj_is_kind_of(io, rb_cIO) == Qfalse)
      rb_raise(rb_eTypeError, "need an IO object");
    break;
  default:
    rb_raise(rb_eArgError, "wrong number of arguments (0 or 1)");
  }

  Data_Get_Struct(xss->parsed, ruby_xml_document_t, parsed);
  if (parsed->doc == NULL)
    return(Qnil);

  GetOpenFile(io, fptr);
  rb_io_check_writable(fptr);
  out = GetWriteFile(fptr);
  bytes = xsltSaveResultToFile(out, parsed->doc, xss->xsp);

  return(INT2NUM(bytes));
}*/


#ifdef RDOC_NEVER_DEFINED
  mXML = rb_define_module("XML");
  cXSLT = rb_define_class_under(mXML, "XSLT", rb_cObject);
  cXScXSLTStylesheet = rb_define_class_under(cXSLT, "Stylesheet", rb_cObject);
#endif

void
ruby_init_xslt_stylesheet(void) {
  cXSLTStylesheet = rb_define_class_under(cXSLT, "Stylesheet", rb_cObject);
  rb_define_alloc_func(cXSLTStylesheet, ruby_xslt_stylesheet_alloc);
  rb_define_method(cXSLTStylesheet, "initialize", ruby_xslt_stylesheet_initialize, 1);
  rb_define_method(cXSLTStylesheet, "apply", ruby_xslt_stylesheet_apply, -1);
}
