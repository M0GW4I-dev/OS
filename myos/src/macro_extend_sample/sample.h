#define A 1

#if defined (A)
#define LOCAL(sym) _ ## sym

#define FUNCTION(x) .global LOCAL(x) ; LOCAL(x):
#endif

