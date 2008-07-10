/* $Id: ruby_xslt_stylesheet.h 42 2007-12-07 06:09:35Z transami $ */

/* Please see the LICENSE file for copyright and distribution information. */

#ifndef __RUBY_LIBXSLT_STYLESHEET__
#define __RUBY_LIBXSLT_STYLESHEET__

// Includes from libxml-ruby
#include <libxml/ruby_libxml.h>
#include <libxml/ruby_xml_document.h>

extern VALUE cXSLTStylesheet;

void ruby_init_xslt_stylesheet(void);

#endif
