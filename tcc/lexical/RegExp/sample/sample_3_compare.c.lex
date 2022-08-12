TOKEN-TYPE          TOKEN-VALUE
-------------------------------------------------
T_Int               int
T_Identifier        main
(                   (
)                   )
{                   {
T_Print             print
(                   (
T_StringConstant    "1 == 2 is %d"
,                   ,
T_IntConstant       1
T_Eq                ==
T_IntConstant       2
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "2 == 2 is %d"
,                   ,
T_IntConstant       2
T_Eq                ==
T_IntConstant       2
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "2 == 3 is %d"
,                   ,
T_IntConstant       2
T_Eq                ==
T_IntConstant       3
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "1 != 2 is %d"
,                   ,
T_IntConstant       1
T_Ne                !=
T_IntConstant       2
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "2 != 2 is %d"
,                   ,
T_IntConstant       2
T_Ne                !=
T_IntConstant       2
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "2 != 3 is %d"
,                   ,
T_IntConstant       2
T_Ne                !=
T_IntConstant       3
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "1 >  2 is %d"
,                   ,
T_IntConstant       1
>                   >
T_IntConstant       2
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "2 >  2 is %d"
,                   ,
T_IntConstant       2
>                   >
T_IntConstant       2
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "2 >  3 is %d"
,                   ,
T_IntConstant       2
>                   >
T_IntConstant       3
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "1 <  2 is %d"
,                   ,
T_IntConstant       1
<                   <
T_IntConstant       2
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "2 <  2 is %d"
,                   ,
T_IntConstant       2
<                   <
T_IntConstant       2
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "2 <  3 is %d"
,                   ,
T_IntConstant       2
<                   <
T_IntConstant       3
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "1 >= 2 is %d"
,                   ,
T_IntConstant       1
T_Ge                >=
T_IntConstant       2
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "2 >= 2 is %d"
,                   ,
T_IntConstant       2
T_Ge                >=
T_IntConstant       2
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "2 >= 3 is %d"
,                   ,
T_IntConstant       2
T_Ge                >=
T_IntConstant       3
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "1 <= 2 is %d"
,                   ,
T_IntConstant       1
T_Le                <=
T_IntConstant       2
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "2 <= 2 is %d"
,                   ,
T_IntConstant       2
T_Le                <=
T_IntConstant       2
)                   )
;                   ;
T_Print             print
(                   (
T_StringConstant    "2 <= 3 is %d"
,                   ,
T_IntConstant       2
T_Le                <=
T_IntConstant       3
)                   )
;                   ;
T_Return            return
T_IntConstant       0
;                   ;
}                   }
