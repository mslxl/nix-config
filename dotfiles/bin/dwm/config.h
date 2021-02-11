#include <X11/XF86keysym.h>
/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 0;        /* 0 means bottom bar */
static const char *fonts[]          = { "SauceCodePro Nerd Font Mono:size=12" };
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#ffffff";
static const char col_cyan[]        = "#37474F";
static const unsigned int baralpha = 0xd0;
static const unsigned int borderalpha = OPAQUE;
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};
static const unsigned int alphas[][3]      = {
	/*               fg      bg        border     */
	[SchemeNorm] = { OPAQUE, baralpha, borderalpha },
	[SchemeSel]  = { OPAQUE, baralpha, borderalpha },
};
 

/* tagging */
static const char *tags[] = { "Unu", "Du", "Tri", "Kvar", "Kvin", "Ses", "Sep", "Ok", "Naŭ" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "rofi",     NULL,       NULL,       0,            1,           -1 },
	//  { "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(CHAIN,KEY,TAG) \
	{ MODKEY,                       CHAIN,    KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           CHAIN,    KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             CHAIN,    KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, CHAIN,    KEY,      toggletag,      {.ui = 1 << TAG} },
/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/zsh", "-c", cmd, NULL } }

/* commands */
static const char *rofiruncmd[] = {"zsh", "-c", "rofi -show run -theme $HOME/.dwm/slate.rasi", NULL };
static const char *rofidruncmd[] = { "zsh", "-c", "rofi -show drun -theme $HOME/.dwm/slate.rasi", NULL };
static const char *trayercmd[] = {"zsh", "-c", "$HOME/.dwm/trayer-toggle.sh", NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *volupcmd[] = {"zsh", "-c", "$HOME/.dwm/vol-up.sh", NULL };
static const char *voldowncmd[] = {"zsh", "-c", "$HOME/.dwm/vol-down.sh", NULL };
static const char *voltogglecmd[] = {"zsh", "-c", "$HOME/.dwm/vol-toggle.sh", NULL };
static const char *slockcmd[] = {"slock", NULL };
static const char scratchpadname[] = "scratchpad";
static const char *scratchpadcmd[] = { "st", "-t", scratchpadname, "-g", "120x34", NULL };



static Key keys[] = {
	/* modifier            chain key	key        function        argument */
	{ MODKEY|ShiftMask,		-1,			XK_r,      					spawn,          {.v = rofiruncmd } },
	{ MODKEY,				-1,			XK_r,      					spawn,          {.v = rofidruncmd } },
	{ MODKEY,				-1,			XK_p,      					spawn,          {.v = trayercmd } },
	{ MODKEY,				-1,			XK_Return, 					spawn,          {.v = termcmd } },
	{ MODKEY,				XK_v,		XK_l,						spawn,          {.v = volupcmd } },
	{ MODKEY,				XK_v,		XK_h,						spawn,          {.v = voldowncmd } },
	{ MODKEY,				XK_v,		XK_space, 					spawn,          {.v = voltogglecmd } },
	{ MODKEY,				-1,			XF86XK_AudioRaiseVolume,	spawn,          {.v = volupcmd } },
	{ MODKEY,				-1,			XF86XK_AudioLowerVolume,	spawn,          {.v = voldowncmd } },
	{ MODKEY,				-1,			XF86XK_AudioMute,			spawn,          {.v = voltogglecmd } },
	{ MODKEY,				-1,			XK_grave,  					togglescratch,  {.v = scratchpadcmd } },
	{ MODKEY|ShiftMask,		-1,			XK_l,      					spawn,          {.v = slockcmd } },
//	{ MODKEY,				-1,			XK_b,      					togglebar,      {0} },
	{ MODKEY|ShiftMask,		-1,			XK_j,      					rotatestack,    {.i = +1 } },
	{ MODKEY|ShiftMask,		-1,			XK_k,      					rotatestack,    {.i = -1 } },
	{ MODKEY,				-1,			XK_j,      					focusstack,     {.i = +1 } },
	{ MODKEY,				-1,			XK_k,      					focusstack,     {.i = -1 } },
	{ MODKEY,				XK_m,		XK_i,      					incnmaster,     {.i = +1 } },
	{ MODKEY,				XK_m,		XK_d,      					incnmaster,     {.i = -1 } },
	{ MODKEY,				-1,			XK_h,      					setmfact,       {.f = -0.05} },
	{ MODKEY,				-1,			XK_l,      					setmfact,       {.f = +0.05} },
//	{ MODKEY,				-1,			XK_Return, 					zoom,           {0} },
	{ MODKEY,				-1,			XK_Tab,    					view,           {0} },
	{ MODKEY|ShiftMask,		-1,			XK_c,      					killclient,     {0} },
	{ MODKEY|ShiftMask,		XK_t,		XK_t,      					setlayout,      {.v = &layouts[0]} },
	{ MODKEY|ShiftMask,		XK_t,		XK_f,      					setlayout,      {.v = &layouts[1]} },
	{ MODKEY|ShiftMask,		XK_t,		XK_m,      					setlayout,      {.v = &layouts[2]} },
	{ MODKEY,				XK_t,		XK_space,  					setlayout,      {0} },
	{ MODKEY,				-1,			XK_f,      					fullscreen,     {0} },
	{ MODKEY|ShiftMask,		-1,			XK_space,  					togglefloating, {0} },
	{ MODKEY,				-1,			XK_0,      					view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,		-1,			XK_0,      					tag,            {.ui = ~0 } },
	{ MODKEY,				-1,			XK_comma,  					focusmon,       {.i = -1 } },
	{ MODKEY,				-1,			XK_period, 					focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,		-1,			XK_comma,  					tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,		-1,			XK_period, 					tagmon,         {.i = +1 } },
	{ MODKEY|ShiftMask,     XK_q,	    XK_q,      					quit,           {0} },
	TAGKEYS(                -1,			XK_1,                      0)
	TAGKEYS(                -1,			XK_2,                      1)
	TAGKEYS(                -1,			XK_3,                      2)
	TAGKEYS(                -1,			XK_4,                      3)
	TAGKEYS(                -1,			XK_5,                      4)
	TAGKEYS(                -1,			XK_6,                      5)
	TAGKEYS(                -1,			XK_7,                      6)
	TAGKEYS(                -1,			XK_8,                      7)
	TAGKEYS(                -1,			XK_9,                      8)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

