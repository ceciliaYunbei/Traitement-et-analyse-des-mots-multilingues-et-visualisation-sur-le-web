/*
 * This file was generated automatically by ExtUtils::ParseXS version 3.18 from the
 * contents of String.xs. Do not edit this file, edit String.xs instead.
 *
 *    ANY CHANGES MADE HERE WILL BE LOST!
 *
 */

#line 1 "String.xs"
/* $Id: String.xs,v 1.11 2003/03/11 03:16:24 gisle Exp $
 *
 * Copyright 1997-1999, Gisle Aas.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the same terms as Perl itself.
 */

#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif

#include "patchlevel.h"
#if PATCHLEVEL <= 4 && !defined(PL_dowarn)
   #define PL_dowarn dowarn
#endif

#ifdef G_WARN_ON
   #define DOWARN (PL_dowarn & G_WARN_ON)
#else
   #define DOWARN PL_dowarn
#endif


#line 41 "String.c"
#ifndef PERL_UNUSED_VAR
#  define PERL_UNUSED_VAR(var) if (0) var = var
#endif

#ifndef dVAR
#  define dVAR		dNOOP
#endif


/* This stuff is not part of the API! You have been warned. */
#ifndef PERL_VERSION_DECIMAL
#  define PERL_VERSION_DECIMAL(r,v,s) (r*1000000 + v*1000 + s)
#endif
#ifndef PERL_DECIMAL_VERSION
#  define PERL_DECIMAL_VERSION \
	  PERL_VERSION_DECIMAL(PERL_REVISION,PERL_VERSION,PERL_SUBVERSION)
#endif
#ifndef PERL_VERSION_GE
#  define PERL_VERSION_GE(r,v,s) \
	  (PERL_DECIMAL_VERSION >= PERL_VERSION_DECIMAL(r,v,s))
#endif
#ifndef PERL_VERSION_LE
#  define PERL_VERSION_LE(r,v,s) \
	  (PERL_DECIMAL_VERSION <= PERL_VERSION_DECIMAL(r,v,s))
#endif

/* XS_INTERNAL is the explicit static-linkage variant of the default
 * XS macro.
 *
 * XS_EXTERNAL is the same as XS_INTERNAL except it does not include
 * "STATIC", ie. it exports XSUB symbols. You probably don't want that
 * for anything but the BOOT XSUB.
 *
 * See XSUB.h in core!
 */


/* TODO: This might be compatible further back than 5.10.0. */
#if PERL_VERSION_GE(5, 10, 0) && PERL_VERSION_LE(5, 15, 1)
#  undef XS_EXTERNAL
#  undef XS_INTERNAL
#  if defined(__CYGWIN__) && defined(USE_DYNAMIC_LOADING)
#    define XS_EXTERNAL(name) __declspec(dllexport) XSPROTO(name)
#    define XS_INTERNAL(name) STATIC XSPROTO(name)
#  endif
#  if defined(__SYMBIAN32__)
#    define XS_EXTERNAL(name) EXPORT_C XSPROTO(name)
#    define XS_INTERNAL(name) EXPORT_C STATIC XSPROTO(name)
#  endif
#  ifndef XS_EXTERNAL
#    if defined(HASATTRIBUTE_UNUSED) && !defined(__cplusplus)
#      define XS_EXTERNAL(name) void name(pTHX_ CV* cv __attribute__unused__)
#      define XS_INTERNAL(name) STATIC void name(pTHX_ CV* cv __attribute__unused__)
#    else
#      ifdef __cplusplus
#        define XS_EXTERNAL(name) extern "C" XSPROTO(name)
#        define XS_INTERNAL(name) static XSPROTO(name)
#      else
#        define XS_EXTERNAL(name) XSPROTO(name)
#        define XS_INTERNAL(name) STATIC XSPROTO(name)
#      endif
#    endif
#  endif
#endif

/* perl >= 5.10.0 && perl <= 5.15.1 */


/* The XS_EXTERNAL macro is used for functions that must not be static
 * like the boot XSUB of a module. If perl didn't have an XS_EXTERNAL
 * macro defined, the best we can do is assume XS is the same.
 * Dito for XS_INTERNAL.
 */
#ifndef XS_EXTERNAL
#  define XS_EXTERNAL(name) XS(name)
#endif
#ifndef XS_INTERNAL
#  define XS_INTERNAL(name) XS(name)
#endif

/* Now, finally, after all this mess, we want an ExtUtils::ParseXS
 * internal macro that we're free to redefine for varying linkage due
 * to the EXPORT_XSUB_SYMBOLS XS keyword. This is internal, use
 * XS_EXTERNAL(name) or XS_INTERNAL(name) in your code if you need to!
 */

