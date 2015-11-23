//
//  BBFrameworksMacrosPrivate.h
//  BBFrameworks
//
//  Created by William Towe on 11/14/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef __BB_FRAMEWORKS_MACROS_PRIVATE__
#define __BB_FRAMEWORKS_MACROS_PRIVATE__

/**
 Everything taken verbaitim from https://github.com/jspahrsummers/libextobjc taking care to rename all the symbols so they won't conflict with other clients that use that library or other libraries that rely on it internally (e.g. ReactiveCocoa).
 */

/**
 Private macros that BBKeypath relies upon.
 */
#define BBkeypath1(PATH) \
(((void)(NO && ((void)PATH, NO)), strchr(# PATH, '.') + 1))

#define BBkeypath2(OBJ, PATH) \
(((void)(NO && ((void)OBJ.PATH, NO)), # PATH))

/**
 * Returns A and B concatenated after full macro expansion.
 */
#define BBmetamacro_concat(A, B) \
BBmetamacro_concat_(A, B)

/**
 * Returns the Nth variadic argument (starting from zero). At least
 * N + 1 variadic arguments must be given. N must be between zero and twenty,
 * inclusive.
 */
#define BBmetamacro_at(N, ...) \
BBmetamacro_concat(BBmetamacro_at, N)(__VA_ARGS__)

/**
 * Returns the number of arguments (up to twenty) provided to the macro. At
 * least one argument must be provided.
 *
 * Inspired by P99: http://p99.gforge.inria.fr
 */
#define BBmetamacro_argcount(...) \
BBmetamacro_at(20, __VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)

/**
 * Returns the first argument given. At least one argument must be provided.
 *
 * This is useful when implementing a variadic macro, where you may have only
 * one variadic argument, but no way to retrieve it (for example, because \c ...
 * always needs to match at least one argument).
 *
 * @code
 
 #define varmacro(...) \
 metamacro_head(__VA_ARGS__)
 
 * @endcode
 */
#define BBmetamacro_head(...) \
BBmetamacro_head_(__VA_ARGS__, 0)

/**
 * Returns every argument except the first. At least two arguments must be
 * provided.
 */
#define BBmetamacro_tail(...) \
BBmetamacro_tail_(__VA_ARGS__)

/**
 * Decrements VAL, which must be a number between zero and twenty, inclusive.
 *
 * This is primarily useful when dealing with indexes and counts in
 * metaprogramming.
 */
#define BBmetamacro_dec(VAL) \
BBmetamacro_at(VAL, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)

/**
 * Increments VAL, which must be a number between zero and twenty, inclusive.
 *
 * This is primarily useful when dealing with indexes and counts in
 * metaprogramming.
 */
#define BBmetamacro_inc(VAL) \
BBmetamacro_at(VAL, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21)

/**
 * If A is equal to B, the next argument list is expanded; otherwise, the
 * argument list after that is expanded. A and B must be numbers between zero
 * and twenty, inclusive. Additionally, B must be greater than or equal to A.
 *
 * @code
 
 // expands to true
 metamacro_if_eq(0, 0)(true)(false)
 
 // expands to false
 metamacro_if_eq(0, 1)(true)(false)
 
 * @endcode
 *
 * This is primarily useful when dealing with indexes and counts in
 * metaprogramming.
 */
#define BBmetamacro_if_eq(A, B) \
BBmetamacro_concat(BBmetamacro_if_eq, A)(B)
#define BBmetamacro_head_(FIRST, ...) FIRST
#define BBmetamacro_tail_(FIRST, ...) __VA_ARGS__
#define BBmetamacro_consume_(...)
#define BBmetamacro_expand_(...) __VA_ARGS__

// IMPLEMENTATION DETAILS FOLLOW!
// Do not write code that depends on anything below this line.
#define BBmetamacro_concat_(A, B) A ## B

// metamacro_at expansions
#define BBmetamacro_at0(...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at1(_0, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at2(_0, _1, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at3(_0, _1, _2, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at4(_0, _1, _2, _3, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at5(_0, _1, _2, _3, _4, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at6(_0, _1, _2, _3, _4, _5, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at7(_0, _1, _2, _3, _4, _5, _6, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at8(_0, _1, _2, _3, _4, _5, _6, _7, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at9(_0, _1, _2, _3, _4, _5, _6, _7, _8, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at10(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at11(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at12(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at13(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at14(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at15(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at16(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at17(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at18(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at19(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, ...) BBmetamacro_head(__VA_ARGS__)
#define BBmetamacro_at20(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) BBmetamacro_head(__VA_ARGS__)

// metamacro_if_eq expansions
#define BBmetamacro_if_eq0(VALUE) \
BBmetamacro_concat(BBmetamacro_if_eq0_, VALUE)

#define BBmetamacro_if_eq0_0(...) __VA_ARGS__ BBmetamacro_consume_
#define BBmetamacro_if_eq0_1(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_2(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_3(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_4(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_5(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_6(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_7(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_8(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_9(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_10(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_11(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_12(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_13(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_14(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_15(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_16(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_17(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_18(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_19(...) BBmetamacro_expand_
#define BBmetamacro_if_eq0_20(...) BBmetamacro_expand_

#define BBmetamacro_if_eq1(VALUE) BBmetamacro_if_eq0(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq2(VALUE) BBmetamacro_if_eq1(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq3(VALUE) BBmetamacro_if_eq2(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq4(VALUE) BBmetamacro_if_eq3(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq5(VALUE) BBmetamacro_if_eq4(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq6(VALUE) BBmetamacro_if_eq5(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq7(VALUE) BBmetamacro_if_eq6(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq8(VALUE) BBmetamacro_if_eq7(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq9(VALUE) BBmetamacro_if_eq8(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq10(VALUE) BBmetamacro_if_eq9(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq11(VALUE) BBmetamacro_if_eq10(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq12(VALUE) BBmetamacro_if_eq11(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq13(VALUE) BBmetamacro_if_eq12(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq14(VALUE) BBmetamacro_if_eq13(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq15(VALUE) BBmetamacro_if_eq14(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq16(VALUE) BBmetamacro_if_eq15(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq17(VALUE) BBmetamacro_if_eq16(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq18(VALUE) BBmetamacro_if_eq17(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq19(VALUE) BBmetamacro_if_eq18(BBmetamacro_dec(VALUE))
#define BBmetamacro_if_eq20(VALUE) BBmetamacro_if_eq19(BBmetamacro_dec(VALUE))

#endif /* BBFrameworksMacrosPrivate_h */