#undef XS_EUPXS
#if defined(PERL_EUPXS_ALWAYS_EXPORT)
#  define XS_EUPXS(name) XS_EXTERNAL(name)
#else
   /* default to internal */
#  define XS_EUPXS(name) XS_INTERNAL(name)
#endif

#ifndef PERL_ARGS_ASSERT_CROAK_XS_USAGE
#define PERL_ARGS_ASSERT_CROAK_XS_USAGE assert(cv); assert(params)

/* prototype to pass -Wmissing-prototypes */
STATIC void
S_croak_xs_usage(pTHX_ const CV *const cv, const char *const params);

STATIC void
S_croak_xs_usage(pTHX_ const CV *const cv, const char *const params)
{
    const GV *const gv = CvGV(cv);

    PERL_ARGS_ASSERT_CROAK_XS_USAGE;

    if (gv) {
        const char *const gvname = GvNAME(gv);
        const HV *const stash = GvSTASH(gv);
        const char *const hvname = stash ? HvNAME(stash) : NULL;

        if (hvname)
            Perl_croak(aTHX_ "Usage: %s::%s(%s)", hvname, gvname, params);
        else
            Perl_croak(aTHX_ "Usage: %s(%s)", gvname, params);
    } else {
        /* Pants. I don't think that it should be possible to get here. */
        Perl_croak(aTHX_ "Usage: CODE(0x%"UVxf")(%s)", PTR2UV(cv), params);
    }
}
#undef  PERL_ARGS_ASSERT_CROAK_XS_USAGE

#ifdef PERL_IMPLICIT_CONTEXT
#define croak_xs_usage(a,b)    S_croak_xs_usage(aTHX_ a,b)
#else
#define croak_xs_usage        S_croak_xs_usage
#endif

#endif

/* NOTE: the prototype of newXSproto() is different in versions of perls,
 * so we define a portable version of newXSproto()
 */
#ifdef newXS_flags
#define newXSproto_portable(name, c_impl, file, proto) newXS_flags(name, c_impl, file, proto, 0)
#else
#define newXSproto_portable(name, c_impl, file, proto) (PL_Sv=(SV*)newXS(name, c_impl, file), sv_setpv(PL_Sv, proto), (CV*)PL_Sv)
#endif /* !defined(newXS_flags) */

#line 183 "String.c"

XS_EUPXS(XS_Unicode__String_latin1); /* prototype to pass -Wmissing-prototypes */
XS_EUPXS(XS_Unicode__String_latin1)
{
    dVAR; dXSARGS;
    if (items < 1)
       croak_xs_usage(cv,  "self, ...");
    {
	SV*	self = ST(0)
;
#line 40 "String.xs"
	SV*    newsv;
	SV*    str;

#line 198 "String.c"
	SV *	RETVAL;
#line 44 "String.xs"
        RETVAL = 0;
	if (!sv_isobject(self)) {
	    newsv = self;
	    RETVAL = self = newSV(0);
	    newSVrv(self, "Unicode::String");
	} else if (items > 1) {
	    newsv = ST(1);
        } else {
	    newsv = 0;
        }

	str = SvRV(self);
	if (GIMME_V != G_VOID && !RETVAL) {
            U8 *beg, *s;
	    STRLEN len;
            U16* usp = (U16*)SvPV(str,len);
	    len /= 2;
	    RETVAL = newSV(len+1);
	    SvPOK_on(RETVAL);
	    beg = s = (U8*)SvPVX(RETVAL);
	    while (len--) {
	        U16 us = ntohs(*usp++);
                if (us > 255) {
		    if (us == 0xFEFF) {
			/* ignore BYTE ORDER MARK */
                    } else {
			if (DOWARN) warn("Data outside latin1 range (pos=%d, ch=U+%x)", s - beg, us);
		    }
		} else {
	            *s++ = us;
                }
	    }
	    SvCUR_set(RETVAL, s - beg);
            *s='\0';
        }

	if (newsv) {
            U16 *usp;
            STRLEN len;
	    STRLEN my_na;
	    U8 *s = (U8*)SvPV(newsv, len);
	    SvGROW(str, len*2 + 2);
	    SvPOK_on(str);
	    SvCUR_set(str,len*2);
	    usp = (U16*)SvPV(str,my_na);
            while (len--) {
	       *usp++ = htons((U16)*s++);
            }
	    *usp = 0;
        }
	if (!RETVAL)
	    RETVAL = newSViv(0);

#line 254 "String.c"
	ST(0) = RETVAL;
	sv_2mortal(ST(0));
    }
    XSRETURN(1);
}


XS_EUPXS(XS_Unicode__String_ucs4); /* prototype to pass -Wmissing-prototypes */
XS_EUPXS(XS_Unicode__String_ucs4)
{
    dVAR; dXSARGS;
    if (items < 1)
       croak_xs_usage(cv,  "self, ...");
    {
	SV*	self = ST(0)
;
#line 105 "String.xs"
	SV*    newsv;
	SV*    str;

#line 275 "String.c"
	SV *	RETVAL;
#line 109 "String.xs"
	RETVAL = 0;
	if (!sv_isobject(self)) {
	    newsv = self;
	    RETVAL = self = newSV(0);
            newSVrv(self, "Unicode::String");
	} else if (items > 1) {
	    newsv = ST(1);
        } else {
	    newsv = 0;
        }

	str = SvRV(self);

	if (GIMME_V != G_VOID && !RETVAL) {
            U32* to, *beg;
	    STRLEN len;   /* source length */
	    U16* from = (U16*)SvPV(str, len);
	    STRLEN my_na;
	    len /= 2;
	    RETVAL = newSV(len*4 + 1);
	    SvPOK_on(RETVAL);
	    beg = to = (U32*)SvPV(RETVAL, my_na);
            while (len--) {
		U16 us = ntohs(*from++);
		if (us >= 0xD800 && us <= 0xDFFF) {  /* surrogate */
                    U16 low = len ? ntohs(*from) : 0;
                    if (us >= 0xDC00 || low < 0xDC00 || low > 0xDFFF) {
			/* bad surrogate pair */
			if (DOWARN) warn("Bad surrogate pair U+%04x U+%04x", us, low);
		    } else {
			len--; from++;
			*to++ = htonl((us-0xD800)*0x400 + low-0xDC00 + 0x10000);
                    }
	        } else {
		    *to++ = htonl(us);
                }
            }
	    SvCUR_set(RETVAL, (to - beg) * 4);
	    SvPVX(RETVAL)[SvCUR(RETVAL)] = '\0';
	}

	if (newsv) {
	    STRLEN len;
	    U32* from = (U32*)SvPV(newsv, len);
	    len /= 4;
	    SvGROW(str, len*2 + 1);  /* enough if we don't need surrogates */
	    SvPOK_on(str);
            SvCUR_set(str, 0);
	    while (len--) {
                U32 uc = ntohl(*from++);  /* XXX should look for swapped FEFF */
		if (uc > 0xFFFF) {
		    if (uc > 0x10FFFF) {
			/* can't be represented */
			if (DOWARN) warn("UCS4 char (0x%08x) can not be encoded as UTF16", uc);
                    } else {
			/* generate two surrogates */
			U16 high, low;
			uc -= 0x10000;
			high = htons(uc/0x400 + 0xD800);
			low  = htons(uc%0x400 + 0xDC00);
			sv_catpvn(str, (char*)&high, 2);
			sv_catpvn(str, (char*)&low,  2);
                    }
		} else {
                    U16 s = htons(uc);
		    sv_catpvn(str, (char*)&s, 2);
		}
	    }
	    /* ensure '\0' termination of string */
	    SvGROW(str, SvCUR(str)+1);
	    SvPVX(str)[SvCUR(str)] = '\0';
	}

	if (!RETVAL)
	    RETVAL = newSViv(0);

#line 354 "String.c"
	ST(0) = RETVAL;
	sv_2mortal(ST(0));
    }
    XSRETURN(1);
}


XS_EUPXS(XS_Unicode__String_utf8); /* prototype to pass -Wmissing-prototypes */
XS_EUPXS(XS_Unicode__String_utf8)
{
    dVAR; dXSARGS;
    if (items < 1)
       croak_xs_usage(cv,  "self, ...");
    {
	SV*	self = ST(0)
;
#line 194 "String.xs"
	SV*    newsv;
	SV*    str;

#line 375 "String.c"
	SV *	RETVAL;
#line 198 "String.xs"
	RETVAL = 0;
	if (!sv_isobject(self)) {
	    newsv = self;
	    RETVAL = self = newSV(0);
            newSVrv(self, "Unicode::String");
	} else if (items > 1) {
	    newsv = ST(1);
        } else {
	    newsv = 0;
        }

	str = SvRV(self);
	if (GIMME_V != G_VOID && !RETVAL) {
	    /* encode str */
	    STRLEN len;
	    U16* from = (U16*)SvPV(str, len);
	    len /= 2;
	    RETVAL = newSV(len*1.2 + 1);  /* guess osuitable for euro-text */
	    SvPOK_on(RETVAL);
	    SvCUR_set(RETVAL, 0);
            while (len--) {
		register U32 us = ntohs(*from++);
	        if (us >= 0xD800 && us <= 0xDFFF) {  /* surrogate */
                    U16 low = len ? ntohs(*from) : 0;
                    if (us >= 0xDC00 || low < 0xDC00 || low > 0xDFFF) {
			/* bad surrogate pair */
			if (DOWARN) warn("Bad surrogate pair U+%04x U+%04x", us, low);
		    } else {
			len--; from++;
			us = (us-0xD800)*0x400 + low-0xDC00 + 0x10000;
                    }
                }
		if (us < 0x80) {
		    U8 c = us;
		    sv_catpvn(RETVAL, (char*)&c, 1);
                } else if (us < 0x800) {
		    U8 c[2];
                    c[1] = (us & 0077) | 0200;
                    c[0] = (us >> 6)   | 0300;
                    sv_catpvn(RETVAL, (char*)c, 2);
                } else if (us < 0x10000) {
		    U8 c[3];
                    c[2] = (us & 0077) | 0200; us >>= 6;
		    c[1] = (us & 0077) | 0200; us >>= 6;
		    c[0] =  us         | 0340;
	            sv_catpvn(RETVAL, (char*)c, 3);
                } else if (us < 0x200000) {
                    U8 c[4];
                    c[3] = (us & 0077) | 0200; us >>= 6;
                    c[2] = (us & 0077) | 0200; us >>= 6;
		    c[1] = (us & 0077) | 0200; us >>= 6;
		    c[0] =  us         | 0360;
	            sv_catpvn(RETVAL, (char*)c, 4);
                } else {
		     /* this can't really happen since we start with utf16 */
	             if (DOWARN) warn("Large char (%08X) ignored", us);
                }
	    }
	    /* ensure '\0' termination of string */
	    SvGROW(str, SvCUR(str)+1);
	    SvPVX(str)[SvCUR(str)] = '\0';
	}

	if (newsv) {
	    /* decode new */
	    STRLEN len;
	    U8* from = (U8*)SvPV(newsv, len);
	    SvGROW(str, len + 1);  /* must be at least this big */
	    SvPOK_on(str);
            SvCUR_set(str, 0);
            while (len--) {
	        U8 s[2];
		U8 u = *from++;
                if (u < 0x80) {
                    s[0] = '\0';
                    s[1] = u;
		    sv_catpvn(str, (char*)s, 2);
                } else if ((u & 0340) == 0300) {
                    /* 2 bytes to decode */
		    if (!len) {
			if (DOWARN) warn("Missing second byte of utf8 encoded char");
                    } else {
			U8 u2 = *from;
			if ((u2 & 0300) != 0200) {
			    if (DOWARN) warn("Bad second byte of utf8 encoded char");
                        } else {
			    from++; len--;  /* consume it */
			    s[0] = (u & 0037) >> 2;
			    s[1] = ((u & 0003) << 6) | (u2 & 0077);
			    sv_catpvn(str, (char*)s, 2);
			}
		    }
                } else if ((u & 0360) == 0340) {
		    /* 3 bytes to decode */
		    if (len < 2) {
			if (DOWARN) warn("Missing 2nd or 3rd byte of utf8 encoded char");
                    } else {
			U8 u2 = from[0];
			U8 u3 = from[1];
			if ((u2 & 0300) != 0200 || (u3 & 0300) != 0200) {
			    if (DOWARN) warn("Bad 2nd or 3rd byte of utf8 encoded char");
                        } else {
			    from += 2; len -= 2; /* consume them */
			    s[0] = (u  << 4) | (u2 & 0077) >> 2;
			    s[1] = (u2 << 6) | (u3 & 0077);
			    sv_catpvn(str, (char*)s, 2);
			}
                    }
                } else if ((u & 0370) == 0360) {
		    /* 4 bytes to decode, encoded using surrogates */
	            if (len < 3) {
			if (DOWARN) warn("Missing 2nd, 3rd or 4th byte of utf8 encoded char");
                    } else {
			if ((from[0] & 0300) != 0200 ||
			    (from[1] & 0300) != 0200 ||
			    (from[2] & 0300) != 0200)
			{
			    if (DOWARN) warn("Bad 2nd, 3rd or 4th byte of utf8 encoded char");
			} else {
			    U32 c = (u & 0007) << 6;
			    c |= (from[0] & 0077); c <<= 6;
			    c |= (from[1] & 0077); c <<= 6;
			    c |= (from[2] & 0077);
			    from += 3; len -= 3;
			    /* c must now be encoded as two surrogates */
			    if (c > 0x10FFFF) {
				if (DOWARN) warn("Can't represent 0x%08X as utf16", c);
                            } else {
				/* generate two surrogates */
				U16 high, low;
				c -= 0x10000;
				high = htons(c/0x400 + 0xD800);
				low  = htons(c%0x400 + 0xDC00);
				sv_catpvn(str, (char*)&high, 2);
				sv_catpvn(str, (char*)&low,  2);
			    }
			}
		    }
                } else if ((u & 0374) == 0370) {
                    /* 5 bytes to decode, can't happend */
		    if (DOWARN) warn("Can't represent 5 byte encoded chars");
                } else {
		    if (DOWARN) warn("Bad utf8 byte (0x%02X) ignored", u);
                }
            }
	}

	if (!RETVAL)
	    RETVAL = newSViv(0);

#line 528 "String.c"
	ST(0) = RETVAL;
	sv_2mortal(ST(0));
    }
    XSRETURN(1);
}


XS_EUPXS(XS_Unicode__String_byteswap2); /* prototype to pass -Wmissing-prototypes */
XS_EUPXS(XS_Unicode__String_byteswap2)
{
    dVAR; dXSARGS;
    dXSI32;
    PERL_UNUSED_VAR(cv); /* -W */
    PERL_UNUSED_VAR(ax); /* -Wall */
    SP -= items;
    {
#line 358 "String.xs"
        int i; 
        char c;
        STRLEN len; 
        char* str; 

#line 551 "String.c"
#line 364 "String.xs"
	for (i = 0; i < items; i++) {
	    SV* sv = ST(i);
	    STRLEN len;
            char* src = SvPV(sv, len);
            char* dest;

	    if (GIMME_V != G_VOID) {
		SV* dest_sv = sv_2mortal(newSV(len+1));
		SvCUR_set(dest_sv, len);
		*SvEND(dest_sv) = 0;
		SvPOK_on(dest_sv);
		PUSHs(dest_sv);
		dest = SvPVX(dest_sv);
            } else {
		if (SvREADONLY(sv)) {
		    die("byteswap argument #%d is readonly", i+1);
		    continue;  /* probably not */
		}
		dest = src;
            }

	    if (ix == 2) {	
	        while (len >= 2) {
		    char tmp = *src++;
		    *dest++ = *src++;
		    *dest++ = tmp;
		    len -= 2;
                }
            }
	    else { /* ix == 4 */
		while (len >= 4) {
		    char tmp1 = *src++;
		    char tmp2 = *src++;
		    *dest++ = src[1];
		    *dest++ = src[0];
		    src += 2;
		    *dest++ = tmp2;
		    *dest++ = tmp1;
		    len -= 4;
                }
            }

	    if (len) {
		if (DOWARN) 
		    warn("byteswap argument #%d not long enough", i+1);

		/* this will be a no-op unless dest/src are different */
		while (len--)
		   *dest++ = *src++;
            }
	}
#line 604 "String.c"
	PUTBACK;
	return;
    }
}

#ifdef __cplusplus
extern "C"
#endif
XS_EXTERNAL(boot_Unicode__String); /* prototype to pass -Wmissing-prototypes */
XS_EXTERNAL(boot_Unicode__String)
{
    dVAR; dXSARGS;
#if (PERL_REVISION == 5 && PERL_VERSION < 9)
    char* file = __FILE__;
#else
    const char* file = __FILE__;
#endif

    PERL_UNUSED_VAR(cv); /* -W */
    PERL_UNUSED_VAR(items); /* -W */
#ifdef XS_APIVERSION_BOOTCHECK
    XS_APIVERSION_BOOTCHECK;
#endif
    XS_VERSION_BOOTCHECK;

    {
        CV * cv;

        newXS("Unicode::String::latin1", XS_Unicode__String_latin1, file);
        newXS("Unicode::String::ucs4", XS_Unicode__String_ucs4, file);
        newXS("Unicode::String::utf8", XS_Unicode__String_utf8, file);
        cv = newXS("Unicode::String::byteswap4", XS_Unicode__String_byteswap2, file);
        XSANY.any_i32 = 4;
        cv = newXS("Unicode::String::byteswap2", XS_Unicode__String_byteswap2, file);
        XSANY.any_i32 = 2;
    }
#if (PERL_REVISION == 5 && PERL_VERSION >= 9)
  if (PL_unitcheckav)
       call_list(PL_scopestack_ix, PL_unitcheckav);
#endif
    XSRETURN_YES;
}

